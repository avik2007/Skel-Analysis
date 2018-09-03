%% ----------------- generateInpTruncBulk -------------------------
% Avik Mondal
% 
% Aim:
% - this function takes the processed graphs of VOI's and converts them
% into ABAQUS input files. It stores them in a folder (currently predefined
% by the function, but future updates could include this as a parameter) on
% the hard drive. It also generates a new set of node and link structs
% (node_trunc/link_trunc)that match up with the input file's node and link
% labels. These also get stored in a predefined folder 
% Parameters:   
% 
% char voiname - the name of the voi you want to turn into an inputfile
%
% for generalization, varargins can be added and a user can also insert the
% folders where they want to store the TRUNCS and the INPS
%--------------------------------------------------------------------------
function generateInpTruncBulk(voiname)


res = 0.037; % resolution (mm)
graph_storage_folder = 'C:\Users\Avik Mondal\Documents\Carlson Lab\Bone Project Data\VOI_bulk_graph_analysis\Bulk_Graph_Analysis_GRAPHS\';
load(horzcat(graph_storage_folder,voiname,'.mat'));
nodet = struct2table(node);
linkt = struct2table(link);
nodemat = [(1:height(nodet))', res*nodet.comx, res*nodet.comy, res*nodet.comz];
nodemat = sortrows(nodemat,4);
nodemat = [(1:length(nodemat))',nodemat];

maxthicknesses = cellfun(@max,linkt.thicknesses);
% sort tables and remap nodes
linkmat = [(1:height(linkt))',linkt.n1,linkt.n2];
linkmat = double(linkmat);
linkmat = [linkmat,res*linkt.avgthickness,res*maxthicknesses];

map = containers.Map(nodemat(:,2)',nodemat(:,1)');
startNodes = arrayfun(@(x) map(x), linkmat(:,2));
endNodes = arrayfun(@(x) map(x), linkmat(:,3));
linkmat(:,2:3) = [startNodes endNodes];
nodemat(:,2) = [];


bottomNodes = find(nodemat(:,4) <= (min(nodemat(:,4))+0.1));
topNodes = find(nodemat(:,4) >= (max(nodemat(:,4))));

node_trunc = struct([]);
for index = 1:length(nodemat)
    node_trunc(index).comx = nodemat(index,2)/res;
    node_trunc(index).comy = nodemat(index,3)/res;
    node_trunc(index).comz = nodemat(index,4)/res;
    node_trunc(index).conn = [];
    node_trunc(index).links = [];
end

link_trunc = struct([]);
for index = 1:length(linkmat)
    link_trunc(index).n1 = linkmat(index,2);
    link_trunc(index).n2 = linkmat(index,3);
    link_trunc(index).avgthickness = linkmat(index,4)/res;
end
clear index;

%% Create .inp file

%fid = fopen('~/Dropbox/abaqus/VOI_701x101y_lslice_split9_test.inp','w');
inp_storage_folder = 'C:\Users\Avik Mondal\Documents\Carlson Lab\Bone Project Data\VOI_bulk_graph_analysis\Bulk_Graph_Analysis_ABAQUS_INP\';
fid = fopen(horzcat(inp_storage_folder,voiname, '.inp'),'w');
% first add the heading
fprintf(fid,'*Heading\nUnits: millimetres(mm)\n');

%% Part: Bone Part
% print main bone part
fprintf(fid,'**\n** PARTS\n**\n*Part, name=BONE-PART\n');

% then list the nodes using coordinates from the table
fprintf(fid,'*NODE\n');
fprintf(fid,'%i,%f,%f,%f\n',nodemat');

% then list the elements (links) using coordinates from the table
fprintf(fid,'*Element, type=B31\n');
fprintf(fid,'%i,%i,%i\n',linkmat(:,1:3)');

link_vectors = [nodemat(linkmat(:,3),2) - nodemat(linkmat(:,2),2), ...
    nodemat(linkmat(:,3),3) - nodemat(linkmat(:,2),3), ...
    nodemat(linkmat(:,3),4) - nodemat(linkmat(:,2),4)];
link_mag = sqrt(link_vectors(:,1).^2+link_vectors(:,2).^2+link_vectors(:,3).^2);
normals = [ones(length(link_vectors),1), ones(length(link_vectors),1), (zeros(length(link_vectors),1) - link_vectors(:,1) - link_vectors(:,2))./link_vectors(:,3)];
temp = find(link_vectors(:,3)==0);
normals(temp,3) = 1;
normals(temp,2) = (zeros(length(temp),1) - link_vectors(temp,1) - link_vectors(temp,3))./link_vectors(temp,2);
temp = find(normals(:,3)==-Inf | normals(:,3)==Inf);
normals(temp,3) = 1;
normals(temp,1) = (zeros(length(temp),1) - link_vectors(temp,2) - link_vectors(temp,3))./link_vectors(temp,1);
temp = find(normals(:,2)==-Inf | normals(:,2)==Inf);
normals(temp,2) = 1;
normals(temp,1) = (zeros(length(temp),1) - link_vectors(temp,2) - link_vectors(temp,3))./link_vectors(temp,1);
normals = normals./[link_mag link_mag link_mag];

% then define one element set for each link, because each link has a
% different thickness
for k = 1:length(linkmat)
    elsetName = ['link' num2str(k)];
    fprintf(fid,['*Elset, elset=' elsetName ', internal, generate\n '...
        ' ' num2str(k) ', ' num2str(k) '\n']);
    fprintf(fid,['** Section: Section-' num2str(k) ' Profile: Profile-' num2str(k) '\n*Beam Section, elset=' ...
        elsetName ', material=Material-1, temperature=GRADIENTS, POISSON=0.16, section=CIRC\n' ...
        num2str(linkmat(k,4)/2) '\n' ...
        num2str(normals(k,1)) ',' num2str(normals(k,2)) ',' num2str(normals(k,3)) '\n']);
end

fprintf(fid,'*Nset, nset=allnodes, generate\n');
fprintf(fid,['1, ' num2str(size(nodemat,1)) ', 1\n']);
fprintf(fid,'*Nset, nset=topnodes, generate\n');
fprintf(fid,[num2str(min(topNodes)) ', ' num2str(max(topNodes)) ', 1\n']);
fprintf(fid,'*Nset, nset=bottomnodes, generate\n');
fprintf(fid,[num2str(min(bottomNodes)) ', ' num2str(max(bottomNodes)) ', 1\n']);
fprintf(fid,'*Elset, elset=all-elem, generate\n');
fprintf(fid,['1, ' num2str(size(linkmat,1)) ', 1\n']);
fprintf(fid,'*End Part\n');


%% Assembly
fprintf(fid,['**\n** ASSEMBLY\n**\n*Assembly, name=Assembly\n**\n' ...
    '*Instance, name=BONE-PART-1, part=BONE-PART\n*End Instance\n**\n' ...
    '*End Instance\n**\n']);
fprintf(fid,'*End Assembly\n');
%% Amplitude
% print amplitude for displacement
fprintf(fid,'*Amplitude, name=AMP-1\n 0., 0., 1., 1.\n');
%% Materials
% print materials
fprintf(fid,'**\n** MATERIALS\n**\n');
% material with young's modulus and poisson ratio
fprintf(fid,'*Material, name=MATERIAL-1\n');
fprintf(fid,'*Elastic\n10000., 0.16\n');
%% Boundary Conditions
% print boundary conditions
fprintf(fid,'**\n** BOUNDARY CONDITIONS\n**\n');
fprintf(fid,'** Name:Bottom-BC Type: Symmetry/Antisymmetry/Encastre\n');
fprintf(fid,'*Boundary\n');
fprintf(fid,'BONE-PART-1.bottomnodes, ENCASTRE\n');
fprintf(fid,'** Name:Disp-BC-3 Type: Displacement/Rotation\n');
fprintf(fid,'*Boundary\n');
fprintf(fid,'BONE-PART-1.topnodes, 1, 1\n');
fprintf(fid,'BONE-PART-1.topnodes, 2, 2\n');
fprintf(fid,'BONE-PART-1.topnodes, 4, 4\n');
fprintf(fid,'BONE-PART-1.topnodes, 5, 5\n');
fprintf(fid,'BONE-PART-1.topnodes, 6, 6\n');

%% Step
fprintf(fid,'** -----------------------------------------------\n**\n');
fprintf(fid,'** STEP: displace-top\n**\n*Step, name=displace-top, nlgeom=NO\n');
fprintf(fid,'*Static\n');%, stabilize=0.0002, allsdtol=0.05, continue=NO\n');
fprintf(fid,'0.05,1.,0.,\n');
fprintf(fid,'**\n** BOUNDARY CONDITIONS\n**\n');
fprintf(fid,'** Name: Disp-down Type: Displacement/Rotation\n');
fprintf(fid,'*Boundary, amplitude=AMP-1\n');
fprintf(fid,'BONE-PART-1.topnodes, 3, 3, -1.\n');
fprintf(fid,'**\n** OUTPUT REQUESTS\n**\n');
fprintf(fid,'*Restart, write, number interval=1, time marks=NO\n');
% fprintf(fid,'**\n** FIELD OUTPUT: F-Output-1\n**\n');
% fprintf(fid,'*Output, field, time interval=0.01\n');
% fprintf(fid,'*Node Output\n A, RF, U, V\n');
fprintf(fid,'*Output, field, time interval=0.01\n');
fprintf(fid,'**\n** FIELD OUTPUT; F-Output-1\n**\n');
fprintf(fid,'*Element Output, directions=YES\nE,S\n');
fprintf(fid,'**\n** HISTORY OUTPUT: H-Output-1\n**\n');
fprintf(fid,'*Output, history, time interval=0.01\n');
fprintf(fid,'*Node Output, nset=BONE-PART-1.allnodes\n');
fprintf(fid,'RF1, RF2, RF3, U1, U2, U3\n');
fprintf(fid,'*End Step');


fclose(fid);

clearvars -except node_trunc link_trunc voiname
%trunc_storage_folder = 'C:\Users\Avik Mondal\Documents\Carlson Lab\Bone Project Data\VOI_bulk_graph_analysis\Bulk_Graph_Analysis_TRUNC_GRAPHS\TRUNC';
trunc_2by2_folder = 'C:\Users\Avik Mondal\Documents\Carlson Lab\Bone Project Data\VOI_bulk_graph_analysis\Bulk_Graph_Analysis_TRUNC_GRAPHS\2by2_truncs\TRUNC';
%save(horzcat(trunc_storage_folder, voiname));
save(horzcat(trunc_2by2_folder,voiname));