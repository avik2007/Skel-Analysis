function [Max,Msag,Mcor] = videox(immat)
%plays axial and both orthogonal axes views through stack
[m1,m2,m3] = size (immat);
figure;
colormap(gray);

% axial movie
skip=1;
Max(length(1:skip:m3)) = struct('cdata',[],'colormap',[]);
for ax = 1:skip:m3
    im =squeeze(immat(:,:,ax));
    imagesc(im) ;    
    axis image
    text(0,-5,num2str(ax))
    text(50,-5,'ax')
    Max((1:skip:m3)==ax) = getframe(gcf);
%     figure
%     imhist(im);
    pause (0.001);

end

% sagittal movie
skip=1;
Msag(length(1:skip:m2)) = struct('cdata',[],'colormap',[]);
for sag = 1:skip:m2
    imagesc(squeeze(immat(:,sag,:)));
    axis image
    text(0,-5,num2str(sag))
    text(50,-5,'sag')
    Msag((1:skip:m2)==sag) = getframe(gcf);
    pause (0.001);
end

% coronal movie
skip=1;
Mcor(length(1:skip:m1)) = struct('cdata',[],'colormap',[]);
for cor = 1:skip:m1
    imagesc(squeeze(immat(cor,:,:)));
    axis image
    text(0,-5,num2str(cor))
    text(50,-5,'cor')
    Mcor((1:skip:m1)==cor) = getframe(gcf);
    pause (0.005);
end

%play movies
%figure;
%movie(Max);
%figure;
%movie(Msag);
%figure;
%movie(Mcor);
%end of code
end