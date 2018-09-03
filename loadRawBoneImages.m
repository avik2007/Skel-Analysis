%% ------ loadRawBoneImages_esaOriginalDataset ------
% Avik Mondal
% first edited: 05/20/2016
% Aim:
% - loading bone images so that we can store them in MATLAB
%colormap(gray);
imagefiles = dir('C:\Users\Avik\Documents\Carlson Lab\Bone Project Data\ESA_resliced_cropped\ESA_axial_slices\VOI_axial_05_21_2017\axial_BMP_IMG\*.bmp');
nfiles = size(imagefiles,1);
A = imread('C:\Users\Avik\Documents\Carlson Lab\Bone Project Data\ESA_resliced_cropped\ESA_axial_slices\VOI_axial_05_21_2017\axial_BMP_IMG\ax_img__voi_05_21_170080.bmp');
[length,width] = size(A); %This length and width takes on the full image
%imshow(A)


filename = 'C:\Users\Avik\Documents\Carlson Lab\Bone Project Data\ESA_resliced_cropped\ESA_axial_slices\VOI_axial_05_21_2017\axial_BMP_IMG\ax_img__voi_05_21_17';
startingIndex = 80;
filetype = '.bmp';
%sample = strcat(filename, int2str(200), filetype);

imageMatrix = [];
skeletonBin = zeros(length,width, 0);
for i = 0:(nfiles-1)
    formattedIndex = sprintf('%04.0f', startingIndex+i);
    %disp(formattedIndex);
    path_to_slice = strcat(filename, formattedIndex, filetype);
    newSlice = imread(path_to_slice);
    skeletonBin = cat(3,skeletonBin, newSlice);
end   
