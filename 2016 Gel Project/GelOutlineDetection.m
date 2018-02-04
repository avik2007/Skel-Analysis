% ------ GEL DROP SURFACE BOUNDARY DETECTION ------
% Avik Mondal
% last edited: 08/30/2016
% Aim:
% - find the surface of my gel beads

%clear all;
%clearvars;
%close all;
%clc;

%read in the image
imagename1 = '/home/avik/Matlab/projects/pt43umzstepsgel2-1.tif';
%imagename2 = '/home/avik/Matlab/projects/pt43umzsteps-1.tif';

%current_image = imagename1;
originalimageinfo1 = imfinfo(imagename1);
%originalimageinfo2 = imfinfo(imagename2);
%originalimageinfo1 = imfinfo(current_image);

temp_image1 = imread(imagename1);


[ylength1, xlength1, zlength1] = size(temp_image1);


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

%------determine a threshold - what counts as gel and what does not--------


% shoots a ray across the diagonal of a confocal slice of the image from 
% the origin to get intensity profile
%{
topintensityprofile = improfile(bwimage(:,:,3), [0 512], [0 512], 512*3, 'bicubic');
bottomintensityprofile = improfile(bwimage(:,:,63), [0 512], [0 512], 512*3, 'bicubic');
figure(1);
plot(topintensityprofile);
figure(2);
plot(bottomintensityprofile);
%}

%based on the above improfile, I'm setting the threshold value to 450
intensityThreshold = 400;


%--------------------------Removing Excess Points-------------------------
%Takes out layers of the image that have 0 as their voxel value

%I'm creating a clone of bwimage. I will use this clone to get rid of
%portions of bwimage that are outliers or are to dim to be relevant
%portiosn of the gel
bwimage_clone = zeros(ylength1, xlength1, zlength1);
for j=1:ylength1
   for  i=1:xlength1
       for k=1:zlength1
           if bwimage(j,i,k)>=intensityThreshold
               bwimage_clone(j,i,k) = bwimage(j,i,k);
               %setting all voxels less than the threshold to 0. Those
               %above it become 1
               %bwimage(j,i,k) = 1;
           %else
               %bwimage(j,i,k) = bwimage_clone(j,i,k);
           end 
       end    
   end    
end
 
xview = bwimage_clone(33,:,:);
%New indices. I will only loop through these indices in the matrix
yStart = 1;
yEnd = ylength1;
xStart = 1;
xEnd = xlength1;
zStart = 1;
zEnd = zlength1;

%NOTE: the following section gets rid of layers of the image 
%that have negligible intensity value outside the gel. 

%Here, I first examine slices of the image. If a full slice contains all
%zero-valued voxels, then I remove it. After, that, I look through the
%slices and compile the intensity values of the different voxels into 3
%bins. I look at the largest magnitude bin. If a slice has less than a
%certain number in that bin,I get rid of it. 

%I derived this value heuristically, so one may need to play with it before
%trying this with new images

layerthreshold = 10;

while any(any(bwimage_clone(yStart,:,:))) == 0
    yStart = yStart + 1;
end 
NyStart = histcounts( (bwimage_clone(yStart,:,:) ), 3 );
while( NyStart(3) < layerthreshold )
    yStart = yStart + 1;
    NyStart = histcounts( (bwimage_clone(yStart,:,:)) , 3 );
end


while any(any(bwimage_clone(yEnd,:,:))) == 0
   yEnd = yEnd - 1; 
end
NyEnd = histcounts( (bwimage_clone(yEnd,:,:)) , 3 );
while( NyEnd(3) < layerthreshold )
    yEnd = yEnd -1;
    NyEnd = histcounts( (bwimage_clone(yEnd,:,:) ), 3 );
end


while any(any(bwimage_clone(:,xStart,:))) == 0
    xStart = xStart + 1;
end 
NxStart = histcounts( (bwimage_clone(:,xStart,:) ), 3 );
while( NxStart(3) < layerthreshold )
    xStart = xStart +1;
    NxStart = histcounts( (bwimage_clone(:,xStart,:)) , 3 );
end


while any(any(bwimage_clone(:,xEnd,:))) == 0
   xEnd = xEnd - 1; 
end

NxEnd = histcounts(( bwimage_clone(:,xEnd,:)) , 3);

while( NxEnd(3) < layerthreshold )
    xEnd = xEnd -1;
    NxEnd = histcounts(( bwimage_clone(:,xEnd,:)) , 3 );
end


while any(any(bwimage_clone(:,:,zStart))) == 0 
    zStart = zStart + 1;
end
NzStart = histcounts(( bwimage_clone(:,:,zStart)) , 3);
while( NzStart(3) < layerthreshold )
   zStart = zStart + 1;
   NzStart = histcounts(( bwimage_clone(:,:,zStart)) , 3);
end


while any(any(bwimage_clone(:,:,zEnd))) == 0
    zEnd = zEnd - 1;
end
NzEnd = histcounts( (bwimage_clone(:,:,zEnd)) , 3);
while( NzEnd(3) < layerthreshold )
   zEnd = zEnd - 1;
   NzEnd = histcounts(( bwimage_clone(:,:,zEnd)) , 3);
end




% ---------------------------CALCULATE A CENTER POINT----------------------

% 'mass' (total intensity) of image
mass = 0; 

% first 3D mass moments (position of image point times its mass, summed up)
massxy = 0;
massyz = 0;
massxz = 0;

% for loop to calculate above values

for j=yStart:yEnd
   for  i=xStart:xEnd
       for k=zStart:zEnd
           %if bwimage(j,i,k)>=intensityThreshold
               mass = mass + bwimage(j,i,k);
               massxy = massxy + bwimage(j,i,k)*k;
               massyz = massyz + bwimage(j,i,k)*i;
               massxz = massxz + bwimage(j,i,k)*j;
               
           %end 
       end    
   end    
end

% center of mass depicted as a vector 
centerofmass = [massxz massyz massxy]/mass;



%---------------------------Image Visualization----------------------------
% defining an axis on which a 3D representation of the image can be
% visualized

ax = gca;
ax.Box = 'off';
ax.XLim = [-1*xlength1/2 xlength1/2];
ax.YLim = [-1*ylength1/2 ylength1/2];
ax.ZLim = [-1*zlength1/2 zlength1/2];
%the x axis should be on the bottom right, the y on the bottom left, and z
%should be vertical 

% defining the angle of view
ax.CameraPosition = [300, 300, 10 ];
ax.CameraTarget = [0, 0, 0];

%makes axis invisible for now
ax.Visible = 'off';


%vectors to hold coordinates of points in the bwiamge that aren't empty
%(points that have an intensity value greater than intensityThreshold)

numberofpoints = (yEnd-yStart)*(zEnd-zStart)*(xEnd-xStart);


%Set the center of mass to be the origin
gYStart = floor( yStart - centerofmass(1) ); 
gYEnd = floor( yEnd - centerofmass(1) );
gXStart = floor( xStart - centerofmass(2) );
gXEnd = floor( xEnd - centerofmass(2) );
gZStart = floor( zStart - centerofmass(3) );
gZEnd = floor( zEnd - centerofmass(3) );
 
%the meshgrid that I will be working with
[X, Y, Z] = meshgrid(gYStart:gYEnd, gXStart:gXEnd,  gZStart:gZEnd);
%the intensity values at each point of this meshgrid 
V = bwimage_clone(xStart:xEnd, yStart:yEnd,  zStart:zEnd);

%find the origin in my new meshgrid coordinate system
X0 = 1;
Y0 = 1;
Z0 = 1;

while ~(X(1,Y0, 1) == 0)
    Y0 = Y0 + 1;    
end

while ~(Y(X0, 1, 1) == 0)
    X0 = X0 + 1;   
end    
while ~(Z(1, 1, Z0) == 0)
    Z0 = Z0 + 1; 
end    


% Use this code to debug meshgrid issues
%{
xsize = size(X);
ysize = size(Y);
zsize = size(Z);
vsize = size(V);
%}
% view = V(:, :, 30);


%--------------------------Interpolation of Rays---------------------------

% spherical coordinates
%{
theta is the polar angle (between the z axis and r)
phi is the azimuthal angle. (between the x axis and r's projection onto the
xy plane
rho is the radial distance
%}



theta_res = pi/48;
phi_res = pi/36;
theta_bound = pi;
phi_bound = 2*pi;
rho_res = 1;
%Interp test
rho_interp_length = xlength1;



%Cell arrays to contain all the coordinates of the points in the rays that
%I shoot
XqList = cell(theta_bound/theta_res, phi_bound/phi_res);
YqList = cell(theta_bound/theta_res, phi_bound/phi_res);
ZqList = cell(theta_bound/theta_res, phi_bound/phi_res);
%Cell arrays to contain all the rays I shoot
rayList = cell(theta_bound/theta_res, phi_bound/phi_res); 
rhoList = cell(theta_bound/theta_res, phi_bound/phi_res); 
%Lists to contain the interpolations of the rays
rhoq = cell(theta_bound/theta_res, phi_bound/phi_res); 
interpList = cell(theta_bound/theta_res, phi_bound/phi_res);
%index to keep track of the number of rays that have been shot


%BEGINNING OF BIG FOR LOOP

for theta = 0: theta_bound/theta_res 
    for phi = 0: phi_bound/phi_res 
       % Instantiating query point coordinates - these arrays will contain the
       % coordinates of the points that I want to interpolate 

       Xq = zeros(rho_interp_length, 1);
       Yq = zeros(rho_interp_length, 1);
       Zq = zeros(rho_interp_length, 1);
       %The query point coordinate arrays all begin at the origin
       Xq(1) = X0;
       Yq(1) = Y0;
       Zq(1) = Z0;
       % Temporary variable, will hold each ray until it's added to rayList
       rho = zeros(rho_interp_length, 1);
       Vline = zeros(rho_interp_length, 1);
       Vline(1, 1) = V(X0, Y0, Z0);
       %conditions that will bound the lengths of the rays 
       Xcond = true; 
       Ycond = true;
       Zcond = true;
       %Shooting a ray from the origin
       rho_index = 1;
       while( Xcond ) && ( Ycond ) && ( Zcond )
           Xq(rho_index+1) = Xq(rho_index) + 1*sin(theta*theta_res)*cos(phi*phi_res);
           Yq(rho_index+1) = Yq(rho_index) + 1*sin(theta*theta_res)*sin(phi*phi_res);
           Zq(rho_index+1) = Zq(rho_index) + 1*cos(theta*theta_res); 
           Xcond = (Xq(rho_index+1)< (xEnd-xStart) ) && (Xq(rho_index+1)>1) ;
           Ycond = (Yq(rho_index+1)< (yEnd-yStart) ) && (Yq(rho_index+1)>1) ;
           Zcond = (Zq(rho_index+1)< (zEnd-zStart) ) && (Zq(rho_index+1)>1) ;
           if ( Xcond ) && ( Ycond ) && ( Zcond )
               %putting in nearest neighbor interpolation - this way Vline contains
               %values even when Xq, Yq, and Zq are non-integer
               Vline(rho_index+1) = V( round( Xq( rho_index+1 ) ), round( Yq( rho_index+1 ) ), round( Zq( rho_index+1 ) ) );
               rho(rho_index+1) = rho(rho_index) + 1;
               rho_index = rho_index + 1;
           end
       end
       %the above loop fills only part of the rho and Vline arrays. 
       %Here, I put them into cells for storage 
       %NOTE: Everything here is a column vector
       Xq = Xq(1:rho_index,1);
       Yq = Yq(1:rho_index,1);
       Zq = Zq(1:rho_index,1);
       rho = rho(1:rho_index, 1);
       Vline = Vline(1:rho_index, 1);
       XqList{theta+1, phi+1} = Xq;
       YqList{theta+1, phi+1} = Yq;
       ZqList{theta+1, phi+1} = Zq;
       rhoList{theta+1, phi+1} = rho;
       rayList{theta+1, phi+1} = Vline;
       
       %temp_rhoq - temporary storage variable
       temp_rhoq = (1:rho_res/10:size(rho));
       
       %next line turns it into a column vector
       temp_rhoq = temp_rhoq(:);
       
       rhoq{theta+1, phi+1} = temp_rhoq;
       interpList{theta+1, phi+1} = interp1(rho, Vline, temp_rhoq, 'spline'); 
       %when theta = 0 or pi radians, all values of phi will output the
       %same ray. This code tells it to go to the next value
       if (theta == 0) || (theta == theta_bound/theta_res)
          break; 
       end
    end
end    

% ONLY USE WHEN THETA_RES IS LARGE!
%{
theta = 0;
phi = 0;
while (theta <= theta_bound/theta_res)
    phi = 0;
    while (phi < phi_bound/phi_res)
        if( theta == (theta_bound/theta_res)/2 )
            figure()
            plot(rhoList{theta+1, phi+1}, rayList{theta+1,phi+1}, 'o', rhoq{theta+1,phi+1}, interpList{theta+1,phi+1}, '-');
            title(strcat('Ray Intensity Interpolation: \theta= ', num2str((theta)*theta_res/pi),'\pi, \phi = ', num2str((phi)*phi_res/pi), '\pi'));
            xlabel('Distance from center of image');
            ylabel('Pixel Intensity');
        end   
            phi = phi + 1;
            
            %when theta = 0 or pi radians, all values of phi will output the
            %same ray. This code tells it to go to the next value
            if (theta == 0) || (theta == theta_bound/theta_res)
                break; 
            end
            
    end
    theta = theta + 1;
end 
%}

% Code to collect all the boundary points
% For now, I am defining the boundary point as the last nonzero point in
% the data.
numSurfacePoints = theta_bound/theta_res * phi_bound/phi_res;
%these will hold the query points for the 3D Surface interpolation
Xqsurf = zeros(numSurfacePoints, 1);
Yqsurf = zeros(numSurfacePoints, 1);
Zqsurf = zeros(numSurfacePoints, 1);
%instantiating loop variables
theta = 0;
phi = 0;
%a temporary holder for the line from which I will find the boundary point
rayHolder = zeros(rho_interp_length, 1);
%temporary holders for the list of X, Y, and Z coordinates of my boundary
%point
xHolder =  zeros(rho_interp_length, 1);
yHolder =  zeros(rho_interp_length, 1);
zHolder =  zeros(rho_interp_length, 1);
%holds the value of said boundary point
pointHolder = 0;
%holds the index of the boundary point
pointIndex = 0;
%running total of boundary points collected
pointNum = 0;

while (theta <= theta_bound/theta_res)
    phi = 0;
    while (phi <= phi_bound/phi_res)
        rayHolder = rayList{theta+1, phi+1};
        xHolder = XqList{theta+1, phi+1};
        yHolder = YqList{theta+1,phi+1};
        zHolder = ZqList{theta+1, phi+1};
        pointIndex = size(rayHolder, 1);
        pointHolder = rayHolder(pointIndex, 1);
        while ((pointHolder == 0) && (pointIndex > 1))
            pointIndex = pointIndex - 1;
            pointHolder = rayHolder(pointIndex, 1);
            %disp(theta*phi);
        end    
        pointNum = pointNum + 1;
            
        Xqsurf(pointNum) = xHolder(pointIndex);
        Yqsurf(pointNum) = yHolder(pointIndex);
        
        Zqsurf(pointNum) = zHolder(pointIndex);
        phi = phi+1;
        if (theta == 0) || (theta == theta_bound/theta_res)
            break; 
        end
    end
    theta = theta + 1;
end    
Xqsurf = Xqsurf(1:pointNum) - X0;
Yqsurf = Yqsurf(1:pointNum) - Y0;
Zqsurf = Zqsurf(1:pointNum) - Z0;

%Converting final image from pixels to distances
NA = 1/4; %numerical aperture of the 60x objective in confocal fluoview 1000
n1 = 1.33; % refractive index of water
n2 = 1.518; % refractive index of imaging oil
z_stretch = tan(asin(NA/n1))/tan(asin(NA/n2));
z_pxl2dist = 0.43; %0.43 um/pxl conversion in z-direction
z_scale_factor = z_stretch*z_pxl2dist;

xy_scale_factor = 0.102; % 0.102 um/pxl conversion in z-direction

Xqsurf = Xqsurf * xy_scale_factor;
Yqsurf = Yqsurf * xy_scale_factor;
Zqsurf = Zqsurf * z_scale_factor;



%scatter3(Xqsurf, Yqsurf, Zqsurf, 'o');
%K = convhull(Xqsurf, Yqsurf, Zqsurf);
tri = convhull(Xqsurf,Yqsurf, Zqsurf);  

trisurf(tri, Xqsurf, Yqsurf, Zqsurf);
whos('nodesSurface');








