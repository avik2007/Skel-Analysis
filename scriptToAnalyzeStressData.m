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
%% Finding trabecula that aren't taking 0 stress
stresses = [link_trunc.finalStress];
nonzeros = find(stresses > 200);
%% STRESS TO TLR  Scatter (reattempted with only greater than 0 stress trabecula)

TLR = [link_trunc.thicklengthratio];

x = TLR(nonzeros);
y = stresses(nonzeros);
s = scatter(x,y);
title("Stress / TLR Scatterplot");
xlabel("Thickness to Length Ratio");
ylabel("Final Stresses");

%% STRESS TO thickness Scatter
THICK = [link_trunc.avgthickness];

x = THICK(nonzeros);
y = stresses(nonzeros);
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
%% Stress vs Vol Fraction Histogram
VF = [link_trunc.localVolFrac];

x = VF(nonzeros);
y = stresses(nonzeros);
s = scatter(x,y);
title("Stress/ Local Volume Fraction Scatterplot");
xlabel("Local Bone Volume Fraction");
ylabel("Final Stresses");

%% Link Orientation (Direction) Histogram
%Right now, I'm measuring up-down orientation
orientation = zeros(length(link_trunc),1);
for oindex = 1:length(link_trunc)
    orientation(oindex,1) = abs(dot([0,0,1], link_trunc(oindex).direction));
end
figure('Name','Link Vertical Orientation Distribution');
histogram(orientation);

title("Z Axis Orientation Distribution");
xlabel("Z Axis Orientation Ratio");
ylabel("Number of Links");

%% Stress Data vs Vertical Orientation

x = abs(orientation);
y = [link_trunc.finalStress];
s = scatter(x,y);

title("Stress/ Link Vertical Orientation Scatterplot");
xlabel("Link Vertical Orientation");
ylabel("Final Stresses");

%% Stress Data Dynamics
% needs compressed link stress data
x = 1:26;
y = link_stress_time(503,:);
p = plot(x,y, 'o');
%s = scatter(x,y);
title("Stress Evolution on Max Stressed Link");
xlabel("Timestep");
ylabel("Stresses");

%% Taking a sample of the 30 most stressed links 
%stresses get ordered in this subsection!! 

finalStresses = zeros(size(link_stress_time,1),2);
finalStresses(:,1) = (link_stress_time(:,26));
finalStresses(:,2) = (1:size(link_stress_time,1))';

map = containers.Map(finalStresses(:,1)',finalStresses(:,2)');
orderedStress = sort(finalStresses(:,1), 'descend'); 
orderedStressLinks = arrayfun(@(x) map(x), orderedStress);
orderedStresses = [orderedStress orderedStressLinks];
clear orderedStress orderedStressLinks map finalStresses;

%% Plotting stress evolution of top 3 stressed links
x = 0:25;
y1 = link_stress_time(orderedStresses(1,2),:);
y2 = link_stress_time(orderedStresses(2,2),:);
y3 = link_stress_time(orderedStresses(3,2),:);

plot(x,y1,'r--', x,y2,'ko', x,y3,'b:');
title("Stress Evolution on 3 Max Stressed Link");
xlabel("Timesteps (1 second)");
ylabel("Stresses (MPa)");
legend(horzcat('Link ', num2str(orderedStresses(1,2))), horzcat('Link ', num2str( orderedStresses(2,2)) ), ...
    horzcat('Link ', num2str(orderedStresses(3,2))), 'Location', 'Northwest'); 
%% Calculating Stress/Time Derivatives
max_link_derivatives = zeros(length(orderedStresses),1);
for dindex = 1:length(orderedStresses)
    max_link_derivatives(dindex,1) = mean(gradient(link_stress_time(orderedStresses(dindex,2),:))); 
end
% Derivatives of the slope of the stress dynamics of the 30 most stressed
% links

%% Derivative of stresses to thicklength ratio

TLR = [link_trunc.thicklengthratio];

x = TLR(orderedStresses(:,2));
y = max_link_derivatives;
s = scatter(x,y);
title("Stress Time Derivative / TLR Scatterplot");
xlabel("Thickness to Length Ratio");
ylabel("Stress Time Derivative");

%% Derivative of stresses to volume fraction

VF = [link_trunc.localVolFrac];

x = VF(orderedStresses(:,2));
y = max_link_derivatives;
s = scatter(x,y);
title("Stress Time Derivatives/ Local Volume Fraction Scatterplot");
xlabel("Local Bone Volume Fraction");
ylabel("Stress Time Derivatives");


%% Plot to show how few links carry the stress of the network
%Going to make a frame of all the histogram video data


timesteps = size(link_stress_time,2); 
stressLim = max(link_stress_time(:,timesteps));
F(timesteps) = struct('cdata',[],'colormap',[]);
v = VideoWriter('link_stress_time_series.avi') ;
v.FrameRate = 5;
open(v);
for i = 1:timesteps
    Stress = link_stress_time((orderedStresses(:,2))',i);
    figure('Name',horzcat('VOI_701x101y Stress Distribution ', num2str(i)));
    b = bar(Stress,'b');
    b.FaceColor = 'flat';
    for k = 1:fiftypindex(i,1)
        b.CData(k,:) = [0 1 0];
    end
    axis([0 length(link_trunc) 0 stressLim]);
    title(strcat("Split9 Stress Distribution: Frame ", num2str(i)));
    xlabel("Link");
    ylabel("Stress (MPa)");
    F(i) = getframe(gcf);
    writeVideo(v,F(i));
    close(gcf);
end
close(v); 

%% Percentage of links vs Percentage of Stress analysis 

link_stress_ratio = zeros(size(link_stress_time,1), size(link_stress_time,2));
for i = 1:size(link_stress_ratio,2)
    total = sum(link_stress_time(:,i));
    if (total>0)
        link_stress_ratio(:,i) = link_stress_time(:,i)/total; 
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
%% 

