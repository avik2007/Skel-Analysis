%% ------------------------------- findSpanningSubgraph ------------------------------
% Avik Mondal
% 
% Aim:
% - this function aims to find the subgraph that spans the full axial
% direction of the graph (i.e. an "infinite" cluster from percolation
% theory - here infinite just means the top and bottom of the z direction
% are connected)
%
% Parameters:   
% struct node - contains the nodes generated from converting skeletonBin to
%    a graph
% struct link - contains the links generated from converting skeletonBin to
%    a graph
% matrix skel
% link for implementing list, queue,stack
%http://www.mathworks.com/matlabcentral/fileexchange/45123-data-structures?focused=3805777&tab=function
%--------------------------------------------------------------------------
function [node3,link3] = findSpanningSubGraph(node,link,skel)
%makes sure subgraphs are a field of the node struct
%FOR NOW, (2/8/18) NO MORE CORRL STUFF


%{
CURRENTLY THIS CODE ASSUMES THAT THE LARGEST SUBGRAPH IS THE ONLY POSSIBLE
SPANNING SUBGRAPH
%}
if ( isfield(node,'subGraph') )
    node2 = node;
    link2 = link;
else
    [node2,link2] = findSubGraphs(node,link,skel);
end


%corrL = findCorrelationLength(node2,link2,skel);

spanningSubGraph = 0;

spanningSubGraph = mode([node2.subGraph]);
[node3,link3] = isolateSubgraph(node2,link2,skel,spanningSubGraph); 


%{

corrL = findCorrelationLength(node2,link2,skel);

spanningSubGraph = 0;


if (corrL < Inf)
    spanningSubGraph = mode([node2.subGraph]);
    [node3,link3] = isolateSubgraph(node2,link2,skel,spanningSubGraph); 

%step 1: adjust the node numbers!
else

    node3 = node2;
    link3 = link2;

    node3(1) = [];
    link3(1) = [];

    disp("No infinite subgraph");
    %{
    v = unique([node2.subGraph]);
    [~,~,subGraphNums = find(v ~= mode([node2.subGraph]));
    for index1 = 1:length(subGraphNums)
        
    end
    %}
end

%}



%node2([node2.subGraph] ~= spanningSubGraph) = [];
%link2([node2.subGraph] ~= spanningSubGraph) = [];




