%% ---------------------- findLinkDirection ------------------------------
% Avik Mondal
% 
% Aim:
% - this function takes the links post abaqus analysis and computes their
% direction
%
% Parameters:
% struct node_trunc - nodes generated using convert_split_to_skel.m
% struct link_trunc - links generated using convert_split_to_skel.m
%--------------------------------------------------------------------------
function linkWithDirection = findLinkDirection(node_trunc, link_trunc)

linkWithDirection = link_trunc;

for linkIndex = 1:length(linkWithDirection)
    node1 = linkWithDirection(linkIndex).n1;
    node2 = linkWithDirection(linkIndex).n2;
    point1 = [node_trunc(node1).comx, node_trunc(node1).comy, node_trunc(node1).comz];
    point2 = [node_trunc(node2).comx, node_trunc(node2).comy, node_trunc(node2).comz];
    pointdiff = point1 - point2; 
    pointdiffmagnitude = dot(pointdiff, pointdiff);
    linkWithDirection(linkIndex).direction = pointdiff/( pointdiffmagnitude^(.5));
end