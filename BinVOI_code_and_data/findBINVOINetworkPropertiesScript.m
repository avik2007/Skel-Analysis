
%finds network properties of the binVOI data set
%make sure getNodeLinkProperties has closeness turned OFF!
addpath('C:\Users\Avik\Documents\Carlson Lab\Bone Project MATLAB code\Assortativity');
xMax = 10; %number of x coordiantes (chantal's indexing system)
yMax = 4;  %number of y coordiantes (chantal's indexing system)
meanKList = zeros(1,40); %store the mean number of links (all links, even endpoints);
meanWCCList = zeros(1,40); % store the mean weighted clustering coefficent
meanStrengthList = zeros(1,40); %store the mean strenght of each VOI
PearsonDegreeCoeff = zeros(1,40); %store the Pearson degree correlation coefficient
estimatedVolume = zeros(1,40);
corrL = zeros(1,40);

for x = 0:xMax - 1
    for y = 0:yMax - 1


        folder = "C:\Users\Avik\Documents\Carlson Lab\Bone Project Data\Bin_Data\bin_VOIs\";
        prefix = strcat("graphVOI_",sprintf('%01.0f',x),"01x",sprintf('%01.0f',y),"01y");
        load(strcat(folder,prefix));
        %disp(strcat(folder,prefix));
        clear folder prefix;
        cd ..
        [~,~,corrL(1,x*(yMax)+y+1)] = findSpanningSubGraph(node,link,skel);
        if isnan( corrL(1,x*yMax+y+1) ) || ( corrL(1,x*yMax+y+1) == Inf )
            corrL(1,x*yMax+y+1) = 0;
        end
        %{
        link = findBranchLength(link,skel);
        tHeights = [link.length];
        tRads = [link.avgthickness]/2;
        tVols = [tRads].*[tRads]*pi.*[tHeights];
        estimatedVolume(1,x*(yMax)+y+1) = sum(tVols)/(100*100*100)  ;
        %}

        %[node,~] = getNodeLinkProperties(node,link,skel);
        %PearsonDegreeCoeff(1,x*(yMax)+y+1) = findDegreeCorrCoefficient(node,link);
        
        %for finding clustering ,node degree, and strength
        %clear link skel;
         
        %kList = zeros(1,length(node));
        %clusteringList = zeros(1,length(node));
        %strengthList = zeros(1,length(node));
        %for i = 1:length(node)
        %    kList(1,i) = length(node(i).conn);
        %    clusteringList(1,i) = node(i).weightedCC;
        %    strengthList(1,i) = node(i).strength;
        %end    
        
        %meanWCCList(1,x*(yMax)+y+1) = mean(clusteringList);
        %meanStrengthList(1,x*(yMax)+y+1) = mean(strengthList);
        %meanKList(1,x*(yMax)+y+1) = sum(kList)/length(find(kList > 2));
        %clear clusteringList strengthList;
        %clear node;
        
   end
end
disp('Save your variables');
%{
%debuggin code
folder = "C:\Users\Avik\Documents\Carlson Lab\Bone Project Data\Bin_Data\bin_VOIs\";
        prefix = strcat("graphVOI_","3","01x","0","01y");
        load(strcat(folder,prefix));
        [node,~] = getNodeLinkProperties(node,link,skel);
%} 