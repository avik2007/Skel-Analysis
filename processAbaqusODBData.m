%script to handle odb link stress data (super large data sets)

%needs the csv in the workspace
%{
%link_stress_VOI_701x101y_split12; %1/28/2018 data
linklength = link_stress_VOI_701x101y_split12(length(link_stress_VOI_701x101y_split12),1);
datalength = length(link_stress_VOI_701x101y_split12);
%}
%{
%link_stress_VOI_701x101y_split9_new; %1/29/2018 data
linklength = link_stress_VOI_701x101y_split9_new(length(link_stress_VOI_701x101y_split9_new),1);
datalength = length(link_stress_VOI_701x101y_split9_new);
%}
%vvvvv insert the new split data
% 4/27 split9 data but new type of stress (von Mises instead of max
% principal)

% A = table2array(lslicestressesmisesVOI701x101y);

%cd '..\Bone Project Data\VOI_bulk_graph_analysis\Bulk_Graph_Analysis_STRESSES'
clear;
load('stress_2by2_9.txt');
A = stress_2by2_9;
linklength = max(A(:,1));
datalength = length(A);
timesteps = datalength/linklength;

stress_data_2by2_9 = zeros(linklength,timesteps);
for index1 = 1:timesteps
    for index2 = 1:linklength
        stress_data_2by2_9(index2, index1) = A( ( index1 - 1 )*linklength + index2 ,2);  
    end
end
save('stress_data_2by2_9');


    