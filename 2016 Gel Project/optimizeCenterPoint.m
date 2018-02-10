% --- OPTIMIZE CENTER POINT
for k=1:10
    % make a new image that only contains the image points from the original
    % image (of which you want to find the center) up to a certain radius r; 
    % centerx and centery
    % are the possible center points found so far (you need some input before
    % the k=1:10 iteration starts; you can have more than 10 iterations if you like

    NewImage=zeros(size(image));
    % transfer pixel values from the original image to this new image
    for p=1:ylength
        for q=1:xlength
            if (centerx-q)^2+(centery-p)^2 <= r^2
                NewImage(p,q)=image(p,q);
            end
        end
    end

    % calculate the center of mass of these points and find new center of
    % mass
    for i=1:ylength
        for j=1:xlength
            if NewImage(i,j)>0
                weight=weight+NewImage(i,j);
                weightx=weightx + NewImage(i,j)*j; % imagebw(y,x) !!!
                weighty=weighty + NewImage(i,j)*i; % x=j, y=i
            end
        end
    end

    % new center of mass of region within circle of radius r
    centerxnew=weightx/weight;
    centerynew=weighty/weight;

    % distance from new to old center; if this is sufficiently small, new
    % center is adapted and the for loop ends
    if (centerx-centerxnew)*(centerx-centerxnew)+(centery-centerynew)*(centery-centerynew)< 5
    % this number is the pixel distance between the previous center and
    %the new one; 5 is kind of arbitrary, but lead to good results

r=r-ceil(sqrt((centerx-centerxnew)*(centerx-centerxnew)+(centery-centerynew)*(centery-centerynew)));

        centerx=centerxnew;
        centery=centerynew;
        % for-loop ends here if the <5 condition is fulfilled
    break,
    end

    % set the new center to the old center variables, when the for-loop runs again

r=r-ceil(sqrt((centerx-centerxnew)*(centerx-centerxnew)+(centery-centerynew)*(centery-centerynew)));
    centerx=centerxnew;
    centery=centerynew;
end