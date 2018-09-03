%% ------------------- findLocalWeightedClustering ----------------------
% Avik Mondal
% 
% Aim:
% - this function outputs the local weighted clustering coefficient of a
% node (as defined by A. Barat et. al, 2004 )
%
% Parameters:   
% 
% struct node - contains the nodes generated from converting skeletonBin to
%    a graph
% int16 i - index of the node for which the clustering coefficient is
%    calculated
%--------------------------------------------------------------------------
function CCi = findLocalClustering(node,i)

neighborIndices = node(i).conn;  %indexes of neighboring nodes
ki = length(neighborIndices); %number of neighbors
triplesNumber = ki*(ki-1)*0.5; %number of "triples"
trianglesNumber = 0;
for index = 1:ki
    currentNode = neighborIndices(index);
    members = ismember(node(currentNode).conn, neighborIndices);
    trianglesNumber = trianglesNumber + ( sum(members) )/2;
end
if ( triplesNumber < 2 )
    CCi = 0;
else
    CCi = mrdivide(trianglesNumber,triplesNumber); 
end
