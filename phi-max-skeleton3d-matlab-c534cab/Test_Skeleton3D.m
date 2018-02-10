%clear all;
%close all;

%load testvol

%skel = Skeleton3D(testvol);
%skel = Skeleton3D(bigBinImage); % my code
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
set(gcf,'Color','white');
view(140,80)
