%% ----------------- plotStressDistributionOnLinks -------------------------
% THIS IS A SCRIPT
%
% Avik Mondal
% 
% Aim:
% this script takes the abaqus stress calculations and plots the stress
% distribution on a histogram (ordered by stress magnitude). It shows what
% percentage of links are supporting 50% of the stress.
%
% requires: link stresses over time 
% Note: Changing the variable names would make this work for any of the
% individual workspaces 
%--------------------------------------------------------------------------
%% set up stuff
addpath('C:\Users\Avik Mondal\Documents\Carlson Lab\Bone Project MATLAB code\matlab-networks-toolbox');
addpath('C:\Users\Avik Mondal\Documents\Carlson Lab\Bone Project MATLAB code');

%% Taking a sample of the 30 most stressed links 
%stresses get ordered in this subsection!! 

finalStresses = zeros(size(stress_data,1),2);
finalStresses(:,1) = (stress_data(:,size(stress_data,2)));
finalStresses(:,2) = (1:size(stress_data,1))';

map = containers.Map(finalStresses(:,1)',finalStresses(:,2)');
orderedStress = sort(finalStresses(:,1), 'descend'); 
orderedStressLinks = arrayfun(@(x) map(x), orderedStress);
orderedStresses = [orderedStress orderedStressLinks];
clear orderedStress orderedStressLinks map finalStresses;
%% 	Calculating how many links hold up 50% of stress in network

link_stress_ratio = zeros(size(stress_data,1), size(stress_data,2));
for i = 1:size(link_stress_ratio,2)
    total = sum(stress_data(:,i));
    if (total>0)
        link_stress_ratio(:,i) = stress_data(:,i)/total; 
    end
end
total = zeros(size(link_stress_ratio,2),1);
fiftypindex = zeros(size(link_stress_ratio,2),1);
clear index;
for j = 1:size(link_stress_ratio,2)
    total(j,1) = 0;
    index = 1;
    while ((total(j,1) < 0.5)&&(index < length(link_stress_ratio)))
        total(j,1) = total(j,1) + link_stress_ratio(orderedStresses(index,2),j);
        index = index + 1;
    end
    fiftypindex(j,1) = index;
end
clear total;

%{
timesteps = size(link_stress_time,2); 
stressLimRatio = max(link_stress_ratio(:,timesteps));
F(timesteps) = struct('cdata',[],'colormap',[]);
v = VideoWriter('link_stress_ratio_series.avi') ;
v.FrameRate = 5;
open(v);
for i = 1:timesteps
    StressRatio = link_stress_ratio((orderedStresses(:,2))',i);
    figure('Name',horzcat('VOI_701x101y Stress Distribution ', num2str(i)));
    bar(StressRatio,'b');
    axis([0 length(link_trunc) 0 stressLimRatio]);
    title(strcat("Split9 Stress Ratio Distribution: Frame ", num2str(i)));
    xlabel("Links (ordered from highest to lowest stress");
    ylabel("Stress Percentage");
    F(i) = getframe(gcf);
    writeVideo(v,F(i));
    close(gcf);
end
close(v); 
%}

%% Plot to show how few links carry the stress of the network

%Going to make a frame of all the histogram video data


timesteps = size(stress_data,2); 
stressLim = max(stress_data(:,timesteps));

%% 
Stress = stress_data((orderedStresses(:,2))',timesteps);
figure('Name',horzcat('VOI_701x101y Stress Distribution ', num2str(i)));
b = bar(Stress,'b');
b.FaceColor = 'flat';
for k = 1:fiftypindex(i,1)
    b.CData(k,:) = [0 1 0];
end
grid on
l = cell(1,1);
l{1} = '50% total stress';
legend(b,l);
axis([0 length(link_trunc) 0 stressLim]);
title(strcat("VOI\_601x301y Stress Distribution: Frame ", num2str(i)));
xlabel("Percentage of Links");
ylabel("Stress (MPa)");
ln = length(link_trunc) / 10.0;
xticks([1, ln, ln*2.0, ln*3.0, ln*4.0, ln*5.0, ln*6.0, ln*7.0, ln*8.0, ln*9.0, ln*10.0]);
xticklabels({'0','10','20','30','40','50','60','70','80','90','100'});
