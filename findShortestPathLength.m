%% ------------------------------- findShortestPathLengths ------------------------------
% Avik Mondal
% 
% Aim:
% - this function aims to find the path lengths between two points in the
%   bone network (skel2graph) (ONLY USE THIS BEFORE USING
%   GETNODELINKPROPERTIES OTHERWISE THE ENDPOINT DEFINITION CHANGES)
%
% Parameters:   
% struct node - contains the nodes generated from converting skeletonBin to
%    a graph
% struct link - contains the links generated from converting skeletonBin to
%    a graph
% link for implementing list, queue,stack
%http://www.mathworks.com/matlabcentral/fileexchange/45123-data-structures?focused=3805777&tab=function
%--------------------------------------------------------------------------
function pathLength = findShortestPathLength(node,link,skel, startingIndex,endingIndex)
addpath('C:\Users\avik2\Documents\Carlson Lab\Bone Project MATLAB code\Data_Structures\Data Structures\Queues');
%instantiates link.accessibility as 1 for all links

for a = 1:length(link)
    link(a).accessibility = 1;
end %DON'T REMOVE THIS! IT'S NECESSARY


%looks as nodes to determine if links are "accessible"
%endpoints that aren't the starting point or the ending point are
%inaccessible

%instantiates node.parent as 0 for all nodes
for index = 1:length(node)
    node(index).parent = 0;
<<<<<<< HEAD
    if (node(index).ep == 1) 
=======
    if (node(index).ep == 0) %EDIT 2/8/18 - I just fixed this from 1 to 0, check later
>>>>>>> 4992a12a2ad1338f7f642b57dbc218984af91dbe
        link(node(index).links).accessibility = 0;
    end
end
for index1 = 1:length(node(startingIndex).links)
    link(node(startingIndex).links(index1)).accessibility = 1;
end
for index2 = 1:length(node(endingIndex).links)
    link(node(endingIndex).links(index2)).accessibility = 1;
end
clear index;




Q = Queue(length(node));
Q.Enqueue(0);
current = Q.Dequeue();
%I put in the last two lines because without them even after I put
%startingIndex in the queue it read as empty
%it's a weird library that's involved here

%nodesList = [];
%linksList = [];
%validNeighbors = [];

Q.Enqueue(startingIndex);



while ~( Q.IsEmpty() )
    current = Q.Dequeue();
    if ( current == endingIndex )
        break;
    end
    
    linksList = node(current).links;
    nodesList = node(current).conn;
    validNeighbors = Queue(length(nodesList));
    validLinks = Queue(length(linksList));
    for index = 1:length(linksList)
        if (link(linksList(index)).accessibility == 1 )
            validNeighbors.Enqueue(nodesList(index));
            validLinks.Enqueue(linksList(index));
        end
    end
    while ~(validNeighbors.IsEmpty())
        currentNeighbor = validNeighbors.Dequeue();
        currentLink = validLinks.Dequeue();
        link(currentLink).accessibility = 0;
        node(currentNeighbor).parent = current;
        Q.Enqueue(currentNeighbor);
    end
end
clear index;
%pathLength = node;
%now a quick for loop to calculate the length of the path found
countedIndex = endingIndex;
count = 0;
while ( countedIndex ~= startingIndex )
    %disp(countedIndex);
    if ( countedIndex ~= 0 )
        countedIndex = node(countedIndex).parent;
        count = count + 1;
    else
        count = inf;
        break;
    end 
end
%the pathLength is the number of edges between the start and the end
 pathLength = count ;

% BFS PSEUDOCODE
%{ 
Breadth-First-Search(Graph, root):
    
    create empty set S
    create empty queue Q      

    add root to S
    Q.enqueue(root)                      

    while Q is not empty:
        current = Q.dequeue()
        if current is the goal:
            return current
        for each node n that is adjacent to current:
            if n is not in S:
                add n to S
                n.parent = current
                Q.enqueue(n)
%}
