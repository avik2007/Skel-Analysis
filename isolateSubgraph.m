%% ------------------------------- isolateSubgraph ------------------------------
% Avik Mondal
% 
% Aim:
% - this function returns the nodes and links of just 1 subgraph from a
% selected graph
%
% Parameters:   
% struct node - contains the nodes generated from converting skeletonBin to
%    a graph (needs subGraphs)
% struct link - contains the links generated from converting skeletonBin to
%    a graph (needs subGraphs)
% matrix skel
% link for implementing list, queue,stack
%http://www.mathworks.com/matlabcentral/fileexchange/45123-data-structures?focused=3805777&tab=function
%--------------------------------------------------------------------------
function [nodeS,linkS] = isolateSubgraph(node,link,skel,subgraph);

badNodes = find([node.subGraph] ~= subgraph);
badLinks = find([link.subGraph] ~= subgraph);

%creates an adjustment vector that contains the replacements for the "bad
%nodes"
nodeAdj = 1:length(node);
linkAdj = 1:length(link);

minBad = min(badNodes);
minBadLink = min(badLinks);
for i= 1:length(node)
     if i > minBad
         nodeAdj(1,i) =  nodeAdj(1,i)- sum(badNodes < i);
     end
end

for j = 1:length(link)
    if j > minBadLink
        linkAdj(1,j) = linkAdj(1,j) - sum(badLinks < j); 
    end
end

nodeS = struct;
linkS = struct; 
nodefields = fieldnames(node);
linkfields = fieldnames(link);
for nf1 = 1:length(nodefields)
    nodeS = setfield(nodeS,nodefields{nf1,1},{});
end
for lf1 = 1:length(linkfields)
    linkS = setfield(linkS,linkfields{lf1,1},{});
end

adjInd = 1;
current = 1;

linkS = link([link.subGraph] == subgraph);
for indexLink = 1:length(linkS)
    linkS(indexLink).n1 = nodeAdj(linkS(indexLink).n1);
    linkS(indexLink).n2 = nodeAdj(linkS(indexLink).n2);
end
nodeS = node([node.subGraph] == subgraph);
for indexNode = 1:length(nodeS)
    conns = nodeS(indexNode).conn ;
    links = nodeS(indexNode).links;
    for indexConn = 1:length(conns)
        conns(1,indexConn) = nodeAdj(conns(1,indexConn));
        links(1,indexConn) = linkAdj(links(1,indexConn));
    end
    nodeS(indexNode).conn = conns;
    nodeS(indexNode).links = links;
end
%{
while ( adjInd < length(node) )
     if ismember(adjId,badNodes)
         adjInd = adjInd + 1;
     else
         nodeS(current).idx = 
     end
end
%}

   
