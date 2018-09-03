
load('VOI_901x301y');
VOI = VOI_901x301y;
dual = not(VOI);
clear VOI;
addpath('C:\Users\Avik Mondal\Documents\Carlson Lab\Bone Project MATLAB code\phi-max-skeleton3d-matlab-c534cab');
addpath('C:\Users\Avik Mondal\Documents\Carlson Lab\Bone Project MATLAB code\phi-max-skel2graph3d-matlab-8939088');
dual_skeleton = Skeleton3D(dual);
[dnode,dlink] = convertSkelToGraph(dual_skeleton,0);
