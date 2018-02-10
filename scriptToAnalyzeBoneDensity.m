% Script to analyze the bone density of VOI_701x101y (post Abaqus)
% 
%Splitting the VOI into smaller increments, maybe 
%I'm changing the VOI from 71 in depth to 70
% this way I can split it up into groups of 10x10x7
% GET VOI OF ORIGINAL BONE STUFF
totalVolume = length( find( postAbaqusVOI == 1 ) );
totalAvailableVolume = 700000;
volumeFraction = totalVolume / totalAvailableVolume; 

subBoneMass = zeros(10,10,10); 

for i = 1:10 
    for j = 1:10
        for k = 1:10
            %test = [(i-1)*10, (j-1)*10, (k-1)*10];
            %disp(test);
            subBoneMass(i,j,k) = length( find( postAbaqusVOI( ( (i-1)*10 + 1 ):i*10,( (j-1)*10 + 1 ):j*10,( (k-1)*7 + 1 ):k*7) == 1) );
        end
    end
end

subBoneFraction = subBoneMass / (10*10*7);
%% Assigning local volume fraction to each node
% Make sure link_trunc and node_trunc are in the workspace!
% Make sure subBoneFractions is in the workspace!
% Make sure centroids are calculated for this!
%load('workspace_abaqus_finalstressdata_link_node_1_31_18.mat');

% So the way I set up my bone volume subclasses, I didn't account for the
% nodes that have links above 70. So here, I'm justing rounding them down
% to 70 (to avoid index errors)

%NEEDS LINKTRUNC
for linkIndex = 1:length(link_trunc)
    centroid = link_trunc(linkIndex).centroid;
    if (centroid(3) < 70 )
        centroid = [ceil(centroid(1)/10), ceil(centroid(2)/10), ceil(centroid(3)/7)];
    else
        centroid = [ceil(centroid(1)/10), ceil(centroid(2)/10), 10];
    end
    link_trunc(linkIndex).localVolFrac = subBoneFraction(centroid(1),centroid(2),centroid(3));
end


%% Bone Volume Fraction Histogram

figure('Name','Bone Fraction: VOI 701x101y');
histogram(subBoneFraction);
[N,edges] = histcounts(subBoneFraction);
%edges2 = edges(2:length(edges));
%N2 = N(2:length(N));
%xLLim =edges2(find(N2,1)); %takes into account the nodes that are endpoints (or have degree 2)
%yULim = max(N)*1.2;
%finds the largest bin and determines the y axis upper limit based off that
%axis([xLLim 1 0 yULim]);
title("Bone Fraction: VOI 701x101y");
xlabel("Bone Volume Fraction");
ylabel("Number of Sub VOI's");

%% 
for i = 1:length(node_trunc)
    node_trunc(i).ep = ~(node_trunc(i).ep);
end 