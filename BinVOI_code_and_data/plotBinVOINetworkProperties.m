%LOAD IN NECESSARY VARIABLES AND WORKSPACES
volumeFractionMatrix = binVOIVF;
linearIndices = 1:40;
vfMap = [4,10];
[Y,X] = ind2sub(vfMap, linearIndices); 
for i = 1:length(linearIndices)
    vfMap(Y(1,i),X(1,i)) = volumeFractionMatrix(i);
end

%vfMap = transpose(vfMap);
xlin = linspace(50,951, 10);
ylin = linspace(50,351, 4);
imagesc(xlin,ylin,vfMap);
colorbar;
title('Volume Fraction');
ylabel('Y coordinates');
yticks([001 101 201 301]);
xlabel('X coordinates');
xticks(1:100:901);
set(gcf,'units','points','position',[10,10,900,300]);