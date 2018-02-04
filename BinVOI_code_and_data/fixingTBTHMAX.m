%{
fileFolder = 'D:\Carlson Lab\Bone Project Data\Bin_Data\bin_VOIs\';

cd(fileFolder);
index1Lim = 10;%9;
index2Lim = 3;%3;
%}

 for index1 = 0:9
     for index2 = 0:3
        graphprefix = strcat('graphVOI_', sprintf('%01.0f',index1),'01x',sprintf('%01.0f',index2),'01y');
        %graphfile = strcat('skel',char(graphprefix));
        
        tbthmax = thicknesses((index1)*4 + index2 + 1);
        load(graphprefix);
        %load('graphVOI_001x001y.mat');
        len = length(link);
        for i = 1:len
            link(i).thicknesses = link(i).thicknesses* ( tbthmax / (link(1).maxthickness) );
            link(i).avgthickness = link(i).avgthickness * ( tbthmax /(link(1).maxthickness) );
        end
        link(1).maxthickness = tbthmax;
        
        saveFileName = horzcat('graph',graphprefix,'.mat');
        save(graphprefix, 'skel','node','link');
        clear('skel','node','link');
        %clear thicknessMap;
    end
end    

