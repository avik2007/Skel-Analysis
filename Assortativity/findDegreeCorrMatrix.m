%% ---------------------- findDegreeCorrMatrix---------------------------
% Avik Mondal
% 
% Aim:
% - this function aims to calculate the degree correlation matrix of a
% network
%1'S AND 2'S ARE REMOVED. SO I AND J START FROM INDEX 3
% Parameters:   
% 
% struct node - contains the nodes generated from converting skeletonBin to
%    a graph
% struct link - contains the links generated from the converting the
%    skeleton to a graph
%--------------------------------------------------------------------------
function eij = findDegreeCorrMatrix(node,link)

k_i = zeros(length(find([node.ep] == 0)),1);
% using a for loop to avoid the 1's and the 2's
for index = 1:length(node)
    if length(node(index).links) > 2 %length 1's and 2's are artifacts of network conversion
        k_i(index) = length(node(index).conn);
    end
end

 
maxK = max(k_i);
eij = zeros(maxK, maxK );

for index2 = 1:length(link)
    node1 = link(index2).n1;
    node2 = link(index2).n2;
    k1 = length(node(node1).conn);
    k2 = length(node(node2).conn);
    eij(k1,k2) = eij(k1,k2) + 1;
    eij(k2,k1) = eij(k2,k1) + 1;
end
eij = eij(3:end,3:end);
C = sum(sum(eij));
eij = eij/C;