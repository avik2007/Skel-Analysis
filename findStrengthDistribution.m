%% ---------------------- findStrengthDistribution ------------------------
% Avik Mondal
% 
% Aim:
% - this function aims to find the node strength distribution of a network 
%
% Parameters:   
% 
% struct node - contains the nodes generated from converting skeletonBin to
%    a graph
% 
% defined in The architeture of complex networks, (A. Barat et. al)
%--------------------------------------------------------------------------
function findStrengthDistribution(node)

maxStrength = max([node.strength]);

strengthOfLinks = zeros(length(find([node.ep] == 0)),1);

for index = 1:nodesLength
    if length(node(index).links) > 2 %length 1's and 2's are artifacts of network conversion
        strengthOfLinks(index) = node(index).strength/maxStrength;
    end
end
%POSSIBLY CALCULATE A METHOD OF IGNORING ALL THE DEGREE 1 NODES (AND DEGREE
%2 NODES)
figure();
histogram(strengthOfLinks);
[N,~] = histcounts(strengthOfLinks);

yULim = max(N(1,1:length(N)))*1.2;
%finds the largest bin and determines the y axis upper limit based off that


axis([0.1 1 0 yULim]);
title("Weighted Node Degree Distribution", 'FontSize', 14);
xlabel("Weighted Degree of Nodes (W)",'FontSize', 14);
ylabel("Number of Nodes with Weight W ",'FontSize', 14);