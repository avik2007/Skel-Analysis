% ------ GEL DROP SURFACE BOUNDARY DETECTION v3.0 ------
% Avik Mondal
% last edited: 10/25/2016
% Aim:
% - find the surface of my gel beads
% CORRECTIONS From original and 2.0
% - get rid of thresholding
% - find centroid differently
% - use unit vectors to shoot rays
% - interpolate in 3Dimensions instead of parameterizing with one


%imagename1 = '/home/avik/Matlab/projects/pt43umzstepsgel2-1.tif';
imagename1 = '/home/avik/Matlab/projects/gray_scale_rhodamine_without_beads.tif';
%imagename2 = '/home/avik/Matlab/projects/pt43umzsteps-1.tif';

%current_image = imagename1;
originalimageinfo1 = imfinfo(imagename1);
%originalimageinfo2 = imfinfo(imagename2);
%originalimageinfo1 = imfinfo(current_image);

temp_image1 = imread(imagename1);


[ylength1, xlength1] = size(temp_image1);


num_images1 = numel(originalimageinfo1);

originalimage3D = zeros(ylength1, xlength1 );



for tifindex = 1:num_images1
    A = imread(imagename1, tifindex);
    originalimage3D = cat(3, originalimage3D, A);
end

% set num_images1 = zlength1 to keep consistent notation
%the original zlength1 = 1, because that what was read in by imread
% I add one because the first layer of originaliamge3D is the array of 0's
% generated in the lines before the for loop
zlength1 = num_images1;

clear tifindex num_images1 temp_image1 originalimageinfo1 originalimageinfo2




%brightenedimage3D = originalimage3D*100;
%imshow(brightenedimage3D[:,:,40]); % testing

%convert to double image for processing
bwimage = double(originalimage3D);

clear originalimage3D

 

%New indices. I will only loop through these indices in the matrix
yStart = 1;
yEnd = ylength1;
xStart = 1;
xEnd = xlength1;
zStart = 1;
zEnd = zlength1;

 
%*************************************************************************
% Finding the Centroid
%*************************************************************************

%I'm going to find the center of masses of the middle half slices of the 
%tif image. These should allow me to avoid the error prone tops and bottoms
%of the image which can appear brighter due to the objective. 

firstSlice = floor(zEnd/4) ;
lastSlice = floor(3*zEnd/4);
sliceCOM = zeros(lastSlice-firstSlice, 3);

%stores the center of masses for the center slices, the first column holds 
%y coordinates and the second holds x coordinates
mass = 0;
massy = 0; %mass moment about the y-axis
massx = 0; %mass moment about the x-axis
for indexz= firstSlice:lastSlice
    for indexy = yStart:yEnd
        for indexx = xStart:xEnd
            mass = mass + bwimage(indexy, indexx, indexz);
            massy = massy + bwimage(indexy, indexx, indexz)*indexx;
            massx = massx + bwimage(indexy, indexx, indexz)*indexy;
        end
    end
    sliceCOM(indexz - firstSlice + 1, 1) = massx/mass;
    sliceCOM(indexz - firstSlice + 1, 2) = massy/mass;
    sliceCOM(indexz - firstSlice + 1, 3) = indexz;
end

centroid = mean(sliceCOM);
centroid_nna = round(centroid); %near neigbor approximation

%Converting final image from pixels to distances
NA = 1/4; %numerical aperture of the 60x objective in confocal fluoview 1000
n1 = 1.33; % refractive index of water
n2 = 1.518; % refractive index of imaging oil
z_stretch = tan(asin(NA/n1))/tan(asin(NA/n2));
z_pxl2dist = 0.43; %0.43 um/pxl conversion in z-direction
z_scale_factor = z_stretch*z_pxl2dist;
xy_scale_factor = 0.102; % 0.102 um/pxl conversion in xy-direction

centroid_distance(1) = centroid(1)*xy_scale_factor;
centroid_distance(2) = centroid(2)*xy_scale_factor;
centroid_distance(3) = centroid(3)*z_scale_factor;

unitVectors_X = nodesSurface(:,1);
unitVectors_Y = nodesSurface(:,2);
unitVectors_Z = nodesSurface(:,3);

%num = 2; %Eventually, this will be my loop variable

xa = xStart:xEnd; ya = yStart:yEnd; 
za = zStart:zEnd+1;% Note to self, figure out why ZEnd registers as 65 and not 66
[xam, yam, zam] = meshgrid(xa, ya, za);


%Np = 100; %Number of points to evaluate

R = 200; %Radius in terms of number of xy pixels that I want to shoot for

xy2zDistConversion = xy_scale_factor/z_scale_factor;

% num can be found in GelOutlineDetectionv3RUN.m


Xe = linspace(centroid_nna(1), centroid_nna(1)+R*unitVectors_X(num), Np);
Ye = linspace(centroid_nna(2), centroid_nna(2)+R*unitVectors_Y(num), Np);
Ze = linspace(centroid_nna(3), centroid_nna(3)+R*unitVectors_Z(num)*xy2zDistConversion, Np);
% arrays containing the coordiantes of the ray to be shot

Xum = Xe*xy_scale_factor; Yum = Ye*xy_scale_factor; Zum = Ze*z_scale_factor;
%the defined ray, just in um not units
Xaum = xam *xy_scale_factor; Yaum = yam*xy_scale_factor; Zaum = zam*z_scale_factor;
%meshgrid in distance units

paramLength(:, num) = sqrt((Xum-centroid_distance(1)).^2+(Yum-centroid_distance(2)).^2+(Zum-centroid_distance(3)).^2);
interpa = interp3(Xaum, Yaum, Zaum, bwimage, Xum, Yum, Zum, 'cubic');
%Running this with 'spline' causes memory issues

%smoothed_interpa = csaps(paramLength, interpa); %Smoothing attempt with ppforms

theta = num2str( acosd(unitVectors_Z(num)/ sqrt( (unitVectors_X(num))^2+(unitVectors_Y(num))^2 + (unitVectors_Z(num))^2) ) );
phi = num2str( atan2(unitVectors_Y(num),unitVectors_Z(num))*180/pi );
words = '3D Interp: ';
%label = strcat(words, vectorx,',', vectory,',', vectorz,')');
label = strcat(words,'\theta = ', theta, ', \phi = ', phi,',',')');
%figure(1);

smooth_interpa(:,num) = smooth(paramLength(:, num), interpa, smoothparam, 'rloess');


% plot(paramLength, interpa,'o');
% plot(paramLength, smooth_interpa(:,num),'-','Linewidth',2)
% title(label); %plot of interpolated data
%{
figure(2);
fnplt(paramLength, smoothed_interpa);
title('Smoothing Attempt');
%}