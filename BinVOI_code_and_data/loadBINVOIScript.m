%a script to skeletonize all of chantal's bin voi's
%also edited to get nodes and links
filetype = "bmp";
firstIndex = 1;
x0 = 1; y0 = 1;
xdim = 100; ydim = 100; zdim = 100;

fileFolder = 'C:\Users\Avik\Documents\Carlson Lab\Bone Project Data\Bin_Data\bin_VOIs\';

cd(fileFolder);
index1Lim = 10;%9;
index2Lim = 3;%3;

 for index1 = 1:index1Lim
     for index2 = 1:index2Lim 
        prefix = strcat('VOI_', sprintf('%01.0f',index1),'01x',sprintf('%01.0f',index2),'01y_Tb_');
        folderLabel = strcat(prefix(1:end-1),'\');
        folder = strcat(fileFolder,folderLabel);
        thicknessMap = loadColoredImageSequence(folder,prefix,firstIndex,filetype,x0,y0,xdim,ydim,zdim);    
        
        skelprefix = strcat('VOI_', sprintf('%01.0f',index1),'01x',sprintf('%01.0f',index2),'01y');
        skelfile = strcat('skel',char(skelprefix));
        
        cd(horzcat(prefix(1:end-3),'Tb'));
        xlsResults = xlsread(horzcat(prefix(1:end-3),'Results.csv'));
        tbthmax = xlsResults(1,5); %CHECK THAT THIS IS THE RIGHT INDEX!
        cd('..');
        
        load(skelfile);
        [node,link] = convertSkelToGraph(skel);
        link = getFIJITbTh(thicknessMap,link,tbthmax);
        saveFileName = horzcat('graph',skelprefix,'.mat');
        save(saveFileName, 'skel','node','link');
        %clear thicknessMap;
    end
end    
%{
% THIS PART WAS FOR TURNING THE VOI'S INTO BINARY SKELETONS
for index1 = 0:index1Lim
    for index2 = 0:index2Lim
        prefix = strcat('VOI_', sprintf('%01.0f',index1),'01x',sprintf('%01.0f',index2),'01y');
        folderLabel = strcat(prefix,'\'); 
        folder = strcat(fileFolder,folderLabel);
        VOI = loadBinVOISequence(folder,prefix,firstIndex,filetype,x0,y0,xdim,ydim,zdim);
        skel = Skeleton3D(VOI);
        saveFileName = horzcat('skel',prefix,'.mat');
        save(saveFileName, 'skel');
        clear VOI skel;
    end  
end
%}


%{
prefix = strcat('VOI_', sprintf('%01.0f',index1),'01x',sprintf('%01.0f',index2),'01y');
folderLabel = strcat(prefix,'\'); 
folder = strcat(fileFolder,folderLabel);
VOI = loadBinVOISequence(folder,prefix,firstIndex,filetype,x0,y0,xdim,ydim,zdim);
save VOI001x001y.mat VOI;
%}