%this code takes the dual (pore) networks and incorporates the thicknesses 
%into the model to create dual thick models
cd('C:\Users\Avik Mondal\Documents\Carlson Lab\Bone Project Data\Bin_Data\bin_VOIs');
addpath('C:\Users\Avik Mondal\Documents\Carlson Lab\Bone Project MATLAB code');
load('tbsp_list.txt');
firstIndex = 1;
filetype = "bmp";
x0 = 1;
y0 = 1;
xdim = 100;
ydim = 100;
zdim = 100;
sigfigs = 4;

preprefix = "VOI_";
suffices = strings(9,4) ;
for xindex = 0:9
    for yindex = 0:3
        firstPart = sprintf('%03d%s',xindex*100 + 1,"x");
        lastPart = sprintf('%03d%s', yindex*100 + 1,"y");
        suffices(xindex+1,yindex+1) = strcat(preprefix,firstPart,lastPart);        
    end
end

directory = "C:\Users\Avik Mondal\Documents\Carlson Lab\Bone Project Data\Bin_Data\bin_VOIs\";

   
for i = 0:9
    for j = 0:3
        fullFolder = strcat(directory, suffices(i+1,j+1), "_Sp\");
        prefix = strcat(suffices(i+1,j+1), "_Sp_");
        dualThickMap = loadColoredThresholdSequence(fullFolder,prefix,firstIndex,filetype,x0,y0,xdim,ydim,zdim,sigfigs);
        dualFile = strcat('dual', suffices(i+1,j+1), '.mat');
        load(dualFile);
        tbspmax = tbsp_list(i+1,j+1);
        dlink = getFIJITbTh(dualThickMap,dlink,tbspmax);
        save(strcat('dual_thick_', suffices(i+1,j+1)),'dlink','dnode', 'dual_skeleton');
        clearvars -except directory tbsp_list firstIndex filetype x0 y0 xdim ...
            ydim zdim sigfigs suffices i j
    end
end