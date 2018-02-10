%% ---------------------- plotSkelAsGraph ------------------------------
% Avik Mondal
% 
% Aim:
% - a function that allows me to convert a skeleton to a graph (I load in 
% the matrix that contains the VOI and it displays and image of the graph)
%
% Parameters:
%
% array skel - contains the binarized skeletal VOI
% int16 labelNodes - 2 shows the plot with all nodes labeled, 1 shows the
%   plot with only end nodes labeled. o.w, no labels.
%--------------------------------------------------------------------------

function plotSkelAsGraph(skel,labelNodes)

addpath('C:\Users\Avik\Documents\Carlson Lab\Bone Project MATLAB code\phi-max-skel2graph3d-matlab-8939088');
%specific to Avik's computer only

w = size(skel,1);
l = size(skel,2);
h = size(skel,3);

% initial step: condense, convert to voxels and back, detect cells
[~,node,link] = Skel2Graph3D(skel,0);

% total length of network
wl = sum(cellfun('length',{node.links}));

skel2 = Graph2Skel3D(node,link,w,l,h);
[~,node2,link2] = Skel2Graph3D(skel2,0);

% calculate new total length of network
wl_new = sum(cellfun('length',{node2.links}));

% iterate the same steps until network length changed by less than 0.5%
while(wl_new~=wl)

    wl = wl_new;   
    
     skel2 = Graph2Skel3D(node2,link2,w,l,h);
     [A2,node2,link2] = Skel2Graph3D(skel2,0);

     wl_new = sum(cellfun('length',{node2.links}));

end

% display result
figure();
hold on;
for i=1:length(node2)
    x1 = node2(i).comx;
    y1 = node2(i).comy;
    z1 = node2(i).comz;
    
    if(node2(i).ep==1)
        ncol = 'c';
    else
        ncol = 'y';
    end
    
    for j=1:length(node2(i).links)    % draw all connections of each node
        if(node2(link2(node2(i).links(j)).n2).ep==1)
            col='k'; % branches are blue
        else
            col='k'; % links are red
        end
        if(node2(link2(i).n1).ep==1)
            col='k';
        end

        
        % draw edges as lines using voxel positions
        for k=1:length(link2(node2(i).links(j)).point)-1            
            [x3,y3,z3]=ind2sub([w,l,h],link2(node2(i).links(j)).point(k));
            [x2,y2,z2]=ind2sub([w,l,h],link2(node2(i).links(j)).point(k+1));
            line([y3 y2],[x3 x2],[z3 z2],'Color',col,'LineWidth',2);
        end
    end
    
    % draw all nodes as yellow or blue circles
    plot3(y1,x1,z1,'o','Markersize',9,...
        'MarkerFaceColor',ncol,...
        'Color','k');
    if ( (labelNodes == 1) && (node2(i).ep == 1) )
        text(y1,x1,z1,['  ' num2str(i)],'FontSize',10,'Color','red');
    elseif (labelNodes == 2)
        text(y1,x1,z1,['   ' num2str(i)],'FontSize',8,'Color','red');
    end    
    
end
axis image;axis off;
set(gcf,'Color','white');
drawnow;
view(-17,46);
