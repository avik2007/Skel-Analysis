%% ----------------- findLocalClosenessCentrality -------------------------
% Avik Mondal
% 
% Aim:
% - this function outputs the normalized local closeness centrality of a node
%
% Parameters:   
% 
% struct node - contains the nodes generated from converting skeletonBin to
%    a graph
% struct link - contains the links generated from converting skeletonBin to
%    a graph
% int16 i - index of the node for which the betweenness centrality is
%    calculated
% array skel - binary array of the skeleton VOI
%
%closeness centrality formulation: 
% https://toreopsahl.com/2010/03/20/closeness-centrality-in-networks-with-disconnected-components/
%~because my networks can be disconnected, I've used harmonic centrality
%--------------------------------------------------------------------------
function CCi = findLocalClosenessCentrality(geo,i)


normalizationConstant = length(geo)-1;
%dij = zeros(length(node)-1);
sum = 0;
for index = 1:length(geo)
    if ( index ~= i )
        sum = sum + 1/( geo(i,index) );
    end
end
%disp(normalizationConstant);
%disp(sum);
CCi = sum / normalizationConstant;

%normalized local closeness centrality formulated with the inverse of the
%harmonic mean of distances 
