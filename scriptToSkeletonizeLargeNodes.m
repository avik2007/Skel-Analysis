
for i = 1:length(x)
    node259(x(i,1),y(i,1),z(i,1)) = 1;
end

skel259 = Skeleton3D(node259);
plot3DSkeleton(skel259);
skel2592 = Skeleton3D(skel259);
plot3DSkeleton(skel2592);
[node259,link259] = convertSkelToGraph(skel2592,0);
plotLocalNetworkParameter( skel2592,node259,link259,"cats");