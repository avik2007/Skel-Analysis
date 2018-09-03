%% ---------------------- loadColoredImageSequence -------------------------------
% Avik Mondal
% 
% Aim:
% - a function that more efficiently allows me to load in my image files
% (rather than making a new load images script every time I need to do it).
%
% Parameters:
% string folder - folder containing the files you plan to read in
% string prefix - string containing the beginning of the file you are
%              trying to open (sans the numbering)
% int firstIndex - the "number" of the first file in your sequence
% string filetype - the filetype of your file
% int x0 - the x-coordinate of the point at which you begin reading in
%              your image
% int y0 - the y-coordinate of the point at which you begin reading in your
%              image
% int xdim,ydim,zdim - the dimensions of the matrix the function will generate
%--------------------------------------------------------------------------
function immat = loadColoredImageSequence(folder, prefix ,firstIndex, filetype,x0,y0,xdim,ydim,zdim)    

addpath('C:\Users\avik2\Documents\Carlson Lab\Bone Project MATLAB code');
imagefiles = dir(char(strcat(folder,"*.", filetype)));
%nfiles = size(imagefiles,1);
formattedFirstIndex = sprintf('%04.0f', firstIndex);
%sampleimage = imread(char(strcat(folder, prefix,formattedFirstIndex,".", filetype)));



filename = strcat(folder,prefix);
%startingIndex = 80;
filetypeSuffix = strcat(".",filetype);
%sample = strcat(filename, int2str(200), filetype);

%imageMatrix = [];
immat = zeros(ydim,xdim, 0);
for i = firstIndex:firstIndex+zdim-1
    formattedIndex = sprintf('%04.0f',i);
    %disp(formattedIndex);
    path_to_slice = char(strcat(filename, formattedIndex, filetypeSuffix));
    newSlice = imread(path_to_slice);
    immat = cat(3,immat, newSlice(y0:y0+ydim-1, x0:x0+xdim-1));
end   