%% ----------------- findNodeCentrality -------------------------
% Avik Mondal
% 
% Aim:
% - this function outputs the centrality measures of the network
%
% Parameters:   
% 
% struct node - contains the nodes generated from converting skeletonBin to
%    a graph
% struct link - contains the links generated from converting skeletonBin to
%    a graph
% boolean normalize - if true, the program normalizes the measures by
% dividing all the values by the max value
% string varargins (weighttype) - indicates what to use to weight the measures
%
%closeness centrality formulation: 
% https://toreopsahl.com/2010/03/20/closeness-centrality-in-networks-with-disconnected-components/
%~because my networks can be disconnected, I've used harmonic centrality
% 
% this requires a isolated subgraph!!!!!!!!!!!!
%--------------------------------------------------------------------------
function node2 = findNodeCentrality(node,link, normalize)

A = createAdjacencyMatrix(node,link, 'thickness');
G = graph(A); 
A2 = createAdjacencyMatrix(node,link,'length');
G2 = graph(A2);
node2 = node;
    
%currently, using weighted centrality
node_centrality(1,:) = (centrality(G2, 'betweenness', 'Cost', G2.Edges.Weight));
node_centrality(2,:) = (centrality(G2, 'closeness','Cost', G2.Edges.Weight));
node_centrality(3,:) = (centrality(G, 'eigenvector','Importance', G.Edges.Weight));
node_centrality(4,:) = (centrality(G, 'degree','Importance', G.Edges.Weight));
node_centrality(5,:) = (centrality(G, 'pagerank', 'Importance', G.Edges.Weight));
node_centrality = node_centrality';

for i = 1:length(node_centrality)
    node2(i).betweenness = node_centrality(i,1);
    node2(i).closeness = node_centrality(i,2);
    node2(i).eigenvector = node_centrality(i,3);
    node2(i).degreeC = node_centrality(i,4);
    node2(i).pagerank = node_centrality(i,5);
end

max_between = max([node2.betweenness]);
max_closeness = max([node2.closeness]);
max_eigenvector = max([node2.eigenvector]);
max_degreeC = max([node2.degreeC]);
max_pagerank = max([node2.pagerank]);
if (normalize)
    for i = 1:length(node_centrality)
        node2(i).betweenness = node2(i).betweenness / max_between;
        node2(i).closeness = node2(i).closeness / max_closeness;
        node2(i).eigenvector = node2(i).eigenvector / max_eigenvector;
        node2(i).degreeC = node2(i).degreeC / max_degreeC;
        node2(i).pagerank = node(i).pagerank / max_pagerank;
    end
end

