%script to handle odb link stress data (super large data sets)

%needs the csv in the workspace
%{
%link_stress_VOI_701x101y_split12; %1/28/2018 data
linklength = link_stress_VOI_701x101y_split12(length(link_stress_VOI_701x101y_split12),1);
datalength = length(link_stress_VOI_701x101y_split12);
%}

%link_stress_VOI_701x101y_split9_new; %1/29/2018 data
linklength = link_stress_VOI_701x101y_split9_new(length(link_stress_VOI_701x101y_split9_new),1);
datalength = length(link_stress_VOI_701x101y_split9_new);

%vvvvv insert the new split data
timesteps = datalength/linklength;
stress_data = zeros(linklength,timesteps);
for index1 = 1:timesteps
    for index2 = 1:linklength
        stress_data(index2, index1) = link_stress_VOI_701x101y_split9_new( ( index1 - 1 )*linklength + index2 ,2);  
    end
end


    