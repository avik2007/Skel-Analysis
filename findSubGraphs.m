%% ------------------------------- findSubGraphs ------------------------------
% Avik Mondal
% 
% Aim:
% - this function aims to find the individual sub graphs of the main graph
% derived from skeletonization
%
% Parameters:   
% struct node - contains the nodes generated from converting skeletonBin to
%    a graph
% struct link - contains the links generated from converting skeletonBin to
%    a graph
%--------------------------------------------------------------------------
function [node2,link2] = findSubGraphs(node,link,skel)  
%FIND OUT IF YOU CAN CHECK IF THIS IS ON THE PATH (MIGHT SAVE COMPUTING
%POWER)
addpath('C:\Users\Avik Mondal\Documents\Carlson Lab\Bone Project MATLAB code\Data_Structures\Data Structures\Queues');
startNode = 1; %setting up a start node

%setting up a new set of structs to decompose our current one into
node2 = node;
link2 = link;


clusteredNodes = zeros(1,length(node)); %stores nodes that have already been assigned a subgraph
%{
nodefields = fieldnames(node);
linkfields = fieldnames(link);
for nf1 = 1:length(nodefields)
    node2 = setfield(node2,nodefields{nf1,1},{});
end
for lf1 = 1:length(linkfields)
    link2 = setfield(link2,linkfields{lf1,1},{});
end
%}
subgraphIndex = zeros(1,length(node)); %a geodesic vector
lengthIndex = zeros(1,length(node)); % contains lengths between node 1 and all other nodes
sgnumber = 0;

while ( ~isempty(subgraphIndex) )
   sgnumber = sgnumber + 1;
   lNum = 1;
   lengthIndex = findGeodesicVector(node,link,startNode);
   clusteredNodes(1,startNode) = 1;
   nodeIndex = find(lengthIndex < Inf);
   %disp(nodeIndex);
   for n1 = 1:length(nodeIndex)
       %node2(sgnumber,n1) = node(nodeIndex(n1));
       %node2(nodeIndex(n1)) = node(nodeIndex(n1));
       node2(nodeIndex(n1)).subGraph = sgnumber; 

       n1Links = find([link.n1] == nodeIndex(n1));
       for n1L = 1:length(n1Links)
           %link2(sgnumber,lNum) =  link(n1Links(n1L));
           link2(n1Links(n1L)).subGraph = sgnumber;
           %lNum = lNum+1;
       end
       clusteredNodes(nodeIndex(n1)) = 1;
   end
   %{
    for n2 = 0:length(nodeIndex)-1
       operatingVar = length(nodeIndex)-n2;
       node(nodeIndex(length(nodeIndex)-n2)) = [];
       n2Links = find([link.n1] == nodeIndex(length(nodeIndex)-n2));
       for n2L = 0:length(n2Links)-1
           link(n2Links(length(n2Links) - n2L)) = [];
       end
   end
   %}
   
   subgraphIndex = find((lengthIndex == Inf) & (clusteredNodes == 0)); %finds the next group of nodes to be decomposed
   if ( length(subgraphIndex) > 0 )
       startNode = subgraphIndex(1);
   end
   
end

    
