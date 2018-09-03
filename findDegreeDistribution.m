%% ---------------------- findDegreeDistribution---------------------------
% Avik Mondal
% 
% Aim:
% - this function aims to find the degree distribution of a network
%
% Parameters:   
% 
% struct node - contains the nodes generated from converting skeletonBin to
%    a graph
%--------------------------------------------------------------------------
function findDegreeDistribution(node)

numOfLinks = zeros(length(node),1);

for index = 1:length(node)
    if length(node(index).links) > 2 %length 1's and 2's are artifacts of network conversion
        numOfLinks(index) = length(node(index).links);
    end
end

figure();
histogram(numOfLinks);
[N,edges] = histcounts(numOfLinks);
xULim = max(edges) + 0.5;
yULim = max(N(1,2:length(N)))*1.2;
%finds the largest bin and determines the y axis upper limit based off that


axis([2 xULim 0 yULim]);
title("Node Degree Distribution", 'FontSize', 14);
xlabel("Number of links (k)", 'FontSize', 14);
ylabel("Number of Nodes with k links", 'FontSize', 14);





