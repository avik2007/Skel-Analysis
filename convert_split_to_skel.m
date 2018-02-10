%
%Beginning of Chantal's inp file generator + code to turn her link/nodemat 
%into structs for skeleton analysis as well
res = 0.037; % resolution (mm)
%res = 1.0; %I'm converting resolution to 1 because I don't need to change it for the input file

nodet = struct2table(node);
linkt = struct2table(link);
nodemat = [(1:height(nodet))', res*nodet.com x, res*nodet.comy, res*nodet.comz];
nodemat = sortrows(nodemat,4);
nodemat = [(1:length(nodemat))',nodemat];

maxthicknesses = cellfun(@max,linkt.thicknesses);
% sort tables and remap nodes
linkmat = [(1:height(linkt))',linkt.n1,linkt.n2];
linkmat = double(linkmat);
linkmat = [linkmat,res*linkt.avgthickness,res*maxthicknesses];

map = containers.Map(nodemat(:,2)',nodemat(:,1)');
startNodes = arrayfun(@(x) map(x), linkmat(:,2));
endNodes = arrayfun(@(x) map(x), linkmat(:,3));
linkmat(:,2:3) = [startNodes endNodes];
nodemat(:,2) = [];

% cut everything above 2.7 and below 0.1
toppt = 2.7;
bottompt = 0.1;
topNode = find(nodemat(:,4) <= toppt, 1,'last');
topLinks = find((linkmat(:,2) <= topNode & linkmat(:,3) >= topNode) | (linkmat(:,2) >= topNode & linkmat(:,3) <= topNode));
bottomNode = find(nodemat(:,4) >= bottompt, 1,'first');
bottomLinks = find((linkmat(:,2) <= bottomNode & linkmat(:,3) >= bottomNode) | (linkmat(:,2) >= bottomNode & linkmat(:,3) <= bottomNode));
newLinks = linkmat((linkmat(:,2) <= topNode & linkmat(:,2) >= bottomNode) & (linkmat(:,3) <= topNode & linkmat(:,3) >= bottomNode),:);
newNodes = nodemat(unique(reshape(newLinks(:,2:3),2*length(newLinks),1)),:);

extraNodes = [linkmat(topLinks,2) linkmat(topLinks,3)];
extraNodes = reshape(extraNodes, 2*length(extraNodes),1);
extraNodes(ismember(extraNodes,newNodes(:,1))) = [];
extraNodes = unique(extraNodes);
extraNodes = nodemat(extraNodes,:);
extraNodes(:,4) = toppt;
newNodes = vertcat(newNodes,extraNodes);

extraNodes = [linkmat(bottomLinks,2) linkmat(bottomLinks,3)];
extraNodes = reshape(extraNodes, 2*length(extraNodes),1);
extraNodes(ismember(extraNodes,newNodes(:,1))) = [];
extraNodes = unique(extraNodes);
extraNodes = nodemat(extraNodes,:);
extraNodes(:,4) = bottompt;
newNodes = vertcat(newNodes,extraNodes);

newLinks = vertcat(newLinks, linkmat(topLinks,:), linkmat(bottomLinks,:));
newNodes = sortrows(newNodes,4);
newNodes = [(1:length(newNodes))',newNodes];

map = containers.Map(newNodes(:,2)',newNodes(:,1)');

startNodes = arrayfun(@(x) map(x), newLinks(:,2));
endNodes = arrayfun(@(x) map(x), newLinks(:,3));
newLinks(:,2:3) = [startNodes endNodes];
newNodes(:,2) = [];
newLinks = sortrows(newLinks,2);
newLinks(:,1) = (1:length(newLinks))';

nodemat = [ newNodes zeros(length(newNodes),1)];
linkmat = newLinks;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% convert truncated network into a struct skeleton (what I'm used to
% handling)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
node_trunc = struct([]);
for index = 1:length(nodemat)
    node_trunc(index).comx = nodemat(index,2)/res;
    node_trunc(index).comy = nodemat(index,3)/res;
    node_trunc(index).comz = nodemat(index,4)/res;
    node_trunc(index).conn = [];
    node_trunc(index).links = [];
end

link_trunc = struct([]);
for index = 1:length(linkmat)
    link_trunc(index).n1 = linkmat(index,2);
    link_trunc(index).n2 = linkmat(index,3);
    link_trunc(index).avgthickness = linkmat(index,4)/res;
end
clear index;



%clearvars -except nodemat linkmat linkt nodet res

% %% splitting into 3
% splitnum = 3;
% maxthicknesses = [linkmat(:,5),linkmat(:,4)*1.5];
% linkmat = linkmat(:,1:4);
% newlinks = zeros(3*length(linkmat),size(linkmat,2));
% 
% for i = 1:length(linkmat)
%     linkvec = nodemat(linkmat(i,3),2:4) - nodemat(linkmat(i,2),2:4);
% %     maxthickness = min([linkmat(i,5),linkmat(i,4)*1.5]);%cellfun(@max,linkt.thicknesses(i));
%     maxthickness = min(maxthicknesses(i,:));
%     meanthickness = linkmat(i,4);%linkt.avgthickness(i);
% %     minthickness = cellfun(@min,linkt.thicknesses(i));
%     nodemat = [nodemat; length(nodemat)+1, nodemat(linkmat(i,2),2:4)+linkvec/3];
%     nodemat = [nodemat; length(nodemat)+1, nodemat(linkmat(i,3),2:4)-linkvec/3];
%     newlinks((3*(i-1)+1):(3*i),:) = horzcat(((3*(i-1)+1):(3*i))',[linkmat(i,2);length(nodemat)-1;length(nodemat)],...
%         [length(nodemat)-1;length(nodemat);linkmat(i,3)],[maxthickness;meanthickness;maxthickness]);
% end
% linkmat = vertcat(linkmat,newlinks);
% 
% nodemat = sortrows(nodemat,4);
% nodemat = [(1:length(nodemat))',nodemat];
% 
% map = containers.Map(nodemat(:,2)',nodemat(:,1)');
% startNodes = arrayfun(@(x) map(x), linkmat(:,2));
% endNodes = arrayfun(@(x) map(x), linkmat(:,3));
% linkmat(:,2:3) = [startNodes endNodes];
% nodemat(:,2) = [];
% linkmat(:,1) = (1:length(linkmat))';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%split into 9
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
splitnum = 9;
maxthicknesses = [linkmat(:,5)*1.2,linkmat(:,4)*1.25];
linkmat = linkmat(:,1:4);
newlinks = zeros(9*length(linkmat),size(linkmat,2));

for i = 1:length(linkmat)
    linkvec = nodemat(linkmat(i,3),2:4) - nodemat(linkmat(i,2),2:4);
    % maxthickness = min([linkmat(i,5),linkmat(i,4)*1.5]);%cellfun(@max,linkt.thicknesses(i));
    %preveding line is irrelevant
    maxthickness = min(maxthicknesses(i,:));
    meanthickness = linkmat(i,4);%linkt.avgthickness(i);
     minthickness = cellfun(@min,linkt.thicknesses(i));
    nodemat = [nodemat; length(nodemat)+1, nodemat(linkmat(i,2),2:4)+linkvec/9, i];
    nodemat = [nodemat; length(nodemat)+1, nodemat(linkmat(i,2),2:4)+2*linkvec/9, i];
    nodemat = [nodemat; length(nodemat)+1, nodemat(linkmat(i,2),2:4)+linkvec/3, i];
    nodemat = [nodemat; length(nodemat)+1, nodemat(linkmat(i,2),2:4)+4*linkvec/9, i];
    nodemat = [nodemat; length(nodemat)+1, nodemat(linkmat(i,2),2:4)+5*linkvec/9, i];
    nodemat = [nodemat; length(nodemat)+1, nodemat(linkmat(i,3),2:4)-linkvec/3, i];
    nodemat = [nodemat; length(nodemat)+1, nodemat(linkmat(i,3),2:4)-2*linkvec/9, i];
    nodemat = [nodemat; length(nodemat)+1, nodemat(linkmat(i,3),2:4)-linkvec/9, i];
    
    newlinks((9*(i-1)+1):(9*i),:) = horzcat(((9*(i-1)+1):(9*i))',[linkmat(i,2);((length(nodemat)-7):length(nodemat))'],...
        [((length(nodemat)-7):length(nodemat))';linkmat(i,3)],...
        [linspace(maxthickness,meanthickness,4)';meanthickness;linspace(meanthickness,maxthickness,4)']);
end
linkmat = newlinks;%vertcat(linkmat,newlinks); %this commented out portion leads to redundancies

%nodemat = sortrows(nodemat,4);
nodemat = [(1:length(nodemat))',nodemat];

%map = containers.Map(nodemat(:,2)',nodemat(:,1)');
%startNodes = arrayfun(@(x) map(x), linkmat(:,2));
%endNodes = arrayfun(@(x) map(x), linkmat(:,3));
%linkmat(:,2:3) = [startNodes endNodes];
nodemat(:,2) = [];
linkmat(:,1) = (1:length(linkmat))';


bottomNodes = find(nodemat(:,4) <= (min(nodemat(:,4))+0.1));
topNodes = find(nodemat(:,4) >= (max(nodemat(:,4))));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%split into 12
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
splitnum = 12;
 maxthicknesses = [linkmat(:,5)*1.2,linkmat(:,4)*1.5];
linkmat = linkmat(:,1:4);
 newlinks = zeros(12*length(linkmat),size(linkmat,2));

 for i = 1:length(linkmat)
     linkvec = nodemat(linkmat(i,3),2:4) - nodemat(linkmat(i,2),2:4);
     %maxthickness = min([linkmat(i,4),linkmat(i,4)*1.5]);%cellfun(@max,linkt.thicknesses(i)); 
     %PREVIOUS LINE IS OVERRUNN BY PRECEDING LINE (COULD DELETE IF YOU
     %WANT)
     maxthickness = min(maxthicknesses(i,:));
     meanthickness = linkmat(i,4);%linkt.avgthickness(i);
     minthickness = cellfun(@min,linkt.thicknesses(i));
     nodemat = [nodemat; length(nodemat)+1, nodemat(linkmat(i,2),2:4)+linkvec/12];
     nodemat = [nodemat; length(nodemat)+1, nodemat(linkmat(i,2),2:4)+linkvec/6];
     nodemat = [nodemat; length(nodemat)+1, nodemat(linkmat(i,2),2:4)+linkvec/4];
     nodemat = [nodemat; length(nodemat)+1, nodemat(linkmat(i,2),2:4)+linkvec/3];
     nodemat = [nodemat; length(nodemat)+1, nodemat(linkmat(i,2),2:4)+5*linkvec/12];
     nodemat = [nodemat; length(nodemat)+1, nodemat(linkmat(i,2),2:4)+linkvec/2];
     nodemat = [nodemat; length(nodemat)+1, nodemat(linkmat(i,3),2:4)-5*linkvec/12];    
     nodemat = [nodemat; length(nodemat)+1, nodemat(linkmat(i,3),2:4)-linkvec/4];
     nodemat = [nodemat; length(nodemat)+1, nodemat(linkmat(i,3),2:4)-linkvec/3];
     nodemat = [nodemat; length(nodemat)+1, nodemat(linkmat(i,3),2:4)-linkvec/6];
     nodemat = [nodemat; length(nodemat)+1, nodemat(linkmat(i,2),2:4)-linkvec/12];
     newlinks((12*(i-1)+1):(12*i),:) = horzcat(((12*(i-1)+1):(12*i))',[linkmat(i,2);((length(nodemat)-10):length(nodemat))'],...
         [((length(nodemat)-10):length(nodemat))';linkmat(i,3)],...
         [linspace(maxthickness,meanthickness,6)';linspace(meanthickness,maxthickness,6)']);
 end
 linkmat = newlinks ;%vertcat(linkmat,newlinks); %this commented out portion creates redundancies in linkmat
 
 nodemat = sortrows(nodemat,4);
 nodemat = [(1:length(nodemat))',nodemat];
 
 map = containers.Map(nodemat(:,2)',nodemat(:,1)');
 startNodes = arrayfun(@(x) map(x), linkmat(:,2));
 endNodes = arrayfun(@(x) map(x), linkmat(:,3));
 linkmat(:,2:3) = [startNodes endNodes];
 nodemat(:,2) = [];
 linkmat(:,1) = (1:length(linkmat))';
 
 bottomNodes = find(nodemat(:,4) <= (min(nodemat(:,4))+0.1));
 topNodes = find(nodemat(:,4) >= (max(nodemat(:,4))));
 %}
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % converting back to a skeleton
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
link_split = struct([]);
for index = 1:length(linkmat)
    link_split(index).n1 = linkmat(index,2);
    link_split(index).n2 = linkmat(index,3);
    link_split(index).avgthickness = linkmat(index,4);
end

clear index;
for index = 1:length(link_trunc)
    node1 = link_trunc(index).n1;
    node2 = link_trunc(index).n2;
    node_trunc(node1).conn(1,length(node_trunc(node1).conn)+1) = node2;
    node_trunc(node2).conn(1,length(node_trunc(node2).conn)+1) = node1;
    node_trunc(node1).links(1,length(node_trunc(node1).links)+1) = index;
    node_trunc(node2).links(1,length(node_trunc(node2).links)+1) = index; 
end
clear index;
for index = 1:length(node_trunc)
    node_trunc(index).ep = ~( length(node_trunc(index).links) > 1 );
end

%{
node_split = struct([]);
for index = 1:length(node_trunc)
    node_split(index).comx = nodemat(index,2);
    node_split(index).comy = nodemat(index,3);
    node_split(index).comz = nodemat(index,4);
    node_split(index).originallink = nodemat(index,5);
end
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Adding conns and links to nodes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load in the data - here we can include information about stresses
% 1/29/2018 - for now, i'm just going to take the final timestep and
% calculate max thicknesses and such
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
Weighted average of thicknesses becomes the link's stress (by area
fraction) %how does this work? get equation from Ahmed
%}
load('workspace_split9_new_VOI_701x101y_stresses_data.mat')
final_stresses = stress_data(:,26);

for index1 = 0:length(link_trunc)-1
    weight = 0; 
    for index2 = 1:splitnum 
        combIndex = index1*splitnum + index2;
        if (final_stresses(combIndex,1) > weight)
            weight = final_stresses(combIndex, 1);
        end
    end
    link_trunc(index1+1).finalStress = weight;
end

%% Processing all the stress data as above (making a proper time series)
%this stress time series data will go into a video
%additionally, this compresses all the abaqus link data to the graph link
%data
%load('workspace_split9_new_VOI_701x101y_stresses_data.mat');

link_stress_time = zeros(length(link_trunc), size(stress_data,2));
for timestep = 1:size(stress_data,2)
    combIndex = 0;
    disp(combIndex);
    for index1 = 0:length(link_trunc)-1
        maxStress = 0;
        disp(maxStress);
        for index2 = 1:splitnum
            combIndex = index1*splitnum+index2;
            %disp(combIndex);
            if (stress_data(combIndex,timestep) > maxStress)
                maxStress = stress_data(combIndex,timestep);
            end
        end
        link_stress_time(index1+1,timestep) = maxStress;
    end
end