%% Stress histogram
Stress = [link_trunc.finalStress];
figure('Name','Link Final Stresses');
histogram(Stress);
[NStress,edgesStress] = histcounts(Stress);
title("Stress Distribution");
xlabel("Stress (units?)");
ylabel("Number of Links");

%% Link Thickness vs Length Ratio
for index = 1:length(link_trunc)
    link_trunc(index).thicklengthratio = link_trunc(index).avgthickness / link_trunc(index).length; 
end
%% ThickLengthRatio Histogram
TLR = [link_trunc.thicklengthratio];
figure('Name','Link Thickness Length Ratio');
histogram(TLR);
[NStress,edgesStress] = histcounts(TLR);
title("TLR Distribution");
xlabel("Thickness to Length Ratio");
ylabel("Number of Links");
%% STRESS TO TLR  Scatter

x = [link_trunc.thicklengthratio];
y = [link_trunc.finalStress];
s = scatter(x,y);
title("Stress / TLR Scatterplot");
xlabel("Thickness to Length Ratio");
ylabel("Final Stresses");

%% STRESS TO thickness Scatter
x = [link_trunc.avgthickness];
y = [link_trunc.finalStress];
s = scatter(x,y);
title("Stress/ Average Thickness Scatterplot");
xlabel("Average Thickness");
ylabel("Final Stresses");

%% STRESS TO LENGTH SCATTER
x = [link_trunc.length];
y = [link_trunc.finalStress];
s = scatter(x,y);
title("Stress/ Length Scatterplot");
xlabel("Length (Euclidean Distance between Nodes");
ylabel("Final Stresses");
%% Histogram Video
%Going to make a frame of all the histogram video data
%you need stress_data and you need to preallocate matrix space
timesteps = size(link_stress_time,2); 
[~,edgeStress] = histcounts(link_stress_time(:,size(link_stress_time,2)));
F(timesteps) = struct('cdata',[],'colormap',[]);
v = VideoWriter('stress_time_series.avi') ;
v.FrameRate = 5;
open(v);
for i = 1:timesteps
    Stress = link_stress_time(:,i);
    figure('Name',horzcat('VOI_701x101y Stress Distribution ', num2str(i)));
    histogram(Stress,edgeStress);
    %[NStress,edgesStress] = histcounts(Stress);
    axis([0 max(link_stress_time(:,size(link_stress_time,2))) 0 length(link_trunc)])
    title(strcat("Split9 Stress Distribution: Frame ", num2str(i)));
    xlabel("Stress (MPa)");
    ylabel("Number of Links");
    F(i) = getframe(gcf);
    writeVideo(v,F(i));
    close(gcf);
end
close(v); 
%% Playing histogram movie
fig = figure;
movie(fig,F,1);

