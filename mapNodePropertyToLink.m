%% --------------------- mapNodePropertyToLink ----------------------------
% Avik Mondal
% 
% Aim:
% - a function that takes a node's properties and maps them to that of a
% link either by assigning the property of a link's respective nodes to
% itself. Given that a link has two nodes, one can select how assignment
% works. I.e. you can take the minimum of the two options or the mean or
% the max
%
% Parameters:
%
% struct nodes - the nodes of a binarized skeleton VOI
% struct links - the links of a binarized skeleton VOI
% string property - the field containing the property of interest
%  - options: "closeness", "betweenness", "eigenvector",
%  "pagerank","strength", "clustering","nndegree","nnstrength"
% string method - method of assignment, i.e. "min", "max", "mean"
%--------------------------------------------------------------------------
function link2 = mapNodePropertyToLink(nodes,links, property, method)
link2 = links;
if strcmp(property,"closeness")
    prop_array = [nodes.closeness];
elseif strcmp(property,"betweenness")
    prop_array = [nodes.betweenness];
elseif strcmp(property,"eigenvector")
    prop_array = [nodes.eigenvector];
elseif strcmp(property,"pagerank")
    prop_array = [nodes.pagerank];
elseif strcmp(property,"strength")
    prop_array = [nodes.strength];
elseif strcmp(property,"clustering")
    prop_array = [nodes.clusteringC];
elseif strcmp(property,"nndegree")
    prop_array = [nodes.nearestNeighborDegree];
elseif strcmp(property,"nnstrength")
    prop_array = [nodes.nearestNeighborStrength];
else
    disp("Please pick a valid property");
end
linkproperty = zeros(length(links),1);
for test = 1:length(links)
    n1 = links(test).n1;
    n2 = links(test).n2;
    sample = [prop_array(1,n1), prop_array(1,n2)];
    if strcmp(method,'min')
        linkproperty(test,1) = min(sample); 
    elseif strcmp (method,'mean')
        linkproperty(test,1) = mean(sample);
    elseif strcmp (method,'max')
        linkproperty(test,1) = max(sample);
    end
end
C = num2cell(linkproperty);
if strcmp(property,"closeness")
    [link2.closeness] = C{:};
elseif strcmp(property,"betweenness")
    [link2(:).betweenness] = C{:};
elseif strcmp(property,"eigenvector")
    [link2(:).eigenvector] = C{:};
elseif strcmp(property,"pagerank")
    [link2(:).pagerank] = C{:};
elseif strcmp(property,"strength")
    [link2(:).strength] = C{:};
elseif strcmp(property,"clustering")
    [link2(:).clustering] = C{:};
elseif strcmp(property,"nndegree")
    [link2(:).nearestNeighborDegree] = C{:};
elseif strcmp(property,"nnstrength")
    [link2(:).nearestNeighborStrength] = C{:};
end