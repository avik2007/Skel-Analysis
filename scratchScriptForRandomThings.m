%% Creating the sample adjacency matrix for thesis project

a = [0 1 0 0 0 1; 1 0 0 0 0 1; 0 0 0 0 0 1; 0 0 0 0 1 1; 0 0 0 1 0 1; 1 1 1 1 1 0];
imagesc(a);
xticks([0.5 1.5 2.5 3.5 4.5 5.5 6.5]);
yticks([0.5 1.5 2.5 3.5 4.5 5.5 6.5]);
grid on;

%%
for index1 = 1:size(VOI,3)
    A = VOI(:,:,index1);
    imwrite(A, horzcat('C:\Users\Avik Mondal\Documents\Carlson Lab\Bone Project Data\Pipeline_Sample_Slices\im',int2str(index1),'.bmp'));
end