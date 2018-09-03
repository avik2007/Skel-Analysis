%% ------------------------ resliceBoneImages -----------------------------
% Avik Mondal
% first edited: 05/20/2016
% Aim:
% - cut bone images along coronal and sagittal axis
% - this script should be used in conjunction with loadRawBoneImages
%--------------------------------------------------------------------------
file = 'C:\Users\Avik\Documents\Carlson Lab\Bone Project Data\ESA_resliced_cropped';
filetype = '.bmp';
axialFileDir = '\ESA_axial_slices';
sagittalFileDir = '\ESA_sag_slices';
coronalFileDir = '\ESA_cor_slices';

[corLength, sagLength,axialLength] = size(bigImageMat);

axImgName = '\Ax_img_';
sagImgName = '\Sag_img_';
corImgName = '\Cor_img_';

%{
for cor = 1:corLength
    cor = logical(cor);
    sliceCor = squeeze(bigImageMat(cor,:,:));
    nameCor = strcat(corImgName, sprintf('%04.0f', cor));
    filenameCor = strcat(file,coronalFileDir, nameCor, filetype);
    imwrite(sliceCor, filenameCor, 'bmp');
end
%}

for sag = 1:1:sagLength
    sliceSag = squeeze(bigImageMat(:,sag,:));
    nameSag = strcat(sagImgName,sprintf('%04.0f', sag));
    filenameSag = strcat(file,sagittalFileDir, nameSag, filetype); 
    imwrite(sliceSag, filenameSag, 'bmp');
end

for ax = 1:1:axialLength
    sliceAx = squeeze(bigImageMat(:,:,ax));
    nameAx = strcat(axImgName,sprintf('%04.0f', ax));
    filenameAx = strcat(file,axialFileDir, nameAx, filetype);
    imwrite(sliceAx, filenameAx, 'bmp');
    %{
    ax = logical(ax);
    sliceAx = squeeze(bigImageMat(:,:,ax));
    nameAx = strcat(axImgName,sprintf('%04.0f', ax));
    filenameAx = strcat(file,axialFileDir, nameAx, filetype);
    imwrite(sliceAx, filenameAx, 'bmp');
    %}
end 
    
