function [nodeF,linkF] = convertSkelToGraph(skel, THR)
%THR is a link length threshold
%addpath('C:\Users\Avik Mondal\Documents\Carlson Lab\Bone Project MATLAB code\phi-max-skel2graph3d-matlab-8939088');
addpath('phi-max-skel2graph3d-matlab-8939088');
w = size(skel,1);
l = size(skel,2);
h = size(skel,3);

% initial step: condense, convert to voxels and back, detect cells
[~,node,link] = Skel2Graph3D(skel, THR);

% total length of network
wl = sum(cellfun('length',{node.links}));

skel2 = Graph2Skel3D(node,link,w,l,h);
[~,node2,link2] = Skel2Graph3D(skel2,THR);

% calculate new total length of network
wl_new = sum(cellfun('length',{node2.links}));

% iterate the same steps until network length changed by less than 0.5%
while(wl_new~=wl)

    wl = wl_new;   
    
     skel2 = Graph2Skel3D(node2,link2,w,l,h);
     [~,node2,link2] = Skel2Graph3D(skel2,THR);

     wl_new = sum(cellfun('length',{node2.links}));

end
nodeF = node2;
linkF = link2;
%uses skel as parameter because it just needs the skeleton's dimensions

%linkF = findBranchLength(link2,skel);

%branch length is most probably unnecessary (7_6_17)
