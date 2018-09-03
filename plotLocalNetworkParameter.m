%%---------------------- plotLocalNetworkParameter ---------------------
% Avik Mondal
% 
% Aim:
% - a function that takes as inputs Nodes and Links (from Skel2Graph) and
%   plots them as a graph. Based on the network coefficient specified,
%   nodes are colored in a specific way
%
% Parameters:
% array skel - the binarized skeleton VOI
% struct nodes - the nodes of a binarized skeleton VOI
% struct links - the links of a binarized skeleton VOI
% string parameter - the chosen parameter that determines node color scheme 
%--------------------------------------------------------------------------

function plotLocalNetworkParameter(skel,node2,link2,parameter)

addpath('C:\Users\Avik Mondal\Documents\Carlson Lab\Bone Project MATLAB code\phi-max-skel2graph3d-matlab-8939088');
addpath('C:\Users\Avik Mondal\Documents\Carlson Lab\Bone Project MATLAB code\TinyAxis');
%specific to Avik's computer only
w = size(skel,1);
l = size(skel,2);
h = size(skel,3);

c = parula(100);
%the color map for my plot
f = figure();
hold on;
for i=1:length(node2)
if(length(node2(i).links) > 2)
    
    x1 = node2(i).comx;
    y1 = node2(i).comy;
    z1 = node2(i).comz;
    
    %{
    if(node2(i).ep==1)
        ncol = 'c';
    else
        ncol = 'y';
    end
    %}
    if strcmp(parameter,"clustering") 
       colorbar;
       markerCol = round( 99*node2(i).clusteringC + 1 ); 
       %disp(markerCol);
       %clustering affects the marker color
       %colors have 64 possibilities determined by parula colormap
    %elseif strcmp(parameter,"closeness")
        cvec(1,1) = c(markerCol,1);
        cvec(1,2) = c(markerCol,2);
        cvec(1,3) = c(markerCol,3);
        title('Local Clustering');
    elseif strcmp(parameter,"degree")
        colorbar;
        markerCol = round(99*node2(i).degreeC + 1 );
        cvec(1,1) = c(markerCol,1);
        cvec(1,2) = c(markerCol,2);
        cvec(1,3) = c(markerCol,3);
        title('Local Degree Centrality');
    elseif strcmp(parameter,"closeness")
        colorbar;
        markerCol = round(99*node2(i).closeness + 1);
        cvec(1,1) = c(markerCol,1);
        cvec(1,2) = c(markerCol,2);
        cvec(1,3) = c(markerCol,3);
        title('Local Closeness Centrality');
    elseif strcmp(parameter,"node strength")
        colorbar;
        markerCol = round(99*node2(i).strength + 1);
        cvec(1,1) = c(markerCol,1);
        cvec(1,2) = c(markerCol,2);
        cvec(1,3) = c(markerCol,3);
        title('Local Node Strength');
    elseif strcmp(parameter,"weighted clustering")
        colorbar;
        markerCol = round(99*node2(i).weightedCC + 1);
        cvec(1,1) = c(markerCol,1);
        cvec(1,2) = c(markerCol,2);
        cvec(1,3) = c(markerCol,3);
        title('Local Weighted Clustering');
    elseif strcmp(parameter,"betweenness")
        colorbar;
        markerCol = round(99*node2(i).betweenness + 1);
        cvec(1,1) = c(markerCol,1);
        cvec(1,2) = c(markerCol,2);
        cvec(1,3) = c(markerCol,3);
        title('Local Betweenness Centrality');
       elseif strcmp(parameter,"eigenvector")
        colorbar;
        markerCol = round(99*node2(i).eigenvector + 1);
        cvec(1,1) = c(markerCol,1);
        cvec(1,2) = c(markerCol,2);
        cvec(1,3) = c(markerCol,3);
        title('Local Eigenvector Centrality'); 
    elseif strcmp(parameter,"nndegree")
        colorbar;
        markerCol = round(99*node2(i).nearestNeighborDegree+ 1);
        cvec(1,1) = c(markerCol,1);
        cvec(1,2) = c(markerCol,2);
        cvec(1,3) = c(markerCol,3);
        title('Local Nearest Neighbor Degree');
    elseif strcmp(parameter,"subgraphs")
        if ( isfield(node2,'subGraph') )
            spectrum = [node2.subGraph]; %scaling the colors based on number of subgraphs
            graphNum = max(spectrum);
            %multiplier = 100 / graphNum;
            c = parula(graphNum);
            markerCol = round(node2(i).subGraph);
            cvec(1,1) = c(markerCol,1);
            cvec(1,2) = c(markerCol,2);
            cvec(1,3) = c(markerCol,3);
            title('Weighted Network Subgraphs');
        else
            
            cvec = [1 1 0];
            title('Weighted Trabecular Network');
        end 
    else    
        cvec = [1 1 0];
        title('Weighted Trabecular Network');
    end
    %IT COULD BE INFORMATIVE TO PLOT HUBS
    
    
    
    
    for j=1:length(node2(i).links)    % draw all connections of each node
        if(node2(link2(node2(i).links(j)).n2).ep==1)
            col='k'; % branches are blue
        else
            col='k'; % links are red
        end
        if(node2(link2(i).n1).ep==1)
            col='k';
        end

        lineWidth = 1;
        if isfield(link2,'avgthickness')
            lineWidth = 6*( link2( node2(i).links(j)).avgthickness ) / (link2(1).maxthickness);
        end
        % draw edges as lines using voxel positions
        for k=1:length(link2(node2(i).links(j)).point)-1            
            [x3,y3,z3]=ind2sub([w,l,h],link2(node2(i).links(j)).point(k));
            [x2,y2,z2]=ind2sub([w,l,h],link2(node2(i).links(j)).point(k+1));
            line([y3 y2],[x3 x2],[z3 z2],'Color',col,'LineWidth',lineWidth);
        end
    end
    
    % draw all nodes as yellow or blue circles
    
    plot3(y1,x1,z1,'o','Markersize',9,...
        'MarkerFaceColor',cvec,...
        'Color','k');
    
  
    if (isfield(node2,'degreeC'))
        if (node2(i).degreeC == 2)
            text(y1,x1,z1,['  ' num2str(i)],'FontSize',9,'Color','red');
        end 
    end    
end
end
%h = axes('Parent',f);

axis image;

axis off;

set(gcf,'Color','white');
drawnow;    

view(-59,52);
tinyaxis(gca,'r','g','b');
%colorbar;
