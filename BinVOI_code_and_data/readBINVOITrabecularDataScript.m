fileFolder = 'C:\Users\Avik\Documents\Carlson Lab\Bone Project Data\Bin_Data\bin_VOIs\';
xlsFile = 'TrabecularResults_bin_voi.csv';

xlsData = xlsread(horzcat(fileFolder,xlsFile));
tbthmeans = xlsData(:,3);
tbthstds = xlsData(:,4);
tbthmaxes = xlsData(:,5);
tbspmeans = xlsData(:,6);
tbspstds = xlsData(:,7);
tbspmax = xlsData(:,8);

save TrabecularData.mat tbthmeans tbthstds tbthmaxes tbthstds tbspmeans tbspstds tbspmax;