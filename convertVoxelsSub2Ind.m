%Used to convert FIJI analyse skeleton data (not in use as of 7/1/17)
axFijiDataLinearSubs = struct('length',{},'V1',{},'V2',{},'euclidDistance',{});
V1x = results(:,3);
V1y = results(:,4);
V1z = results(:,5);
V2x = results(:,6);
V2y = results(:,7);
V2z = results(:,8);

for i=1:n
    axFijiDataLinearSubs(i).V1 = sub2ind([n,n,n],V1x(i)+1,V1y(i)+1,V1z(i)+1);
    axFijiDataLinearSubs(i).V2 = sub2ind([n,n,n],V2x(i)+1,V2y(i)+1,V2z(i)+1);
    axFijiDataLinearSubs(i).length = axFijiData(i).length;
    axFijiDataLinearSubs(i).euclidDistance = axFijiData(i).euclidDistance;
end
