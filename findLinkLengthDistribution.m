%% ---------------------- findLinkLengthDistribution---------------------------
% Avik Mondal
% 
% Aim:
% - this function aims to find the link voxel length  distribution for a
% specific node of a network
%
% Parameters:   
% 
% struct node - contains the nodes generated from converting skeletonBin to
%    a graph
%--------------------------------------------------------------------------
function findLinkLengthDistribution(node,link, nodeindex)
links = node(nodeindex).links;

lengthOfLinks = zeros(length(links),1);

for index = 1:length(links)
    
    lengthOfLinks(index,1) = length(link(links(index)).point);
end

figure();
histogram(lengthOfLinks);
[N,edges] = histcounts(lengthOfLinks);
xULim = max(edges) + 0.5;
yULim = max(N(1,2:length(N)))*1.2;
%finds the largest bin and determines the y axis upper limit based off that


axis([1 xULim 0 yULim]);
title(strcat("Link Length Distribution: Node ",num2str(259)));
xlabel("Number of links (l)");
ylabel("Number of links w/ length l");





