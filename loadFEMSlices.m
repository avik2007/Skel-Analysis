function immat = loadFEMSlices(folder, firstIndex)
filetype = "bmp";
addpath('C:\Users\avik2\Documents\Carlson Lab\Bone Project MATLAB code');
imagefiles = dir(char(strcat(folder,"*.", filetype)));
%nfiles = size(imagefiles,1);

%sampleimage = imread(char(strcat(folder, prefix,formattedFirstIndex,".", filetype)));



%filename = strcat(folder,"haha"); %for black and white slicers images
filename = strcat(folder,"slicers_cropped_Tb"); %for thickness slicers images
%startingIndex = 80;
filetypeSuffix = strcat(".",filetype);
%sample = strcat(filename, int2str(200), filetype);

%imageMatrix = [];
immat = zeros(696,686, 0);
for i = firstIndex:200
    %formattedIndex = string(i); %for black and white images
    formattedIndex = sprintf('%03.0f',i); %for thickness images
    path_to_slice = char(strcat(filename, formattedIndex, filetypeSuffix));
    %disp(path_to_slice);
    newSlice = imread(path_to_slice);
    immat = cat(3,immat, newSlice(1:696, 1:686));
end   
 
