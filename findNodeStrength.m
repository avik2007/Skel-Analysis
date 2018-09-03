%% ---------------------- findNodeStrength ---------------------------
% Avik Mondal
% 
% Aim:
% - this function aims to find the strength of each node, which is
% effectively the node degree weighted by the intensity (or weight) of each
% link
%
% Parameters:   
% 1. 
% struct node - contains the nodes generated from converting skeletonBin to
%    a graph
% struct link - contains the links generated from converting a skeletonized
% VOI in to a graph and calculating the weights of each branch
% int16 i - the index of the node whose strenght we want to calculate
% defined in The architeture of complex networks, (A. Barat et. al)
% or alternatively
%2. 
% matrix node - weighted adjacency matrix of the network
% int16 i - the index of the node whose strength we want to calculate)
%--------------------------------------------------------------------------
function nodeStrength = findNodeStrength(node,varargin)
if (nargin == 3)
    i = varargin{2};
    link = varargin{1};
    links = node(i).links;
    nodeStrength = double(0);

    for index = 1 : length(links)
        nodeStrength = nodeStrength + link(links(index)).avgthickness;
    end    
else
    %node is an adjacency matrix
    nodeStrength = 0;
    i = varargin{1};
    for index = 1: size(node,1)
        nodeStrength = nodeStrength + node(i, index); 
    end
end