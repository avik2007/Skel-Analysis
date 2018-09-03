%% ---------------------- removeLinksForStressCorrelations ----------------------------
% Avik Mondal
% 
% Aim:
% - this function does link removal on a set of nodes/links and calculates
% the correlation between removed link centrality and data 
%
% Procedure in this function:
%1. Let N be the number of links in the network minus the number of
%stressed links
%2. Randomly choose N links in the original network and remove them.
%Calculate the resulting centrality
%3. Calculate r values and p values between the new centrality and the
%stress
%4. Repeat a few times
% 
%Inputs:
% node: struct containing node data
% link: struct containing link data
% feature: centrality measure of choice
% linksToRemove: number of links that should be removed
% iter: number of times to repeat the procedure
%--------------------------------------------------------------------------
function [rvals, pvals, newnode,newlink] = removeLinksForStressCorrelations(node,link,feature,numLinksToRemove, iter)
addpath('C:\Users\Avik Mondal\Documents\Carlson Lab\Bone Project MATLAB code\matlab-networks-toolbox');
rvals = zeros(iter+1,1);
pvals = zeros(iter+1,1);
newnode = node;
newlink = link;
STR = createAdjacencyMatrix(newnode,newlink,'stress');
%STRdata = zeros(length(node),1);
GSTR = graph(createAdjacencyMatrix(node,link,'stress'));
if strcmp(feature,'closeness')
    %STRdata = centrality(GSTR,'closeness', 'Cost', GSTR.Edges.Weight);
    STRdata = centrality(GSTR,'closeness');
elseif strcmp(feature,'betweenness')
    %STRdata = centrality(GSTR,'betweenness', 'Cost', GSTR.Edges.Weight);
    STRdata = centrality(GSTR,'betweenness');
elseif strcmp(feature,'eigenvector')
    %STRdata = centrality(GSTR, 'eigenvector','Importance', GSTR.Edges.Weight);
    STRdata = centrality(GSTR, 'eigenvector');
elseif strcmp(feature,'degree')
    STRdata = centrality(GSTR, 'degree');
elseif strcmp(feature,'pagerank')
    %STRdata = centrality(GSTR, 'pagerank','Importance', GSTR.Edges.Weight);
    STRdata = centrality(GSTR, 'pagerank');
elseif strcmp(feature,'strength')
    STRdata = findNetworkNodeStrength(STR);
else %strcmp(feature,'clustering')
    STRdata = weightedClustCoeff(STR);
end

%If you want, you can combine this control sequence with the previous, or

A = createAdjacencyMatrix(node,link,'thickness');
%G = graph(A);
G = graph(createAdjacencyMatrix(newnode,newlink,'thickness'));
A2 = createAdjacencyMatrix(node,link,'length');
G2 = graph(createAdjacencyMatrix(newnode,newlink,'length'));
    %Gdata = zeros(length(node),1);
    if strcmp(feature,'closeness')
        Gdata = centrality(G2,'closeness', 'Cost', G2.Edges.Weight);
    elseif strcmp(feature,'betweenness')
        Gdata = centrality(G2,'betweenness','Cost', G2.Edges.Weight);
    elseif strcmp(feature,'eigenvector')
        Gdata = centrality(G, 'eigenvector','Importance', G.Edges.Weight);
    elseif strcmp(feature,'degree')
        Gdata = centrality(G, 'degree');
    elseif strcmp(feature,'pagerank')
        Gdata = centrality(G, 'pagerank','Importance', G.Edges.Weight);
    elseif strcmp(feature,'strength')
        Gdata = findNetworkNodeStrength(A);
    else %strcmp(feature,'clustering')
        Gdata = weightedClustCoeff(A);
    end
    
    [R,P] = corrcoef(STRdata,Gdata);
    rvals(1,1) = R(1,2);
    pvals(1,1) = P(1,2);
    
for overallIndex = 1:iter
    % below is code for if you want to randomly remove nodes
    linksToRemove = sort(randi(length(newlink), [numLinksToRemove 1]),'descend'); 
    %below is code for it you want to remove the least stressed nodes
    
    %debugging code
    %disp(length(find(A)))
    for LTR = 1:length(linksToRemove)
        node1 = newlink(linksToRemove(LTR,1)).n1;
        node2 = newlink(linksToRemove(LTR,1)).n2;
        A(node1, node2) = 0;
        A(node2, node1) = 0;
        A2(node1, node2) = 0;
        A2(node2, node1) = 0;
    end
     % can't use isolateSubgraph because i need to maintain number of links
    newlink(linksToRemove) = [];
    
    %debugging code
    %disp(length(find(A)));
    G = graph(A);
    G2 = graph(A2);
    %Gdata = zeros(length(node),1);
    if strcmp(feature,'closeness')
        Gdata = centrality(G2,'closeness','Cost', G.Edges.Weight);
    elseif strcmp(feature,'betweenness')
        Gdata = centrality(G2,'betweenness','Cost', G.Edges.Weight);
    elseif strcmp(feature,'eigenvector')
        Gdata = centrality(G, 'eigenvector','Importance', G.Edges.Weight);
    elseif strcmp(feature,'degree')
        Gdata = centrality(G, 'degree');
    elseif strcmp(feature,'pagerank')
        Gdata = centrality(G, 'pagerank','Importance', G.Edges.Weight);
    elseif strcmp(feature,'strength')
        Gdata = findNetworkNodeStrength(A);
    else %strcmp(feature,'clustering')
        Gdata = weightedClustCoeff(A);
    end
    
    [R,P] = corrcoef(Gdata, STRdata);
    rvals(overallIndex+1,1) = R(1,2);
    pvals(overallIndex+1,1) = P(1,2);
end



