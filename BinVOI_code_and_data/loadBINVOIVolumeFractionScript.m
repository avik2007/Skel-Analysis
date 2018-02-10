fileFolder = 'C:\Users\Avik\Documents\Carlson Lab\Bone Project Data\Bin_Data\bin_VOIs\';
xlsFile = 'vf_Results_bin_voi.csv';

xlsData = xlsread(horzcat(fileFolder,xlsFile));
binVOIVolumeFractions = xlsData(:,5);
save BinVoiVolumeFractions.mat binVOIVolumeFractions