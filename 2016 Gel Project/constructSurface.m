% ------ constructSurface ------
% Avik Mondal
% last edited: 10/26/2016
% Aim:
% - put together the points of the outline that make up my surface

surfX = zeros(Np+1, 1); surfY = zeros(Np+1, 1); surfZ = zeros(Np+1, 1);

%insert the centroid as the first point
surfX(1, 1) = centroid_nna(1);
surfY(1, 1) = centroid_nna(2);
surfZ(1, 1) = centroid_nna(3);

for num = 1: numTotal
    surfIndex = num + 1;
    
    
    pixelprojectX = paramLengthDetected(num) * unitVectors_X(num) + centroid_nna(1);
    pixelprojectY = paramLengthDetected(num) * unitVectors_Y(num) + centroid_nna(2);
    pixelprojectZ = paramLengthDetected(num) * unitVectors_Z(num) + centroid_nna(3);
    
    distprojectX = pixelprojectX * xy_scale_factor;
    distprojectY = pixelprojectY * xy_scale_factor;
    distprojectZ = pixelprojcetZ * z_scale_factor;
    surfX(surfIndex,1) = distprojectX;
    surfY(surfIndex,1) = distprojectY;
    surfZ(surfIndex,1) = distprojectZ;
end



