%% ----------------- analyze_CUMULATIVE_STRESS_TRUNC -------------------------
% THIS IS A SCRIPT
%
% Avik Mondal
% 
% Aim:
% this script takes the correlation analyzed workspaces from bulk graph
% analysis and tries to study averages in order to see if there is a
% tendency for correlation between two different metrics
%
% requires: Plink_av, Pnode_av, Rlink_av, Rnode_av
% Note: Changing the variable names would make this work for any of the
% individual workspaces 
%--------------------------------------------------------------------------

%% set up stuff
addpath('C:\Users\Avik Mondal\Documents\Carlson Lab\Bone Project MATLAB code\matlab-networks-toolbox');
addpath('C:\Users\Avik Mondal\Documents\Carlson Lab\Bone Project MATLAB code');
%% Imagifying the average Rlink matrix

imagesc(Rlink_av); 
grid on;
colorbar;
title('Link Metric Average Correlation Coefficients (30 samples)');
yticks([0.5, 1.5, 2.5, 3.5, 4.5, 5.5, 6.5, 7.5, 8.5]);
xticks([0.5, 1.5, 2.5, 3.5, 4.5, 5.5, 6.5, 7.5, 8.5]);
yticklabels({'stress','stress derivatives','avg thickness','length','TLR','Zo','Yo','Xo','betweenness'});
xticklabels({'Str', 'SDer', 'Th', 'L', 'TLR', 'ZO', 'YO','XO','LB'});
%% Imagifying the average Plink matrix
imagesc(Plink_av);
grid on;
colorbar;
title('Link Metric Average Significance Values (30 samples)')
yticks([0.5, 1.5, 2.5, 3.5, 4.5, 5.5, 6.5, 7.5, 8.5]);
xticks([0.5, 1.5, 2.5, 3.5, 4.5, 5.5, 6.5, 7.5, 8.5]);
yticklabels({'stress','stress derivatives','avg thickness','length','TLR','Zo','Yo','Xo','betweenness'});
xticklabels({'Str', 'SDer', 'Th', 'L', 'TLR', 'ZO', 'YO','XO','LB'});
%% Imagifying the average Rnode matrix
imagesc(Rnode_av);
grid on;
colorbar;
title('Node Metric Average Correlation Coefficients (30 samples)')
yticks([0.5, 1.5, 2.5, 3.5, 4.5, 5.5, 6.5, 7.5, 8.5, 9.5, 10.5, 11.5, 12.5, 13.5, 14.5, 15.5]);
xticks([0.5, 1.5, 2.5, 3.5, 4.5, 5.5, 6.5, 7.5, 8.5, 9.5, 10.5, 11.5, 12.5, 13.5, 14.5, 15.5]);
yticklabels({'BB','BT', 'BS', 'BL', 'CB', 'CT', 'CS', 'CL', 'DB', 'DT', 'DS', 'DL', ...
    'EB', 'ET', 'ES', 'EL'});
xticklabels({'BB','BT', 'BS', 'BL', 'CB', 'CT', 'CS', 'CL', 'DB', 'DT', 'DS', 'DL', ...
    'EB', 'ET', 'ES', 'EL'});
%% Imagifying the average Pnode matrix
imagesc(Pnode_av);
grid on; 
colorbar;
title('Node Metric Average Significant Values (30 samples)');
yticks([0.5, 1.5, 2.5, 3.5, 4.5, 5.5, 6.5, 7.5, 8.5, 9.5, 10.5, 11.5, 12.5, 13.5, 14.5, 15.5]);
xticks([0.5, 1.5, 2.5, 3.5, 4.5, 5.5, 6.5, 7.5, 8.5, 9.5, 10.5, 11.5, 12.5, 13.5, 14.5, 15.5]);
yticklabels({'BB','BT', 'BS', 'BL', 'CB', 'CT', 'CS', 'CL', 'DB', 'DT', 'DS', 'DL', ...
    'EB', 'ET', 'ES', 'EL'});
xticklabels({'BB','BT', 'BS', 'BL', 'CB', 'CT', 'CS', 'CL', 'DB', 'DT', 'DS', 'DL', ...
    'EB', 'ET', 'ES', 'EL'});