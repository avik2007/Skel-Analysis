%% ---------------------- plot3DSkeleton --------------------------------
% Avik Mondal
% 
% Aim:
% - create a void function that plots the medial axis of a skeletal VOI
% (this is effectively a functional form of Test_Skeleton3D
%
% Parameters:
%
% array skeletonBin - contains the binarized skeletal VOI
%--------------------------------------------------------------------------
function plot3DSkeleton(skeletonBin)
addpath('C:\Users\Avik Mondal\Documents\Carlson Lab\Bone Project MATLAB code\phi-max-skeleton3d-matlab-c534cab');
skel = Skeleton3D(skeletonBin);

figure();
col=[.7 .7 .8];
hiso = patch(isosurface(skel,0),'FaceColor',col,'EdgeColor','none');
hiso2 = patch(isocaps(skel,0),'FaceColor',col,'EdgeColor','none');
axis equal;axis off;
lighting phong;
isonormals(skel,hiso);
alpha(0.5);
set(gca,'DataAspectRatio',[1 1 1])
camlight;
hold on;
w=size(skel,1);
l=size(skel,2);
h=size(skel,3);
[x,y,z]=ind2sub([w,l,h],find(skel(:)));
plot3(y,x,z,'square','Markersize',4,'MarkerFaceColor','r','Color','r'); 
title('Skeletonized Section');
set(gcf,'Color','white');
view(-59,52);
title('Skeletonized Section');
tinyaxis(gca,'r','g','b');
%{
addpath('C:\Users\Avik Mondal\Documents\Carlson Lab\Bone Project MATLAB code\phi-max-skeleton3d-matlab-c534cab');
skel = Skeleton3D(skeletonBin);%Color',col,'EdgeColor','none');
axis equal;axis off;
lighting phong;
isonormals(skel);
alpha(0.5);
set(gca,'DataAspectRatio',[1 1 1])
camlight;
hold on;
w=size(skel,1);
l=size(skel,2);
h=size(skel,3);
[x,y,z]=ind2sub([w,l,h],find(skel(:)));
plot3(y,x,z,'square','Markersize',4,'MarkerFaceColor','r','Color','r'); 
title('Skeletonized Section');
set(gcf,'Color','white');
view(-59,52);
%}