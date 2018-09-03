%% ------------------ findNearestNeighborDegree ---------------------------
% Avik Mondal
% 
% Aim:
% - this function outputs the local weighted nearest neighbor degree
% (only use this in getNodeLinkProperties because otherwise the value is
% off by a factor of the max network node strength)
%
% Parameters:   
% 
% struct node - contains the nodes generated from converting skeletonBin to
%    a graph
% int16 i - index of the node for which the degree centrality is
%    calculated
%--------------------------------------------------------------------------
function knn_i = findNearestNeighborStrength(node,link,i)
links = node(i).links;
neighbors = node(i).conn;
knn_i = 0;
strength_i = node(i).strength;
for j = 1:length(neighbors)
    strength_ij = link(links(j)).avgthickness;
    degree_ij = length(node(neighbors(j)).conn);
    knn_i = knn_i + strength_ij*degree_ij;
end
knn_i = knn_i/strength_i;