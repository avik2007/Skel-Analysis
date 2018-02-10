trabDataList = tbspstds;
linearIndices = 1:40;
tbMap = [4,10];
[Y,X] = ind2sub(tbMap, linearIndices); 
for i = 1:length(linearIndices)
    tbMap(Y(1,i),X(1,i)) = trabDataList(i);
end

%vfMap = transpose(vfMap);
xlin = linspace(50,951, 10);
ylin = linspace(50,351, 4);
imagesc(xlin,ylin,tbMap);
colorbar;
title('Trabecular Spacing Standard Deviation');
ylabel('Y coordinates');
yticks([001 101 201 301]);
xlabel('X coordinates');
xticks(1:100:901);
set(gcf,'units','points','position',[10,10,900,300]);
