%% ---------------------- findLinkCentroid ------------------------------
% Avik Mondal
% 
% Aim:
% - this function takes the links post abaqus analysis and computes their
% centroid
%
% Parameters:
% struct node_trunc - nodes generated using convert_split_to_skel.m
% struct link_trunc - links generated using convert_split_to_skel.m
%--------------------------------------------------------------------------
function linkWithCentroid = findLinkCentroid(node_trunc, link_trunc)

linkWithCentroid = link_trunc;

for linkIndex = 1:length(linkWithCentroid)
    node1 = linkWithCentroid(linkIndex).n1;
    node2 = linkWithCentroid(linkIndex).n2;
    point1 = [node_trunc(node1).comx, node_trunc(node1).comy, node_trunc(node1).comz];
    point2 = [node_trunc(node2).comx, node_trunc(node2).comy, node_trunc(node2).comz];
    pointdiff = point1 - point2; 
    linkWithCentroid(linkIndex).centroid = point2 + pointdiff*0.5;
end