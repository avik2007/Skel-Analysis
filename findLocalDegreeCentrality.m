%% ------------------ findLocalDegreeCentrality---------------------------
% Avik Mondal
% 
% Aim:
% - this function outputs the normalized local degree centrality of a node
%
% Parameters:   
% 
% struct node - contains the nodes generated from converting skeletonBin to
%    a graph
% int16 i - index of the node for which the degree centrality is
%    calculated
%--------------------------------------------------------------------------
function DCi = findLocalDegreeCentrality(node,i)

DCi = ( length(node(i).conn ) )/( length(node)-1 ) ;


