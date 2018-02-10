%% -------------------- plotTrabeculaScript -----------------------------
% Avik Mondal
% 
% Aim:
% - plot a specific node or link or trabecula
%
% Workspace needs to have:
% link, node, VOI
%--------------------------------------------------------------------------
skel = fiji_skel;
%trab = find(VOI(:));
trab = node(259).idx;
%links = node(259).links;
%for i = 1:91
%    trab = vertcat(trab, (link(links(i)).point)');
%end
w=size(skel,1);
l=size(skel,2);
h=size(skel,3);
[x,y,z]=ind2sub([w,l,h],trab);
figure();
plot3(y,x,z,'square','Markersize',4,'MarkerFaceColor','r','Color','r'); 


title('Trabecula');
set(gca,'visible','off');
set(gcf,'Color','white');
view(-59,52)
tinyaxis(gca,'r','g','b');