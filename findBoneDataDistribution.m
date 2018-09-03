function findBoneDataDistribution(nodeWithProps, linkWithProps)

%run getNodeLinkProperties before running this!

degreeC = [nodeWithProps.degreeC];
figure('Name','Degree C Fig');
histogram(degreeC);
[N,edges] = histcounts(degreeC);
edges2 = edges(2:length(edges));
N2 = N(2:length(N));
xLLim =edges2(find(N2,1)); %takes into account the nodes that are endpoints (or have degree 2)
yULim = max(N)*1.2;
%finds the largest bin and determines the y axis upper limit based off that
axis([xLLim 1 0 yULim]);
title("Degree Centrality Distribution");
xlabel("Centrality Ratio");
ylabel("Number of Nodes");

strength = [nodeWithProps.strength];
figure('Name','Strength Dist Fig');
histogram(strength);
[Nstr,edgesstr] = histcounts(strength);
edgesstr2 = edgesstr(2:length(edgesstr));
N2str = Nstr(2:length(Nstr));
xLLimstr =edges2(find(N2str,1)); %takes into account the nodes that are endpoints (or have degree 2)
yULimstr = max(Nstr)*1.2;
%finds the largest bin and determines the y axis upper limit based off that
axis([xLLimstr 1 0 yULimstr]);
title("Strength Distribution");
xlabel("Strength Ratio");
ylabel("Number of Nodes");

NNDegree = [nodeWithProps.nearestNeighborDegree];
figure('Name','Nearest Neighbor Degree');
histogram(NNDegree);
[NNND,edgesNND] = histcounts(NNDegree);
edgesNND2 = edgesstr(2:length(edgesNND));
NNND2 = NNND(2:length(NNND));
xLLimNND =edges2(find(NNND2,1)); %takes into account the nodes that are endpoints (or have degree 2)
yULimNND = max(NNND)*1.2;
%finds the largest bin and determines the y axis upper limit based off that
axis([xLLimNND 1 0 yULimNND]);
title("Nearest Neighbor Degree");
xlabel("NND ratio");
ylabel("Number of Nodes");

Length = [linkWithProps.length];
figure('Name','Link Length');
histogram(Length);
[NLength,edgesLength] = histcounts(Length);
title("Link Length Distribution");
xlabel("Link Length");
ylabel("Number of Links");
