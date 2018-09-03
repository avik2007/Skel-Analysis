%% ---------------------- loadImageSequence -------------------------------
% Avik Mondal
% 
% Aim:
% - a function that more efficiently allows me to load in my image files
% (rather than making a new load images script every time I need to do it).
% THIS FUNCTION IS BEST USED FOR THOSE WITH CTAN OR FIJI labeling
% conventions (4 digit indexing at the tail). FOR CHANTAL'S NAMING
% CONVENTION, GO TO loadBinVOISequence)
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
% int sigfigs - number of digits in the label
%--------------------------------------------------------------------------
function immat = loadImageSequence(folder, prefix ,firstIndex, filetype,x0,y0,xdim,ydim,zdim, sigfigs)    

%addpath('C:\Users\Avik Mondal\Documents\Carlson Lab\Bone Project MATLAB code');
imagefiles = dir(char(strcat(folder,"*.", filetype)));


filename = strcat(folder,prefix);
%startingIndex = 80;
filetypeSuffix = strcat(".",filetype);
%sample = strcat(filename, int2str(200), filetype);

%imageMatrix = [];
immat = logical(zeros(ydim,xdim, 0));
for i = firstIndex:firstIndex+zdim-1
    formattedIndex = sprintf(horzcat('%0',num2str(sigfigs),'.0f'),i);
    %fprintf(formattedIndex);
    path_to_slice = char(strcat(filename, formattedIndex, filetypeSuffix));
    newSlice = logical(imbinarize(imread(path_to_slice)));
    immat = cat(3,immat, newSlice(y0:y0+ydim-1, x0:x0+xdim-1));
end   


