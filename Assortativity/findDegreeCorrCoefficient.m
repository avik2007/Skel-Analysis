%% -------------------- findDegreeCorrCoefficient-------------------------
% Avik Mondal
% 
% Aim:
% - this function aims to calculate the degree correlation coefficient
%   (the Pearson correlation coefficient between the degrees found at the
%   two ends of the same link). 
%1'S AND 2'S ARE REMOVED. SO I AND J START FROM INDEX 3
% Parameters:   
% 
% struct node - contains the nodes generated from converting skeletonBin to
%    a graph
% struct link - contains the links generated from the converting the
%    skeleton to a graph
% equation: http://barabasi.com/f/620.pdf
%--------------------------------------------------------------------------
function r = findDegreeCorrCoefficient(node,link)

eij = findDegreeCorrMatrix(node,link);
sigma2 = findDegreeSigmaSqrd(eij);
q = zeros(length(eij),1);
for k = 1:length(eij)
    q(k,1) = sum(eij(:,k));
end
r = 0;
for j = 1:length(eij)
    for k = 1:length(eij)
        r = r + (j+2) * (k+2) * ( eij(j,k)- q(j,1)*q(k,1) ) / ( sigma2 );   
    end
end

