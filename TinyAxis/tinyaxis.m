%   % description
% Author: Jeroen van Nugteren

% Description:
% 'tiny axes' shows the orientation of the provided axes in the lower left 
% corner and links the rotation. This way the orientation can still be seen 
% when the axis are disabled. 

% example:
% f = figure('Color',[0.3 0.3 0.32]);
% h = axes('Parent',f);
% surf(X,Y,Z,'Parent',h); 
% axis(h,'off'); 
% tinyaxis(h,'r','g','b');


%% create tinyaxes function
function axesport = tinyaxis(ax,c1,c2,c3)
% get current axes
currentaxes = gca;

% get parent of ax
panel = get(ax,'Parent');

% create axes in corner
axesport = axes('Parent',panel,'HitTest','off','HandleVisibility','off','Units','pixels','Color','none');
set(axesport,'Position',[40 40 50 50],'XColor',c1,'YColor',c2,'ZColor',c3);
set(axesport,'XTick',[],'YTick',[],'ZTick',[],'LineWidth',2);
hold(axesport,'on'); 
ylabel(axesport,'X','FontWeight','bold'); 
xlabel(axesport,'Y','FontWeight','bold'); 
zlabel(axesport,'Z','FontWeight','bold');
setappdata(ax,'axesport',axesport);

% set view equal to ax
vw = get(ax,'view');
view(axesport,vw);
    
% set post rotate3d function
h = rotate3d(ax); set(h,'ActionPostCallback',@onRotate3D);

% set current axes back to ax
axes(currentaxes);
end

%% post rotation function
function onRotate3D(~,event)
axesport = getappdata(event.Axes,'axesport');
newView = get(event.Axes,'View');
set(axesport,'View',newView);
end