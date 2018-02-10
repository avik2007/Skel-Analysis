%% ---------------------- findDNodeStrength ---------------------------
% Avik Mondal
% 
% Aim:
% - this function aims to find the strength of each node, which is
% effectively the node degree weighted by the intensity (or weight) of each
% link
%
% Parameters:   
% 
% struct node - contains the nodes generated from converting skeletonBin to
%    a graph
% struct link - contains the links generated from converting a skeletonized
% VOI in to a graph and calculating the weights of each branch
% int16 i - the index of the node whose strenght we want to calculate
% defined in The architeture of complex networks, (A. Barat et. al)
%--------------------------------------------------------------------------
function nodeStrength = findNodeStrength(node,link,i)

links = node(i).links;
nodeStrength = double(0);

for index = 1 : length(links)
     nodeStrength = nodeStrength + link(links(index)).avgthickness;
end    
