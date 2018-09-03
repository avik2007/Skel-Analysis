%% ---------------------- findAverageClustering-----------------------------
% Avik Mondal
% 
% Aim:
% - this function outputs the global clustering coefficient of a node (as
%    defined by Watts and Strogatz) by averaging all the local clustering
%    coefficients
%
% Parameters:   
% 
% struct node - contains the nodes generated from converting skeletonBin to
%    a graph
% 
%--------------------------------------------------------------------------
function CC = findAverageClustering(node)

CCis = zeros(length(node),1); %matrix holds all the local clustering coefficients
for index = 1:length(node)
    CCis(index) = findLocalClustering(node,index);
end
%the final global cc is the average of all the local ones
CC = mean(CCis);