%% ----------------- processSTRESS_TRUNC -------------------------
%% THIS IS A SCRIPT
% Avik Mondal
% 
% Aim:
% this script takes the bulk processed trunc files and their respective
% stresses and a) combines them and b) processes data on them
% - this is for the stage in the process where we're trying to collect
% statistics on multiple VOI's instead of just one
%
% Workspace:
% link_trunc, node_trunc, stress_data for appropriate VOI
% - set stress_data equal to the appropriate variable
%--------------------------------------------------------------------------
%% Adds final stresses to link_trunc.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
stress_data = link_stress_time;
numTimesteps = size(stress_data,2);
for index1 = 1:length(link_trunc)
    link_trunc(index1).finalStress = stress_data(index1, numTimesteps);
end 
%% set up stuff
addpath('C:\Users\Avik Mondal\Documents\Carlson Lab\Bone Project MATLAB code\matlab-networks-toolbox');
addpath('C:\Users\Avik Mondal\Documents\Carlson Lab\Bone Project MATLAB code');
%% Finds length of links
link_trunc = findLinkLength(node_trunc,link_trunc, numTimesteps);
% this is real bad code, but the last parameter in findLinkLength is
% supposed to be the skeleton. however, the trunc skeleton doesn't have
% such a construct, nor does it need that to calculate the relevant lengths
% here. thus, any filler parameter will do as long as your node and link
% are of the trunc category (go to findLinkLength to see what that entails)
%% Calculates thickness-length ratio
for index = 1:length(link_trunc)
    link_trunc(index).thicklengthratio = link_trunc(index).avgthickness / link_trunc(index).length; 
end
%% Calculate orientation of links
for oindex=1:length(link_trunc)
    node1 = link_trunc(oindex).n1;
    node2 = link_trunc(oindex).n2;
    node1location = [node_trunc(node1).comx, node_trunc(node1).comy, node_trunc(node1).comz];
    node2location = [node_trunc(node2).comx, node_trunc(node2).comy, node_trunc(node2).comz];
    difference = node2location-node1location;
    direction = difference / sqrt(dot(difference,difference)) ;
    link_trunc(oindex).zorientation = direction(1,3);
    link_trunc(oindex).yorientation = direction(1,2);
    link_trunc(oindex).xorientation = direction(1,1);
end
clear difference node1location node1 node2location node2 oindex index direction

%% Calculating Stress/Time Derivatives
for dindex = 1:length(link_trunc)
    %max_link_derivatives(dindex,1) = mean(gradient(link_stress_time(orderedStresses(dindex,2),:)));
    link_trunc(dindex).stressDerivative = mean(gradient(stress_data(dindex,:)));
end
clear dindex;
%gradient is constant since these stresses are calculated in the linear
%regime 

%% Generating all the relevant adjacency matrices
adj = createAdjacencyMatrix(node_trunc,link_trunc,'binary');
A = graph(adj); 
Th = graph(createAdjacencyMatrix(node_trunc,link_trunc,'thickness'));
Str = graph(createAdjacencyMatrix(node_trunc,link_trunc,'stress'));
Len = graph(createAdjacencyMatrix(node_trunc,link_trunc,'length'));

%% Node Betweenness network centrality measures
[bmatrix(1,:)] = centrality(A,'betweenness');
[bmatrix(2,:)] = centrality(Th,'betweenness', 'Cost', Th.Edges.Weight);
[bmatrix(3,:)] = centrality(Str,'betweenness', 'Cost', Str.Edges.Weight);
[bmatrix(4,:)] = centrality(Len,'betweenness', 'Cost', Len.Edges.Weight);
bmatrix = bmatrix';

%% Node Closeness network centrality measures
[cmatrix(1,:)] = centrality(A,'closeness');
[cmatrix(2,:)] = centrality(Th,'closeness', 'Cost', Th.Edges.Weight);
[cmatrix(3,:)] = centrality(Str, 'closeness', 'Cost', Str.Edges.Weight);
[cmatrix(4,:)] = centrality(Len, 'closeness', 'Cost', Len.Edges.Weight);
cmatrix=cmatrix';

%% Node Degree network centrality measures 
[dmatrix(1,:)] = centrality(A, 'degree');
[dmatrix(2,:)] = centrality(Th, 'degree', 'Importance', Th.Edges.Weight);
[dmatrix(3,:)] = centrality(Str, 'degree', 'Importance', Str.Edges.Weight);
[dmatrix(4,:)] = centrality(Len, 'degree', 'Importance', Len.Edges.Weight);
dmatrix = dmatrix';
%% Node Eigenvector network centrality measures
[ematrix(1,:)] = centrality(A, 'eigenvector');
[ematrix(2,:)] = centrality(Th, 'eigenvector', 'Importance', Th.Edges.Weight); 
[ematrix(3,:)] = centrality(Str, 'eigenvector', 'Importance', Str.Edges.Weight);
[ematrix(4,:)] = centrality(Len, 'eigenvector', 'Importance', Len.Edges.Weight);
ematrix = ematrix';
%% Calculating Link Betweenness

linkBetweennessList = edgeBetweenness(adj);
linkBetweennessMatrix = zeros(length(node_trunc), length(node_trunc));
for i = 1:length(node_trunc)
    linkBetweennessMatrix(linkBetweennessList(i,1), linkBetweennessList(i,2)) = linkBetweennessList(i,3);
    linkBetweennessMatrix(linkBetweennessList(i,2), linkBetweennessList(i,1)) = linkBetweennessList(i,3);
end
for j = 1:length(link_trunc)
    link_trunc(j).linkBetweenness = linkBetweennessMatrix(link_trunc(j).n1, link_trunc(j).n2);
end

clear linkBetweennessList linkBetweennessMatrix i j;

%% clustering coefficient
[~,~,C] = clustCoeff(adj);
for ci = 1:length(node_trunc)
    node_trunc(ci).clustcoeff = C(ci,1);
end