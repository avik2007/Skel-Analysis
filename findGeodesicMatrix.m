%% ----------------- findGeodesicMatrix -------------------------
% Avik Mondal
% 
% Aim:
% - this function finds the shortest path between all the nodes and outputs
%  an array containing components d(i,j), where i is node 1 and j is node
%  2. d(i,j) = d(j,i).
%
% Parameters:   
% 
% struct node - contains the nodes generated from converting skeletonBin to
%    a graph
% struct link - contains the links generated from converting skeletonBin to
%    a graph
% array skel - binary array of the skeleton VOI
%
%--------------------------------------------------------------------------
function geodesicMatrix = findGeodesicMatrix(node,link,skel)
nodeSize = length(node);
geodesicMatrix = zeros(nodeSize,nodeSize);
for i=1:( nodeSize - 1 )
    for j = ( i + 1 ):nodeSize
        geodesicMatrix(i,j) = findShortestPathLength(node,link,skel,i,j);
        geodesicMatrix(j,i) = geodesicMatrix(i,j);
    end
end

