% figure()
% hold on

Np = 1000;
%smoothparamarray=[0.1:0.1:0.7];
%numTotal=size(smoothparamarray,2);
numTotal = 50;


paramLength = zeros(Np, numTotal);
%interpa = zeros(Np, numTotal);
smooth_interpa = zeros(Np,numTotal);
cpIndex=zeros(numTotal,1);
paramLengthDetected=zeros(numTotal,1);
% num = 1; 
for num = 1: numTotal
    smoothparam = 0.3;%Smoothing parameter I'm pickin for now %smoothparamarray(i);
    GelOutlineDetectionv3
    findInflectionPoints
end



