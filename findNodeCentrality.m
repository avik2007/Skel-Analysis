%% ----------------- findNodeCentrality -------------------------
% Avik Mondal
% 
% Aim:
% - this function outputs the centrality measures of the network
%
% Parameters:   
% 
% struct node - contains the nodes generated from converting skeletonBin to
%    a graph
% struct link - contains the links generated from converting skeletonBin to
%    a graph
% array skel - binary array of the skeleton VOI
%
%closeness centrality formulation: 
% https://toreopsahl.com/2010/03/20/closeness-centrality-in-networks-with-disconnected-components/
%~because my networks can be disconnected, I've used harmonic centrality
% 
% this requires a isolated subgraph!!!!!!!!!!!!
%--------------------------------------------------------------------------
function node2 = findNodeCentrality(node,link)

A = createAdjacencyMatrix(node,link, 'none');
G = graph(A); 
node2 = node;
node_centrality(1,:) = (centrality(G, 'betweenness'));
node_centrality(2,:) = (centrality(G, 'closeness'));
node_centrality(3,:) = (centrality(G, 'eigenvector'));
node_centrality(4,:) = (centrality(G, 'degree'));
node_centrality = node_centrality';

for i = 1:length(node_centrality)
    node2(i).betweenness = node_centrality(i,1);
    node2(i).closeness = node_centrality(i,2);
    node2(i).eigenvector = node_centrality(i,3);
    node2(i).degreeC = node_centrality(i,4);
end