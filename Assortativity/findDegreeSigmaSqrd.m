%% ---------------------- findDegreeSigmaSqrd---------------------------
% Avik Mondal
% 
% Aim:
% - this function aims to calculate the variance of the degree from the
% degree correlation matrix
%1'S AND 2'S ARE REMOVED. SO I AND J START FROM INDEX 3
% Parameters:   
% 
% struct node - contains the nodes generated from converting skeletonBin to
%    a graph
% struct link - contains the links generated from the converting the
%    skeleton to a graph
% equation: <k^2> - <k>^2
%--------------------------------------------------------------------------
function sigma2 = findDegreeSigmaSqrd(eij)

q = zeros(length(eij),1);

ksquaredbar = 0;
kbarsquared = 0;
for k = 1:length(q)
    q(k,1) = sum(eij(:,k));
    ksquaredbar = ksquaredbar + (k + 2)*(k + 2)*q(k,1);
    kbarsquared = kbarsquared + (k + 2)*q(k,1);
end

sigma2 = ksquaredbar - (kbarsquared)^2;

