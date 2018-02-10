%------------------------ getNodeLinkProperties ------------------------------
% Avik Mondal
% 
% Aim:
% - this function calculates the different network properties of the nodes
% and creates a new data structure including these properties
%
% Parameters:   
% 
% struct node - contains the nodes generated from converting skeletonBin to
%    a graph
% struct link - contains the links generated from converting skeletonBin to
%    a graph
% array skel - binary array of the skeleton VOI
%
% I reformulate all the centralities to be normalized against the max value
% of the set (instead of by the number of nodes)
%--------------------------------------------------------------------------
function [nodeWithProperties,linkWithProperties] = getNodeLinkProperties(node,link)

nodeWithProperties = node;
linkWithProperties = link;
%if ~(isfield(nodeWithProperties,'closenessC'))
%    geo = findGeodesicMatrix(node,link,skel);
%end
maxDegree = 0;
%maxClustering = 0;
%maxCloseness = 0;
maxNodeStrength = 0;
maxNNDegree = 0;
maxNNStrength = 0;
%maxWeightedClustering = 0;
for index = 1:length(node)
    if ( length(nodeWithProperties(index).conn) < 3 )
        nodeWithProperties(index).ep = 1;
    else
        nodeWithProperties(index).ep = 0;
    end
end
for index1 = 1:length(node)
    
    %for  calculating degree centrality normalized by max degree
    if ( nodeWithProperties(index1).ep == 1 )
        nodeWithProperties(index1).degreeC = 0;
    else
        nodeWithProperties(index1).degreeC = findLocalDegreeCentrality(node,index1);
    end
    
    if ( (nodeWithProperties(index1).degreeC) > (maxDegree) )
        maxDegree = nodeWithProperties(index1).degreeC;
    end
        
    %for calculating clustering coefficient normalized by max clustering
    %nodeWithProperties(index1).clusteringC = findLocalClustering(node,index1);
    %if ( nodeWithProperties(index1).clusteringC > maxClustering )
    %    maxClustering = nodeWithProperties(index1).clusteringC;
    %end    
    % for calculating closeness centrality normalized by max closeness
    %nodeWithProperties(index1).closenessC = findLocalClosenessCentrality(geo,index1);
    %if ( nodeWithProperties(index1).closenessC > maxCloseness )
    %    maxCloseness = nodeWithProperties(index1).closenessC;
    %end    
    
    %}
    %for calculating node strength normalized by max node strength
    if ( nodeWithProperties(index1).ep == 1 )
        nodeWithProperties(index1).strength = 0;
    else
        nodeWithProperties(index1).strength = findNodeStrength(node,link,index1);
    end
    
    if ( nodeWithProperties(index1).strength > maxNodeStrength )
        maxNodeStrength = nodeWithProperties(index1).strength;
    end
    
    if ( nodeWithProperties(index1).ep == 1 )
        nodeWithProperties(index1).nearestNeighborDegree = 0;
    else
        nodeWithProperties(index1).nearestNeighborDegree = findNearestNeighborDegree(nodeWithProperties,linkWithProperties,index1);
    end
    
    if ( (nodeWithProperties(index1).nearestNeighborDegree) > (maxNNDegree) )
        maxNNDegree = nodeWithProperties(index1).nearestNeighborDegree;
    end
    
    if ( nodeWithProperties(index1).ep == 1 )
        nodeWithProperties(index1).nearestNeighborStrength = 0;
    else
        nodeWithProperties(index1).nearestNeighborStrength = findNearestNeighborStrength(nodeWithProperties,linkWithProperties,index1);
    end
    
    if ( (nodeWithProperties(index1).nearestNeighborStrength) > (maxNNStrength) )
        maxNNStrength = nodeWithProperties(index1).nearestNeighborStrength;
    end

end

for index2 = 1:length(node)
    
    nodeWithProperties(index2).degreeC = ( nodeWithProperties(index2).degreeC / maxDegree );
    %nodeWithProperties(index2).clusteringC = ( nodeWithProperties(index2).clusteringC / maxClustering );
    %nodeWithProperties(index2).closenessC = ( nodeWithProperties(index2).closenessC / maxCloseness );
    
    nodeWithProperties(index2).strength = ( nodeWithProperties(index2).strength / maxNodeStrength );
    nodeWithProperties(index2).nearestNeighborDegree = ( nodeWithProperties(index2).nearestNeighborDegree / maxNNDegree );
    nodeWithProperties(index2).nearestNeighborStrength = ( nodeWithProperties(index2).nearestNeighborStrength / maxNNStrength );
    
end

%{
for index3 = 1:length(node)
    nodeWithProperties(index3).weightedCC = findLocalWeightedClustering(nodeWithProperties,link,index3);
    if ( nodeWithProperties(index3).weightedCC > maxWeightedClustering )
        maxWeightedClustering = nodeWithProperties(index3).weightedCC;
    end    
end
%}
%for index4 = 1:length(node)
%    nodeWithProperties(index4).weightedCC = ( nodeWithProperties(index4).weightedCC / maxWeightedClustering );
%end



maxLinkLength = 0; 
for index5 = 1:length(link)
    linkWithProperties(index5).length = length(link(index5).point);
    if ( linkWithProperties(index5).length > maxLinkLength )
        maxLinkLength = linkWithProperties(index5).length;
    end
end

linkWithProperties(1).maxLength = maxLinkLength;
for index6 = 1:length(link)
    linkWithProperties(index6).length = ( linkWithProperties(index6).length / maxLinkLength );
end
