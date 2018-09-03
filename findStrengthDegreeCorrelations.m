%% --------------- findStrengthDegreeCorrelation -------------------------
% Avik Mondal
% 
% Aim:
% - this function aims to find node degree and strength correlations by 
% calculating average srength as a function of k and plotting it with
% respsect to k
%
% Parameters:   
% 
% struct node - contains the nodes generated from converting skeletonBin to
%    a graph
% 
% defined in The architeture of complex networks, (A. Barat et. al)
%--------------------------------------------------------------------------
function averages = findStrengthDegreeCorrelations(node,link)
nodeOne = 0;
index2 = 1;

nodeOne = find([node.degreeC] == 1);      
strengthOne = find([node.strength] == 1);
maxStrength = findNodeStrength(node,link,strengthOne);

maxDegree = length(node(nodeOne(1,1)).conn);
averages = zeros(1,maxDegree);

for index1 = 3:maxDegree
    X = find(abs([node.degreeC]-double(index1/maxDegree)) < 10^-3 );
    %I had to use a low precision to find all the necessary indexes
    for index4 = 1:length(X)
        averages(1,index1) = averages(1,index1) + ( node(X(index4)).strength / length(X) )*maxStrength;
    end
end    
figure;
scatter([3:maxDegree],averages(3:end),30,'MarkerEdgeColor',[0 .5 .5],...
              'MarkerFaceColor',[0 .7 .7],...
              'LineWidth',1.5);
axis([2 ( maxDegree + 0.5) 0 ( maxStrength+2 )]); 
title("Node Strength vs Node Degree");
xlabel("Node degree (k)");
ylabel("Average Node strength S(k)");

