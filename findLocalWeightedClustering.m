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
% struct link - contains the links generated from converting skeletonBin to
%    a graph
% int16 ki - index of the node for which the clustering coefficient is
%    calculated
%--------------------------------------------------------------------------
function CCi = findLocalWeightedClustering(node,link,i)

neighborIndices = node(i).conn;  %indexes of neighboring nodes
ki = length(neighborIndices); %number of neighbors
coefficient = 1.0 / ( node(i).strength*(ki - 1) );
if ( ki < 2 )
    CCi = 0;
else    
    CCi = 0;
    for j = 1:ki-1
        for h = (j+1):ki
            wih = 0;
            wij = 0;
            ajh = 0;
            if sum( ismember( node(i).conn(h), node( node(i).conn(j)).conn ) ) > 0
                wih = link(node(i).links(h)).avgthickness;
                wij = link(node(i).links(j)).avgthickness;
                ajh = 1;
            end    
            CCi = CCi + (wih + wij)/2.0*ajh;
        end
    end
    CCi = CCi * coefficient;
end
