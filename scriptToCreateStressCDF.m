%Creating the stress cdf po

voilist = ["001x001y","001x101y", "001x201y", "001x301y", "101x001y",  "101x201y" ...
    ,"101x301y"  ...
    ,"301x301y", "701x001y", "701x101y","701x201y","701x301y","801x001y" ...
    ,"801x101y", "801x201y","801x301y", "901x001y","901x101y","901x201y","901x301y"];
voi_index = [1,2,3,4,5,6,7, 14, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30];
voilist2 = ["2x0y", "2x1y", "2x3y", "3x0y", "3x1y", "3x2y"...
    , "6x0y", "6x1y", "6x2y", "6x3y"];
voi_index2 = [8,9,10,11 12, 13, 15,16,17,18];
zero_point = zeros(1,30);
ninety_point = zeros(1,30);

for main_index = 1:length(voilist2)
    clearvars -except voilist voilist2 zero_point main_index voi_index voi_index2 ninety_point;
    prefix = 'C:\Users\Avik Mondal\Documents\Carlson Lab\Bone Project Data\VOI_bulk_graph_analysis\Bulk_Graph_Analysis_WORKSPACES\Finished_workspaces_5_18_2018\workspace_';
    suffix = '.mat';
    voiname = voilist2(1,main_index);
    load(char(strcat(prefix, voiname, suffix)));
    
    link_stress_time = stress_data;
    timesteps = size(link_stress_time,2);


    Stress = [link_trunc.finalStress];

    finalStresses = zeros(size(link_stress_time,1),2);
    finalStresses(:,1) = (link_stress_time(:,26));
    finalStresses(:,2) = (1:size(link_stress_time,1))';

    map = containers.Map(finalStresses(:,1)',finalStresses(:,2)');
    orderedStress = sort(finalStresses(:,1), 'descend'); 
    orderedStressLinks = arrayfun(@(x) map(x), orderedStress);
    orderedStresses = [orderedStress orderedStressLinks];

    % CDF plotting 
    %main_index = timesteps;
    Stress = link_stress_time((orderedStresses(:,2))', end); %stress at max strain
    NormStress = Stress / max(Stress);

    % For plotting % of links with stress less than a certain stress
    for index = 1:length(NormStress)
        if (NormStress(index,1) == 0)
            NormStress(index,2) = length(find(NormStress(:,1) == 0)) / length(NormStress);
        else
            NormStress(index,2) = 1.0 - ( (index) / length(NormStress) );
        end
    end
    NormStress = NormStress(find(NormStress(:,1) >= 0.001),:);
    zero_point(1,voi_index2(1,main_index)) = NormStress(end,2);
    
    
    potential_ninety = NormStress(find(NormStress(:,2)>0.8999),2);
    ninety_point(1, voi_index2(1,main_index)) = NormStress( find(NormStress(:,2) == min(potential_ninety)), 1);
end
main_index = 1;
for main_index = 1:length(voilist)
    clearvars -except voilist voilist2 zero_point main_index voi_index voi_index2 ninety_point;
    prefix = 'C:\Users\Avik Mondal\Documents\Carlson Lab\Bone Project Data\VOI_bulk_graph_analysis\Bulk_Graph_Analysis_TRUNC_GRAPHS\all_truncs\TRUNCgraphVOI_';
    suffix = '.mat';
    voiname = voilist(1,main_index);
    load(char(strcat(prefix, voiname, suffix)));
    
    link_stress_time = stress_data;
    timesteps = size(link_stress_time,2);


    Stress = [link_trunc.finalStress];

    finalStresses = zeros(size(link_stress_time,1),2);
    finalStresses(:,1) = (link_stress_time(:,26));
    finalStresses(:,2) = (1:size(link_stress_time,1))';

    map = containers.Map(finalStresses(:,1)',finalStresses(:,2)');
    orderedStress = sort(finalStresses(:,1), 'descend'); 
    orderedStressLinks = arrayfun(@(x) map(x), orderedStress);
    orderedStresses = [orderedStress orderedStressLinks];

    % CDF plotting 
    %main_index = timesteps;
    Stress = link_stress_time((orderedStresses(:,2))', end); %stress at max strain
    NormStress = Stress / max(Stress);

    % For plotting % of links with stress less than a certain stress
    for index = 1:length(NormStress)
        if (NormStress(index,1) == 0)
            NormStress(index,2) = length(find(NormStress(:,1) == 0)) / length(NormStress);
        else
            NormStress(index,2) = 1.0 - ( (index) / length(NormStress) );
        end
    end
    NormStress = NormStress(find(NormStress(:,1) >= 0.001),:);
    zero_point(1,voi_index(1,main_index)) = NormStress(end,2);
    
    potential_ninety = NormStress(find(NormStress(:,2)>0.8999),2);
    ninety_point(1, voi_index(1,main_index)) = NormStress( find(NormStress(:,2) == min(potential_ninety)), 1);
    
end

%{

%% for this code, it's safest to do this for an individual voi - just load one at a time
figure('Name',horzcat('Sample Normalized Stress CDF'));
plot(NormStress(:,1), NormStress(:,2), 'LineWidth', 2);

hold on
plot(0.2294, 0.9003, 'ro');
hlineXcoords = [0 0.2294];
hlineYcoords = [0.9003 0.9003];
vlineXcoords = [0.2294 0.2294];
vlineYcoords = [0 0.9003];
x1 = 0.25; y1 = 0.45;
txt1 = '$\leftarrow \frac{\sigma}{{\sigma}_{max} (t)} = 0.229$';
text(x1,y1,txt1, 'Interpreter', 'latex', 'FontSize', 13);
x2 = 0.01; y2 = 0.2475;
txt2 = '$0.248$';
text(x2,y2, txt2, 'Interpreter', 'latex', 'FontSize',13);
plot(hlineXcoords, hlineYcoords, 'r');
plot(vlineXcoords, vlineYcoords, 'r');
plot(0, 0.25, 'ro');
hold off
grid on
%title("Sample Stress CDF", 'FontSize', 14);
ylabel('Fraction of beams with norm. stress $\leq \frac{\sigma}{{\sigma}_{max} (t)}$ ', 'Interpreter', 'latex', 'FontSize', 14);
xlabel('Normalized stress ($ \frac{\sigma}{{\sigma}_{max} (t)}$)', 'Interpreter', 'latex', 'FontSize', 14);
xlim([0 1]);

map = containers.Map(finalStresses(:,1)',finalStresses(:,2)');
orderedStress = sort(finalStresses(:,1), 'descend'); 
orderedStressLinks = arrayfun(@(x) map(x), orderedStress);
orderedStresses = [orderedStress orderedStressLinks];
%}
