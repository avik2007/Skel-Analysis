
%% input files to generate and truncs to generate
%prefix = "graphVOI_";
%suffix = ["001x101y", "001x201y", "001x301y", "101x001y", "101x101y", "101x201y" ...
%    ,"101x301y", "201x201y","301x301y","701x001y", "701x101y","701x201y","701x301y","801x001y" ...
%    ,"801x101y", "801x201y","801x301y", "901x001y","901x101y","901x201y","901x301y"];
prefix = "graph_2by2_";
suffix = ["1","2","3","4","7","8","9","10"];
for index = 1: length(suffix)
    voiname = strcat(prefix, suffix(index));
    generateInpTruncBulk(char(voiname));
    clearvars -except prefix suffix index ;
end

%% code to remake tilemaps for trab spacing 

cd('C:\Users\Avik Mondal\Documents\Carlson Lab\Bone Project Data\Bin_Data\bin_VOIs');
addpath('C:\Users\Avik Mondal\Documents\Carlson Lab\Bone Project MATLAB code');
suffix = ["001x001y","001x101y", "001x201y", "001x301y", "101x001y", "101x101y", "101x201y" ...
    ,"101x301y", "201x001y","201x101y", "201x201y","201x301y","301x001y","301x101y", "301x201y" ...
    ,"301x301y","701x001y", "701x101y","701x201y","701x301y","801x001y" ...
    ,"801x101y", "801x201y","801x301y", "901x001y","901x101y","901x201y","901x301y"];
prefix = "dual_thick_VOI_";
trab_spacing_means = zeros(40,1);

for i = 1:length(suffix)
    voi_name = strcat(cd, "\",prefix, suffix(i));
    load(voi_name, 'dlink');
    trab_spacing_means(i,1) = mean([dlink.avgthickness]);
    clearvars -except trab_spacing_means suffix prefix
end


