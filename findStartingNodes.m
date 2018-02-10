%% ---------------------- findStartingNodes ------------------------------
% Avik Mondal
% 
% Aim:
% - this function takes the nodes generated by convertSkelToGraph
%   (Skel2Graph)and find the top most ones (axially). These nodes will
%   serve as the beginnings of the axial paths calculated when computing
%   correlation length
%
% - (8-14) Now, I'm updating this code to find to find the top most nodes
% but with stricter qualifications (like on the actual top most ones will 
% show)
%
% 
%
% Parameters:
% struct node - contains the nodes generated from converting skeletonBin to
%    a graph
% matrix skel - contains the binarized skeletal VOI (binary, skeletonized 3d
%    matrix). Used mainly for dimensions
% int subgraphNum - contains the index of the subgraph that the function
%     will be looking through
% this link helped with finding all the end points
%-https://stackoverflow.com/questions/14480876/using-find-with-a-struct
%--------------------------------------------------------------------------
function startingNodes = findStartingNodes(node,skel, subgraphNum)
%captures dimensions of the skeleton array
w = size(skel,1);
l = size(skel,2);
h = size(skel,3);


depththreshold = 5;
%this is the depth for which the program will look for starting nodes. i.e
%for a depth threshold of 5, the code will look through the first 5 layers
%to find starting nodes

endPts = find(([node.ep] == 1) & ([node.comz] < depththreshold) & [node.subGraph] == subgraphNum );
%finds only end points of the node set

xStart = 1;
yStart = 1;
xEnd = w;
yEnd = l;
upperNodesIndices = int16.empty;
%comx = int16.empty;
%comy = int16.empty;
%comz = int16.empty;
% this loop finds all the endpoints that are axially above their
% connections 
for index = 1:length(endPts)
    conns = node(endPts(index)).conn;
    if (node(conns).comz > node(endPts(index)).comz )
        upperNodesIndices  = vertcat(upperNodesIndices, endPts(index)); 
    end    
end
startingNodes = upperNodesIndices;
%{
%startingNodes = lowerNodesIndices;
upperSurfaceIndices = int16.empty;
xthreshold = 3;
ythreshold = 3;
%currently, these two values determine the "resolution" of the upper
%surface that these starting nodes create

comX = 0;
comY = 0;
comZ = 0;
tempIndices = int16.empty;
for index2 = 1:length(upperNodesIndices)
    comX = node(upperNodesIndices(index2)).comx;
    comY = node(upperNodesIndices(index2)).comy;
    comZ = node(upperNodesIndices(index2)).comz;
    tempIndices = find( ([node.comx] < (comX+xthreshold)) & ([node.comx] > (comX-xthreshold)) & ([node.comy] < (comY+ythreshold)) & ([node.comy] > (comY-ythreshold)) );
    isBiggest = 0;
    index3 = 1;
    while (isBiggest == 0) && (index3 <= length(tempIndices))
        if (comZ > node(tempIndices(index3)).comz) 
            isBiggest = 1;
        end
        index3 = index3 + 1;
    end
    
    if (isBiggest == 0)
        upperSurfaceIndices = vertcat(upperSurfaceIndices,upperNodesIndices(index2));
    end
end
%startingNodes = upperSurfaceIndices;
%}
%Current al