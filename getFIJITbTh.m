%% ------------------------ getFIJITbTh ------------------------------
% Avik Mondal
% 
% Aim:
% - this function aims to find the path lengths between two points in the
%   bone network (skel2graph)
%
% Parameters:   
% array thicknessMap - contains the thickness mapping of the skeletal VOI
% as produced by FIJI's BoneJ plugin (Thickness function)
% struct link - contains the links generated from converting skeletonBin to
%    a graph
% double tbthmax - max trabecular thickness
%--------------------------------------------------------------------------
function linkWithThickness = getFIJITbTh(thicknessMap,link,tbthmax)

linkWithThickness = link;
w = size(thicknessMap,1);

l = size(thicknessMap,2);
h = size(thicknessMap,3);

linkSize = length(linkWithThickness);

for i=1:linkSize
    pointList = linkWithThickness(i).point;
    pointSize = length(pointList); 
    %xList = zeros(1,pointSize);
    %yList = zeros(1,pointSize);
    %zList = zeros(1,pointSize);
    thList = zeros(1,pointSize);
    for j=1:pointSize
        %[xList(1,j),yList(1,j),zList(1,j)]=ind2sub([w,l,h],pointList(j));
        %thList(1,j) = thicknessMap(xList(1,j),yList(1,j),zList(1,j));
        [xList,yList,zList]=ind2sub([w,l,h],pointList(j));
        thList(1,j) = double( thicknessMap(xList,yList,zList) )*( tbthmax / 255.0 );
    end
    linkWithThickness(i).thicknesses = thList;
    linkWithThickness(i).avgthickness = mean(thList);
end
%a temporary way to store all this information
linkWithThickness(1).maxthickness = tbthmax;
%linkWithThickness(1).meanthickness = tbthmean;
%linkWithThickness(1).stdthickness = tbthstd;