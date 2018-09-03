%% ----------------------- findCorrelationLength --------------------------
% Avik Mondal
% 
% Aim:
% - this function aims to find the correlation length of a given skeleton
% network
%
% Parameters:   
% array skel - skeletonized binary VOI
% struct node - contains the nodes generated from converting skeletonBin to
%    a graph
% struct link - contains the links generated from converting skeletonBin to
%    a graph
%--------------------------------------------------------------------------
function CorrL = findCorrelationLength(node,link,skel)
if ( isfield(node,'subGraph') )
    node2 = node;
    link2 = link;
else
    [node2,link2] = findSubGraphs(node,link,skel);
end
subgraphNums = [node2.subGraph];
subgraphPick = mode(subgraphNums);
startingNodes = findStartingNodes(node2,skel,subgraphPick);
endingNodes = findEndingNodes(node2,skel,subgraphPick);
lengthList = zeros(length(startingNodes)*length(endingNodes),1);


for s = 1: length(startingNodes)
    for e = 1:length(endingNodes)
        %disp( ( s - 1 )*( length( endingNodes ) ) + e );
        lengthList( ( s - 1 )  * ( length( endingNodes ) )+ e ) = findShortestPathLength(node2,link2,skel,startingNodes(s),endingNodes(e));
    end
end
<<<<<<< HEAD
disp('cats');
=======

>>>>>>> 4992a12a2ad1338f7f642b57dbc218984af91dbe
CorrL = mean(lengthList);