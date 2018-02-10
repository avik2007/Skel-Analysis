% ------ GEL DROP SURFACE BOUNDARY DETECTION v2.0 ------
% Avik Mondal
% last edited: 09/24/2016
% Aim:
% - find the surface of my gel beads
% CORRECTIONS From original
% - get rid of thresholding
% - find centroid differently
% - use unit vectors to shoot rays


%clear all;
%clearvars;
%close all;
%clc;

%read in the image
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



%--------------------------Removing Excess Points-------------------------
%Takes out layers of the image that have 0 as their voxel value
 

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

%{

layerthreshold = 10;

while any(any(bwimage(yStart,:,:))) == 0
    yStart = yStart + 1;
end 
NyStart = histcounts( (bwimage(yStart,:,:) ), 3 );
while( NyStart(3) < layerthreshold )
    yStart = yStart + 1;
    NyStart = histcounts( (bwimage(yStart,:,:)) , 3 );
end


while any(any(bwimage(yEnd,:,:))) == 0
   yEnd = yEnd - 1; 
end
NyEnd = histcounts( (bwimage(yEnd,:,:)) , 3 );
while( NyEnd(3) < layerthreshold )
    yEnd = yEnd -1;
    NyEnd = histcounts( (bwimage(yEnd,:,:) ), 3 );
end


while any(any(bwimage(:,xStart,:))) == 0
    xStart = xStart + 1;
end 
NxStart = histcounts( (bwimage(:,xStart,:) ), 3 );
while( NxStart(3) < layerthreshold )
    xStart = xStart +1;
    NxStart = histcounts( (bwimage(:,xStart,:)) , 3 );
end


while any(any(bwimage(:,xEnd,:))) == 0
   xEnd = xEnd - 1; 
end

NxEnd = histcounts(( bwimage(:,xEnd,:)) , 3);

while( NxEnd(3) < layerthreshold )
    xEnd = xEnd -1;
    NxEnd = histcounts(( bwimage(:,xEnd,:)) , 3 );
end


while any(any(bwimage(:,:,zStart))) == 0 
    zStart = zStart + 1;
end
NzStart = histcounts(( bwimage(:,:,zStart)) , 3);
while( NzStart(3) < layerthreshold )
   zStart = zStart + 1;
   NzStart = histcounts(( bwimage(:,:,zStart)) , 3);
end


while any(any(bwimage(:,:,zEnd))) == 0
    zEnd = zEnd - 1;
end
NzEnd = histcounts( (bwimage(:,:,zEnd)) , 3);
while( NzEnd(3) < layerthreshold )
   zEnd = zEnd - 1;
   NzEnd = histcounts(( bwimage(:,:,zEnd)) , 3);
end

%}
 
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

%I copied and pasted Bugra's forceSphereCreateSurface1.m code
% function X=forceSphere(N, vargin)
% Calc Thomson equlibrium on sphere of N points
%
% vx = forceSphere(N)
% vx = forceSphere(N,tol)
%
% Input: N number of points to distribute. tol tolerance.
% Returns: Nx3 array of points on the sphere.

%NOTE FROM BUGRA:
%tol 1e-4 is satisfactory and works fast.
%if you want more regular surface go down to tol=1e-6. this will take  
%around half a minute to run for ~500 points and will scale up with 
%increasing number of nodes.

%{
N=900; tol=1e-4;
X=randn(N,3);
k = 0.1; %stepsize
smudge=1e-3; % prevent singularities
radius=1;

% if (nargin>1) tol=vargin(1); else tol=1e-6; end


delta=100;
while (delta>tol)
    delta=0;
    for i=1:N
        dx=ones(N,1)*X(i,:)-X;
        d=sum(dx'.^2)';
        fx=dx./(smudge+d*ones(1,3));
        xold=X(i,:);
        X(i,:)=X(i,:)+k*sum(fx);
        X(i,:)=X(i,:)/norm(X(i,:));
        delta=delta+norm(xold-X(i,:))/N;
    end
end

dt = delaunayTriangulation(X(:,1),X(:,2),X(:,3));
[tri, nodesSurface] = freeBoundary(dt);
%}

%nodesSurface contain the unit vectors of direction I will shoot rays in
%Below, I will  begin to create a means by which the program can do that. 
nodesSurface_pixels(:,1) = round(nodesSurface(:,1)/xy_scale_factor);
nodesSurface_pixels(:,2) =  round(nodesSurface(:,2)/xy_scale_factor);
nodesSurface_pixels(:,3) =  round(nodesSurface(:,3)/z_scale_factor);


radius = zeros(size(nodesSurface_pixels,1), 50);
length = zeros(size(nodesSurface_pixels, 1));
intensities = zeros(size(nodesSurface_pixels,1), 50);
rq = cell(size(nodesSurface_pixels,1),1);
iq = cell(size(nodesSurface_pixels,1),1);
%instantiating smoothediq with a random ppform just so that it holds the
%right struct variables to hold my actual interpolated intensity profiles
smoothediq(1) = ppmak(-5:-1,-22:-11);

clear i j k;


%{
j = centroid_nna(1);
i = centroid_nna(2);
k = centroid_nna(3);
%}

res_factor = 1/8;

for ray_index = 1:20%size(nodesSurface_pixels,1)
    resolution = round(res_factor*norm(nodesSurface_pixels(ray_index,:)));
    position = centroid_nna;
    j = position(1);
    i = position(2);
    k = position(3);
    inBounds = (i>xStart) & (i<xEnd) & (j>yStart) & (j<yEnd) & (k>zStart) & (k<zEnd);
    index = 1;
%disp(position);
    while (i>xStart) && (i<xEnd) && (j>yStart) && (j<yEnd) && (k>zStart) && (k<zEnd) %starradius(1:50, ray_index) = radius(1:index-1, ray_index);%usually the radius(index) and intensities(index) = 0 so i get rid of that index 
        %toort testing ray interpolation
        intensities(ray_index, index) = bwimage(j,i,k);
        radius(ray_index, index) = (index-1)*resolution;
    
        position = position + nodesSurface_pixels(ray_index,:);
        index = index+1;
        j = position(1);
        i = position(2);
        k = position(3);
    end
    %intensities(:, ray_index) = intensities(1:index-1, ray_index);%decrease the matrix size to get rid of all the 0's
    %radius(1:50, ray_index) = radius (1:index-1, ray_index);%usually the radius(index) and intensities(index) = 0 so i get rid of that index too
    length(ray_index) = index-1;
    rholder = 0:0.5:radius(ray_index,index-1);
    iholder = interp1(radius(ray_index,1:index-1), intensities(ray_index,1:index-1), rholder, 'spline');
    rq{ray_index} = rholder;
    iq{ray_index} = iholder;
    smoothediq(ray_index) = csaps(rq{ray_index}, iq{ray_index});
    
    
    figure()
    words = 'Improfile of vector: (';
    vectorx = nodesSurface(ray_index,2);
    vectory = nodesSurface(ray_index,1);
    vectorz = nodesSurface(ray_index,3);
    theta = num2str( acosd(vectorz/ sqrt( (vectorx)^2+(vectory)^2 + (vectorz)^2) ) );
    phi = num2str( atan2(vectory,vectorx)*180/pi );
    %label = strcat(words, vectorx,',', vectory,',', vectorz,')');
    label = strcat(words,'\theta = ', theta, ', \phi = ', phi,',',')');
    fnplt(smoothediq(ray_index), [0,radius(ray_index, index-1)]);
    title(label);
    
end    
num = cell(size(nodesSurface_pixels, 1), 1);
inflections = cell(900, 1);
%FIGURE OUT HOW TO STORE THESE PPFORMS STRUCTS!

%this function returns the number of inflection points as well as the 
%actual locations of the inflections. It takes the ppform and returns
%a list of the inflection points

%{
for ray_index=3:3 %size(nodesSurface_pixels,1)
    secondD = fnder(smoothediq(ray_index), 2);
    figure();
    fnplt(secondD);
    title('Derivative');
    
    crit_points = fnzeros(secondD);
    whos('crit_points');
    list = zeros(size(crit_points, 2)-2);
    temp_num = 0;
    %now we have to evaluate whether these are actually inflection points and
    %not just critical points
    if (size(crit_points, 2) > 3)
        for index = 2:(size(crit_points,2)-1)
            plusepsilon = (crit_points(1,index+1)+crit_points(1,index))/2; 
            minusepsilon = (crit_points(1,index)-crit_points(1,index-1))/2;
            if (((plusepsilon>0) && (minusepsilon<0)) || (plusepsilon<0) && (minusepsilon>0))
                list(index) = critpoints(1,index);
                temp_num = temp_num + 1;
            end    
        end
    end
    num{ray_index} = temp_num;
    inflections{ray_index} = list(2:temp_num);
end    
%}