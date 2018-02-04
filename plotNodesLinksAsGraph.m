%% --------------------- plotNodesLinksAsGraph ----------------------------
% Avik Mondal
% 
% Aim:
% - a function that takes as inputs Nodes and Links (from Skel2Graph) and
%   plots them as a graph
% - USED PRIMARILY TO PLOT A SUBSET OF NODES OR INDIVIDUAL NODES WITH THEIR
% LINKS
%
% Parameters:
% array skel - the binarized skeleton VOI
% struct nodes - the nodes of a binarized skeleton VOI
% struct links - the links of a binarized skeleton VOI
%
%--------------------------------------------------------------------------

function plotNodesLinksAsGraph(skel,node2,link2)

addpath('C:\Users\avik2\Documents\Carlson Lab\Bone Project MATLAB code\phi-max-skel2graph3d-matlab-8939088');
addpath('C:\Users\avik2\Documents\Carlson Lab\Bone Project MATLAB code\TinyAxis');
%specific to Avik's computer only
w = size(skel,1);
l = size(skel,2);
h = size(skel,3);

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
    if (node2(i).ep == 0)
        plot3(y1,x1,z1,'o','Markersize',9,...
            'MarkerFaceColor',ncol,...
            'Color','k');
    end
    %if (isfield(node2,'parent'))
    %    if (node2(i).parent >= 0)
    %if (ismember(i,[133,143,149,155,161,165,168,169,186,187,188,193,194,199,200,206,235]))
           % text(y1,x1,z1,['  ' num2str(i)],'FontSize',10,'Color','red');
    %    end 
    end    

title('Network');
axis image;axis off;
set(gcf,'Color','white');
drawnow;    
view(-59,52);
tinyaxis(gca,'r','g','b');