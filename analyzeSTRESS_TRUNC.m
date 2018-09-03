 %% ----------------- analyzeSTRESS_TRUNC -------------------------
% THIS IS A SCRIPT
%
% Avik Mondal
% 
% Aim:
% this script takes the bulk processed trunc files and their respective
% stresses and the metrics calculated on them (see processSTRESS_TRUNC) and
% runs correlation analysis on them 
% Workspace:
% link_trunc, node_trunc, stress_data for appropriate VOI
% - set stress_data equal to the appropriate variable
%--------------------------------------------------------------------------
%% set up stuff
addpath('C:\Users\Avik Mondal\Documents\Carlson Lab\Bone Project MATLAB code\matlab-networks-toolbox');
addpath('C:\Users\Avik Mondal\Documents\Carlson Lab\Bone Project MATLAB code');

%% create matrices on which correlations can easily be calculated 
link_corr_mat = horzcat([link_trunc.finalStress]', [link_trunc.stressDerivative]', ...
    [link_trunc.avgthickness]', [link_trunc.length]', [link_trunc.thicklengthratio]', ...
    [link_trunc.zorientation]', [link_trunc.yorientation]', [link_trunc.xorientation]', ...
    [link_trunc.linkBetweenness]'); 

node_corr_mat = horzcat(bmatrix, cmatrix, dmatrix, ematrix); 
%% calculates the correlation matrices 
[Rlink, Plink] = corrcoef(link_corr_mat);
[Rnode, Pnode] = corrcoef(node_corr_mat);
%% attempt to calculate slope of stress-strain curve 
