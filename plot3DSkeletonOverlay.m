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
function plot3DSkeletonOverlay(skeletonBin)

addpath('C:\Users\avik2\Documents\Carlson Lab\Bone Project MATLAB code\phi-max-skeleton3d-matlab-c534cab');
skel = Skeleton3D(skeletonBin);

figure();
col=[.7 .7 .8];
hiso = patch(isosurface(skeletonBin,0),'FaceColor',col,'EdgeColor','none');
hiso2 = patch(isocaps(skeletonBin,0),'FaceColor',col,'EdgeColor','none');
axis equal;axis off;
lighting phong;
isonormals(skeletonBin,hiso);
alpha(0.5);
set(gca,'DataAspectRatio',[1 1 1])
camlight;
hold on;
w=size(skel,1);
l=size(skel,2);
h=size(skel,3);
[x,y,z]=ind2sub([w,l,h],find(skel(:)));
plot3(y,x,z,'square','Markersize',4,'MarkerFaceColor','r','Color','r');            
set(gcf,'Color','white');
view(140,80)
