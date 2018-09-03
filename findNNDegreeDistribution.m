%% ---------------------- findNNDegreeDistribution---------------------------
% Avik Mondal
% 
% Aim:
% - this function aims to find the nearest neighbor degree 
%   distribution of a network
%
% Parameters:   
% 
% struct node - contains the nodes generated from converting skeletonBin to
%    a graph
%--------------------------------------------------------------------------
function findNNDegreeDistribution(node)

NNDegree_i = zeros(length(find([node.ep] == 0)),1);
% using a for loop to avoid the 1's and the 2's
for index = 1:length(node)
    if length(node(index).links) > 2 %length 1's and 2's are artifacts of network conversion
        NNDegree_i(index) = node(index).nearestNeighborDegree;
    end
end

figure();
histogram(NNDegree_i);
[N,edges] = histcounts(NNDegree_i);
xULim = max(edges) + 0.5;
yULim = max(N(1,2:length(N)))*1.2;
%finds the largest bin and determines the y axis upper limit based off that


axis([0 xULim 0 yULim]);
title("Nearest Neighbor Node Degree Distribution");
xlabel("Number of links (k)");
ylabel("Number of Nodes w/ Neighbors w/ k links");





