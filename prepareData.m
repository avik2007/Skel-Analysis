load('graphVOI_501x101y.mat','node','link','skel');
res = 0.037; % resolution (mm)
nodet = struct2table(node);
linkt = struct2table(link);
nodemat = [(1:height(nodet))', res*nodet.comx, res*nodet.comy, res*nodet.comz];
conn = nodet.conn;

% sort nodemat by increasing z
nodemat = sortrows(nodemat,4);
nodemat = [(1:length(nodemat))',nodemat];

% add a 4th column to linkmat that keeps track of original links, so can
% determine thicknesses later
linkmat = [(1:height(linkt))',linkt.n1,linkt.n2,(1:height(linkt))'];
linkmat = double(linkmat);

% remap end-nodes of links in linkmat to match sorted node order
map = containers.Map(nodemat(:,2)',nodemat(:,1)');
conn2 = cell(size(conn));
for i = 1:length(conn)
    conn2{i} = arrayfun(@(x) map(x), conn{i});
end
conn = conn2(nodemat(:,2)); %% gotta resort the conn to be in the same order as before!
startNodes = arrayfun(@(x) map(x), linkmat(:,2));
endNodes = arrayfun(@(x) map(x), linkmat(:,3));
linkmat(:,2:3) = [startNodes endNodes];
nodemat(:,2) = [];

% cut everything above 2.7 and below 0.1
toppt = 3.515;
bottompt = 0.074;
topNode = find(nodemat(:,4) <= toppt, 1,'last');
topLinks = find((linkmat(:,2) <= topNode & linkmat(:,3) >= topNode) | (linkmat(:,2) >= topNode & linkmat(:,3) <= topNode));
bottomNode = find(nodemat(:,4) >= bottompt, 1,'first');
bottomLinks = find((linkmat(:,2) <= bottomNode & linkmat(:,3) >= bottomNode) | (linkmat(:,2) >= bottomNode & linkmat(:,3) <= bottomNode));
newLinks = linkmat((linkmat(:,2) <= topNode & linkmat(:,2) >= bottomNode) & (linkmat(:,3) <= topNode & linkmat(:,3) >= bottomNode),:);
newNodes = nodemat(unique(reshape(newLinks(:,2:3),2*length(newLinks),1)),:);

extraNodes = [linkmat(topLinks,2) linkmat(topLinks,3)];
extraNodes = reshape(extraNodes, 2*size(extraNodes,1),1);
extraNodes(ismember(extraNodes,newNodes(:,1))) = [];
extraNodes = unique(extraNodes);
extraNodes = nodemat(extraNodes,:);
extraNodes(:,4) = toppt;
newNodes = vertcat(newNodes,extraNodes);

extraNodes = [linkmat(bottomLinks,2) linkmat(bottomLinks,3)];
extraNodes = reshape(extraNodes, 2*size(extraNodes,1),1);
extraNodes(ismember(extraNodes,newNodes(:,1))) = [];
extraNodes = unique(extraNodes);
extraNodes = nodemat(extraNodes,:);
extraNodes(:,4) = bottompt;
newNodes = vertcat(newNodes,extraNodes);

newLinks = vertcat(newLinks, linkmat(topLinks,:), linkmat(bottomLinks,:));


nodemat = newNodes;
linkmat = newLinks;

% have to get rid of duplicates in links

[~,ia] = unique(linkmat(:,4),'stable');
linkmat = linkmat(ia,:);

nodet2 = array2table(nodemat,'VariableNames',{'nodenum','x','y','z'});
linkt2 = array2table(linkmat,'VariableNames',{'linknum','startnode','endnode','originalnum'});
links = table2struct(linkt2);
nodes = table2struct(nodet2);
[nodes.conn] = conn{:};
skel2 = skel(:,:,6:end-2); % cut off bottom 2 slices and top 5 slices of skel... is it 6:end-2 or 3:end-5?
[node3,link3]=findSpanningSubGraph(nodes,links,skel2);