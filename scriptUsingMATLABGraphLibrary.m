%%
% This script uses MATLAB's graph theory to calculate a slough of metrics
% that they do more efficiently.
%
% I MAY TURN THIS INTO A FUNCTION FOR EFFICIENCY/EASE/CLEANLINESS 


%going from my struct to a MATLAB graph
%Needs adjacency matrix
A = createAdjacencyMatrix(node_trunc,link_trunc, 'none');
G = graph(A); 

node_centrality(1,:) = (centrality(G, 'betweenness'));
node_centrality(2,:) = (centrality(G, 'closeness'));
node_centrality(3,:) = (centrality(G, 'eigenvector'));
node_centrality(4,:) = (centrality(G, 'degree'));
node_centrality = node_centrality';