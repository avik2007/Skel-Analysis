%AVIK MONDAL 8/4/2018

%NODE DEGREE
%NODE DEGREE
%THIS IS FOR SAMPLE VOI_101X101Y
%V11_degree = zeros(length(node), 1);
%for i = 1:length(node)
%    V11_degree(i,1) = length(node(i).links);  
%end
%THIS IS FOR SAMPLE VOI_501X001Y
%V50_degree = zeros(length(node),1);
%for i = 1:length(node)
%        V50_degree(i,1) = length(node(i).links); 
%end
%THIS IS FOR SAMPLE VOI_301X001Y
%V30_degree = zeros(length(node),1);
%for i = 1:length(node)
%    V30_degree(i,1) = length(node(i).links);
%end

load('C:\Users\Avik Mondal\Documents\Carlson Lab\Bone Project Data\Paper Multiscale Analysis Data\node_degree_workspace.mat');
h30 = histogram(V30_degree);
h30Values = h30.Values;
h50 = histogram(V50_degree);
h50Values = h50.Values;
h11 = histogram(V11_degree);
h11Values = h11.Values;
clear h30 h50 h11;
for i = 1:length(h30Values)
    h30Values(2,i) = i;
end
for j = 1:length(h50Values)
    h50Values(2,j) = j;
end
for k = 1:length(h11Values)
    h11Values(2,k) = k;
end 

%The following lines get rid of bins with zero nodes
h30Values = h30Values(:,find(h30Values(1,:)));
h50Values = h50Values(:,find(h50Values(1,:)));
h11Values = h11Values(:,find(h11Values(1,:)));

color_scheme = parula((max(meanKList) - min(meanKList))*1000);
h30color = color_scheme(1+round((meanKList(1,13) - min(meanKList))*1000),:);
h50color = color_scheme(1+round((meanKList(1,21)- min(meanKList))*1000),:);
h11color = color_scheme(-1+round((meanKList(1,6)- min(meanKList))*1000),:);
plot(h11Values(2,:), h11Values(1,:), 'Marker', 'o', 'Color', h11color, 'MarkerFaceColor', h11color, 'MarkerSize', 8 );
hold on
plot(h30Values(2,:), h30Values(1,:), 'Marker', 's', 'Color', h30color, 'MarkerFaceColor', h30color, 'MarkerSize', 12 );
plot(h50Values(2,:), h50Values(1,:), 'Marker', 'd', 'Color', h50color, 'MarkerFaceColor', h50color, 'MarkerSize', 10 );
hold off
grid on
box on;
ylabel('Number of nodes with degree $k$', 'FontSize', 14, 'Interpreter', 'latex');
xlabel('Degree $k$', 'FontSize', 14, 'Interpreter', 'latex');
l = legend('$\overline{k} = 2.868$', '$\overline{k} = 2.668$', '$\overline{k} = 2.459$');
set(l, 'Interpreter', 'latex', 'FontSize', 14');


%% Trabecular spacing 
%{
cd('C:\Users\Avik Mondal\Documents\Carlson Lab\Bone Project Data\Paper Multiscale Analysis Data\TbSp&Th Data');
load('TrabecularData.mat','tbspmeans');
color_scheme = parula((max(tbspmeans) - min(tbspmeans))*10000);
h10color = color_scheme(1+round((tbspmeans(5,1) -  min(tbspmeans))*10000),:);
h61color = color_scheme(1+round((tbspmeans(26,1) - min(tbspmeans))*10000),:);
h63color = color_scheme(round((tbspmeans(28,1) - min(tbspmeans))*10000 - 1),:);
load('v10_tbsp.txt');
load('v61_tbsp.txt');
load('v63_tbsp.txt');

plot( v10_tbsp(:,1),v10_tbsp(:,2), 'Marker', 's', 'Color', h10color, 'MarkerFaceColor', h10color, 'MarkerSize', 12 );
hold on
plot( v61_tbsp(:,1),v61_tbsp(:,2), 'Marker', 'd', 'Color', h61color, 'MarkerFaceColor', h61color, 'MarkerSize', 10 );
plot( v63_tbsp(:,1),v63_tbsp(:,2), 'Marker', 'o', 'Color', h63color, 'MarkerFaceColor', h63color, 'MarkerSize', 8 );
hold off
grid on
box on;
ylabel('Percent volume in range', 'FontSize', 14, 'Interpreter', 'latex');
xlabel('TbSp (pixels)', 'FontSize', 14, 'Interpreter', 'latex');
l = legend('$\overline{TbSp} = 13.450$', '$\overline{TbSp} = 23.850$', '$\overline{TbSp} = 31.633$');
set(l, 'Interpreter', 'latex', 'FontSize', 14');
 
%% trabecular thickness stuff

cd('C:\Users\Avik Mondal\Documents\Carlson Lab\Bone Project Data\Paper Multiscale Analysis Data\TbSp&Th Data');
load('TrabecularData.mat','tbthmeans');
color_scheme = parula((max(tbthmeans) - min(tbthmeans))*10000);
h00color = color_scheme(2+round((tbthmeans(1,1) -  min(tbthmeans))*10000),:);
h32color = color_scheme(1+round((tbthmeans(15,1) - min(tbthmeans))*10000),:);
h42color = color_scheme(round((tbthmeans(19,1) - min(tbthmeans))*10000 - 1),:);
load('v00_tbth.txt');
load('v32_tbth.txt');
load('v42_tbth.txt');

plot( v42_tbth(:,1),v42_tbth(:,2), 'Marker', 's', 'Color', h42color, 'MarkerFaceColor', h42color, 'MarkerSize', 12 );
hold on
plot( v00_tbth(:,1),v00_tbth(:,2), 'Marker', 'd', 'Color', h00color, 'MarkerFaceColor', h00color, 'MarkerSize', 10 );
plot( v32_tbth(:,1),v32_tbth(:,2), 'Marker', 'o', 'Color', h32color, 'MarkerFaceColor', h32color, 'MarkerSize', 8 );
hold off
grid on
box on;
ylabel('Percent volume in range', 'FontSize', 14, 'Interpreter', 'latex');
xlabel('TbTh (pixels)', 'FontSize', 14, 'Interpreter', 'latex');
l = legend('$\overline{TbTh} = 9.276$', '$\overline{TbTh} = 6.616$', '$\overline{TbTh} = 4.837$');
set(l, 'Interpreter', 'latex', 'FontSize', 14');
%}

%% weighted node degree stuff (recalculating it)
%{
strengthList = zeros(1,40);
cd('C:\Users\Avik Mondal\Documents\Carlson Lab\Bone Project Data\Bin_Data\bin_VOIs\');

addpath('C:\Users\Avik Mondal\Documents\Carlson Lab\Bone Project MATLAB code');
suffix = ["001x001y","001x101y", "001x201y", "001x301y", "101x001y", "101x101y", "101x201y" ...
    ,"101x301y", "201x001y","201x101y", "201x201y","201x301y","301x001y","301x101y", "301x201y" ...
    ,"301x301y","401x001y", "401x101y", "401x201y", "401x301y", "501x001y", "501x101y" ...
    ,"501x201y", "501x301y", "601x001y", "601x101y", "601x201y", "601x301y","701x001y", "701x101y","701x201y","701x301y","801x001y" ...
    ,"801x101y", "801x201y","801x301y", "901x001y","901x101y","901x201y","901x301y"];
prefix = "graphVOI_";

for i = 1:length(suffix)
    voi_name = strcat(cd, "\",prefix, suffix(i));
    load(voi_name);
    strengthList(1,i) = mean(findNetworkNodeStrength(node,link));
    clearvars -except strengthList suffix prefix i
end
%}
%% Now generating the weighted node degree multiSample histogram
%{
addpath('C:\Users\Avik Mondal\Documents\Carlson Lab\Bone Project MATLAB code');
load('C:\Users\Avik Mondal\Documents\Carlson Lab\Bone Project Data\VOI_bulk_graph_analysis\Bulk_Graph_Analysis_GLOBALGRAPHFEAUTURES\8_24_18_updated_nodeStrengthList_40VOIset.mat');
load('C:\Users\Avik Mondal\Documents\Carlson Lab\Bone Project Data\Bin_Data\bin_VOIs\graphVOI_001x001y.mat');
v00_weight = findNetworkNodeStrength(node,link);
clearvars -except v00_weight strengthList
load('C:\Users\Avik Mondal\Documents\Carlson Lab\Bone Project Data\Bin_Data\bin_VOIs\graphVOI_701x101y.mat');
v_weight = findNetworkNodeStrength(node,link);
clearvars -except v00_weight v71_weight strengthList
load('C:\Users\Avik Mondal\Documents\Carlson Lab\Bone Project Data\Bin_Data\bin_VOIs\graphVOI_501x101y.mat');
v51_weight = findNetworkNodeStrength(node,link);
clearvars -except v00_weight v71_weight v51_weight strengthList

h00 = histogram(v00_weight);
h00Values = h00.Values / length(h00.Data);
h00binMidpoints = h00.BinEdges(1:h00.NumBins) + h00.BinWidth / 2.0;
h71 = histogram(v71_weight);
h71Values = h71.Values / length(h71.Data);
h71binMidpoints = h71.BinEdges(1:h71.NumBins) + h71.BinWidth / 2.0;
h51 = histogram(v51_weight);
h51Values = h51.Values / length(h51.Data);
h51binMidpoints = h51.BinEdges(1:h51.NumBins) + h51.BinWidth / 2.0;

%threshold - if a value is less than this, no marker will show for it
threshold = 0.002;
%following code (6 lines remove zeros)

h00binMidpoints = h00binMidpoints(find(h00Values > threshold));
h00Values = h00Values(find(h00Values > threshold));
h71binMidpoints = h71binMidpoints(find(h71Values> threshold));
h71Values = h71Values(find(h71Values> threshold));
h51binMidpoints = h51binMidpoints(find(h51Values> threshold));
h51Values = h51Values(find(h51Values> threshold));

%sorting colors that match that of the tilemaps
color_scheme = parula((max(strengthList) - min(strengthList))*1000);
h00color = color_scheme(1+round((strengthList(1,1) - min(strengthList))*1000),:);
h71color = color_scheme(1+round((strengthList(1,30)- min(strengthList))*1000),:);
h51color = color_scheme(1+round((strengthList(1,22)- min(strengthList))*1000),:);
plot(h51binMidpoints, h51Values, 'Marker', 'o', 'Color', h51color, 'MarkerFaceColor', h51color, 'MarkerSize', 8 );
hold on
plot(h71binMidpoints, h71Values, 'Marker', 'd', 'Color', h71color, 'MarkerFaceColor', h71color, 'MarkerSize', 10 );
plot(h00binMidpoints, h00Values, 'Marker', 's', 'Color', h00color, 'MarkerFaceColor', h00color, 'MarkerSize', 12 );
hold off
grid on
box on;
ylabel('Fraction of nodes with WND', 'FontSize', 14, 'Interpreter', 'latex');
xlabel('Weighted Node Degree (WND)', 'FontSize', 14, 'Interpreter', 'latex');
l = legend('$\overline{WND} = 9.374$', '$\overline{WND} = 12.554$', '$\overline{WND} = 16.834$');
set(l, 'Interpreter', 'latex', 'FontSize', 14');
%}

%% Link orientation - calculating for binVOI 40 sample data set
%{
cd('C:\Users\Avik Mondal\Documents\Carlson Lab\Bone Project Data\Bin_Data\bin_VOIs\');

addpath('C:\Users\Avik Mondal\Documents\Carlson Lab\Bone Project MATLAB code');
suffix = ["001x001y","001x101y", "001x201y", "001x301y", "101x001y", "101x101y", "101x201y" ...
    ,"101x301y", "201x001y","201x101y", "201x201y","201x301y","301x001y","301x101y", "301x201y" ...
    ,"301x301y","401x001y", "401x101y", "401x201y", "401x301y", "501x001y", "501x101y" ...
    ,"501x201y", "501x301y", "601x001y", "601x101y", "601x201y", "601x301y","701x001y", "701x101y","701x201y","701x301y","801x001y" ...
    ,"801x101y", "801x201y","801x301y", "901x001y","901x101y","901x201y","901x301y"];
prefix = "graphVOI_";

for i = 1:length(suffix)
    voi_name = strcat(cd, "\",prefix, suffix(i));
    load(voi_name);
    linkWithDirection = findLinkDirection(node,link);
    vectorAvg = 0;
    for j = 1:length(linkWithDirection)
        vectorAvg = vectorAvg + abs(linkWithDirection(j).direction) / length(linkWithDirection);
    end
    zList(1,i) = vectorAvg(1,3);
    clearvars -except zList suffix prefix i
end
%}

%% calculating the histogram for z orientation

%{
load('C:\Users\Avik Mondal\Documents\Carlson Lab\Bone Project Data\Paper Multiscale Analysis Data\8_25_18_updated_zorientationList_40VOIset.mat');


h53 = histogram(orientation53);
h53Values = h53.Values %/ length(h53.Data);
h53binMidpoints = h53.BinEdges(1:h53.NumBins) + h53.BinWidth / 2.0;
h72 = histogram(orientation72);
h72Values = h72.Values %/ length(h72.Data);
h72binMidpoints = h72.BinEdges(1:h72.NumBins) + h72.BinWidth / 2.0;
h51 = histogram(orientation51);
h51Values = h51.Values %/ length(h51.Data);
h51binMidpoints = h51.BinEdges(1:h51.NumBins) + h51.BinWidth / 2.0;

color_scheme = parula((max(zList) - min(zList))*1000);
h53color = color_scheme(round((zList(1,24) - min(zList))*1000),:);
h72color = color_scheme(1+round((zList(1,31)- min(zList))*1000),:);
h51color = color_scheme(1+round((zList(1,22)- min(zList))*1000),:);

plot(h51binMidpoints, h51Values, 'Marker', 'o', 'Color', h51color, 'MarkerFaceColor', h51color, 'MarkerSize', 8 );
hold on
plot(h53binMidpoints, h53Values, 'Marker', 's', 'Color', h53color, 'MarkerFaceColor', h53color, 'MarkerSize', 12 );
plot(h72binMidpoints, h72Values, 'Marker', 'd', 'Color', h72color, 'MarkerFaceColor', h72color, 'MarkerSize', 10 );
hold off
grid on
box on;

ylabel('Number of Links with Z Orientation', 'FontSize', 14, 'Interpreter', 'latex');
xlabel('Z Orientation (Zo)', 'FontSize', 14, 'Interpreter', 'latex');
l = legend('$\overline{Zo} = 0.4503$', '$\overline{Zo} = 0.5047$', '$\overline{Zo} = 0.4805$');
set(l, 'Interpreter', 'latex', 'FontSize', 14');
%}
%% generating bin VOI tilemap for link length
cd('C:\Users\Avik Mondal\Documents\Carlson Lab\Bone Project Data\Bin_Data\bin_VOIs\');
lengthList = zeros(1,40);
addpath('C:\Users\Avik Mondal\Documents\Carlson Lab\Bone Project MATLAB code');
suffix = ["001x001y","001x101y", "001x201y", "001x301y", "101x001y", "101x101y", "101x201y" ...
    ,"101x301y", "201x001y","201x101y", "201x201y","201x301y","301x001y","301x101y", "301x201y" ...
    ,"301x301y","401x001y", "401x101y", "401x201y", "401x301y", "501x001y", "501x101y" ...
    ,"501x201y", "501x301y", "601x001y", "601x101y", "601x201y", "601x301y","701x001y", "701x101y","701x201y","701x301y","801x001y" ...
    ,"801x101y", "801x201y","801x301y", "901x001y","901x101y","901x201y","901x301y"];
prefix = "graphVOI_";

for i = 1:length(suffix)
    voi_name = strcat(cd, "\",prefix, suffix(i));
    load(voi_name);
    linkWithLength = findLinkLength(node,link, skel); %find length in pixels and convert to mm
    lengthList(1,i) = mean([linkWithLength.length])*0.037;
    clearvars -except lengthList suffix prefix i
end
%% calculating the histogram for link length

load('C:\Users\Avik Mondal\Documents\Carlson Lab\Bone Project Data\Paper Multiscale Analysis Data\8_25_18_lengthList_workspace_multiple_samples.mat');
length51 = length51*.037; %converts all this to mm
length72 = length72*.037;
length83 = length83*.037;

binwidth = 2*0.037;
h51 = histogram(length51, 'BinWidth', binwidth);
h51Values = h51.Values; %/ length(h53.Data);
h51binMidpoints = h51.BinEdges(1:h51.NumBins) + h51.BinWidth / 2.0;
h72 = histogram(length72, 'BinWidth', binwidth);
h72Values = h72.Values ;%/ length(h72.Data);
h72binMidpoints = h72.BinEdges(1:h72.NumBins) + h72.BinWidth / 2.0;
h83 = histogram(length83, 'BinWidth', binwidth);
h83Values = h83.Values; %/ length(h51.Data);
h83binMidpoints = h83.BinEdges(1:h83.NumBins) + h83.BinWidth / 2.0;

threshold = 0;
h51binMidpoints = h51binMidpoints(find(h51Values > threshold));
h51Values = h51Values(find(h51Values > threshold));
h72binMidpoints = h72binMidpoints(find(h72Values> threshold));
h72Values = h72Values(find(h72Values> threshold));
h83binMidpoints = h83binMidpoints(find(h83Values> threshold));
h83Values = h83Values(find(h83Values> threshold));

color_scheme = parula((max(lengthList) - min(lengthList))*1000);
h83color = color_scheme(round((lengthList(1,36) - min(lengthList))*1000),:);
h72color = color_scheme(1+round((lengthList(1,31)- min(lengthList))*1000),:);
h51color = color_scheme(1+round((lengthList(1,22)- min(lengthList))*1000),:);

plot(h83binMidpoints, h83Values, 'Marker', 'o', 'Color', h83color, 'MarkerFaceColor', h83color, 'MarkerSize', 8 );
hold on
plot(h72binMidpoints, h72Values, 'Marker', 'd', 'Color', h72color, 'MarkerFaceColor', h72color, 'MarkerSize', 10 );
plot(h51binMidpoints, h51Values, 'Marker', 's', 'Color', h51color, 'MarkerFaceColor', h51color, 'MarkerSize', 12 );
hold off
grid on
box on;

ylabel('Number of Links with Length L', 'FontSize', 14, 'Interpreter', 'latex');
xlabel('Link Length (L)', 'FontSize', 14, 'Interpreter', 'latex');
l = legend('$\overline{L} = 0.2749$ mm', '$\overline{L} = 0.2470$ mm', '$\overline{L} = 0.2300$ mm');
set(l, 'Interpreter', 'latex', 'FontSize', 14');