%% ---------------------- findNetworkNodeStrength ---------------------------
% Avik Mondal
% 
% Aim:
% - this function aims to find the strength of each node, which is
% effectively the node degree weighted by the intensity (or weight) of each
% link. Output a vector containing the strength of teach node
%
% Parameters:   
% 1. 
% struct node - contains the nodes generated from converting skeletonBin to
%    a graph
% struct link - contains the links generated from converting a skeletonized
% VOI in to a graph and calculating the weights of each branch
%
%2. 
% matrix node - weighted adjacency matrix of the network
% 
%--------------------------------------------------------------------------
function nodeStrength = findNetworkNodeStrength(node,varargin)
if (nargin == 2)
    link = varargin{1};
    nodeStrength = zeros(1,length(node));

    for index = 1 : length(node)
        nodeStrength(1,index) = findNodeStrength(node,link,index);
    end    
else
    %node is an adjacency matrix
    nodeStrength = zeros(1,length(node));
   
    for index = 1: size(node,1)
        nodeStrength(1,index) = findNodeStrength(node,index); 
    end
end