%% ------------------------------- findGeodesicVector ------------------------------
% Avik Mondal
% 
% Aim:
% - this function aims to find the distance between a chosen node and all
% other nodes in the network
%
% Parameters:   
% struct node - contains the nodes generated from converting skeletonBin to
%    a graph. This expects a connected graph. 
% struct link - contains the links generated from converting skeletonBin to
%    a graph
%
%http://www.mathworks.com/matlabcentral/fileexchange/45123-data-structures?focused=3805777&tab=function
%--------------------------------------------------------------------------
function gVeci = findGeodesicVector(node,link,nodei)
addpath('C:\Users\Avik Mondal\Documents\Carlson Lab\Bone Project MATLAB code\Data_Structures\Data Structures\Queues');
gVeci = zeros(1,length(node));
visitedNodes = zeros(1,length(node));



Q = Queue(2*length(node)+2*length(link)); %stores the current level of neighbors
Qnext = Queue(2*length(node)+2*length(link));%prepares the store the next level of neighbors
%{
neighbors = node(nodei).conn;
visitedNodes(nodei) = 1;
for index = 1:length(neighbors)
    Q.Enqueue(neighbors(index));
end
currentLength = 1;
%}
Q.Enqueue(nodei);
currentLength = 0;
isDone = 1;
while (isDone == 1)
    Qsize = Q.Count();
    Qnsize = Qnext.Count();
    currentNode = Q.Dequeue();
    neighbors = node(currentNode).conn;
    for index1 = 1:length(neighbors)
        if (visitedNodes(neighbors(index1)) ~=1)
            Qnext.Enqueue(neighbors(index1));
        end    
    end
    if ( visitedNodes(currentNode) == 0)
        visitedNodes(currentNode) = 1;
        gVeci(currentNode) = currentLength;
    end    
   
    if ( Q.IsEmpty() ) %send Qnext's stuff to Q
        for (indexQ = 1:Qnext.Count())
            Q.Enqueue(Qnext.Dequeue);
        end
        currentLength = currentLength + 1;% update to the next group of nodes
    end
    if (Q.IsEmpty() ) %if Q.next had nothing to transfer to Q, end the loop
        isDone = 0;
    end
    
end
Zeroes = find(~gVeci);
for indexZ = 1:length(Zeroes)
    if (Zeroes(indexZ) ~= nodei)
        gVeci(Zeroes(indexZ)) = Inf;
    end    
end
    