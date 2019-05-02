% %3D Reconstruction 
% Explanation: 
%   This code takes in a collection of images that capture some object, and
% uses them to construct a 3D model of the object that is in the images. 
% There is a specific physical environment/setup that needs to be used to capture 
% these images, which is explained in the readme document in this folder titled 
% "Image capture specifications and setup"
%Variables:
%     -dataset = A collection of images of an object caputred in 3 degree increments at a set camera angle
%     -file_num = The number of images in the dataset
%     -roi = region of interest. Background has been removed from the images in the dataset
%     -features = Cell array containing the SURF features from each roi image
%     -mpselect = The selected (filtered) feature points that have been matched between 2 images
%     -fig = A figure plotting the matched feature points between 2 images

%To choose dataset, replace the file location in the capture_temp variable
%initialization with one of the following and set the starting IMG#:
%First input is the folder. Second is the files themselves
%Elephant dataset = elephant_dataset\\e%d.jpg
%Shopping cart dataset = shopping cart dataset\\e%d.jpg

%Choose background removal function before running code. The function will
%change depending on if there is a white background or a black one.
%addpath(genpath('functions')) -- Another option to add in directory
%Keep %d in directory name. Read function for explanation

tic
[dataset, file_num] = data_in('starRealmsD1',...
                        'starRealmsD1\\sr_dataset (%d).jpg',1);                   
disp('Dataset Input time');
toc
%%
%Note to self: look up bundle adjustment
%Remove background of the image 
tic
roi = background_removal(dataset,file_num,'w');
disp(' ');

disp('Background Removal Function Runtime:');
toc
%New background removal function below. Note: pick one
% tic
% roi = backg_new(dataset,file_num,'w');
% disp(' ');
% disp('Background Removal Function Runtime:');
% toc
%%
%SURF Feature generation and matching between adjacent images
%Check the function for a description of the output and input fields
%NOTE: Time permitting, look into grid based filtering using shi-Tomasi response
%for selecting feature points and matches
%Set the max bound based on object
tic 
[mpselect,features] = feature_matching(roi,file_num,[0,100],0,0);
disp(' ');
disp('Feature Matching Function Runtime:');
toc
%%
%Display matched feature points between 2 images
tic                                                    %5&6 has a problem
fig = show_adjacent_matched_features(roi,mpselect,1,2);
disp(' ');
disp('Matched Feature Plot Function Runtime:');
toc
%%
%Inverse Depth mapping 

[alpha,depth] = inverse_depth_mapping(file_num,mpselect,3*pi/180);

%%
% %Mesh Generation
% mask = meshg(depth);

%%

scatter3(depth(:,1),depth(:,2),depth(:,3));
%%
%Convert Depth map to Voxel

% voxel = depth2vox(depth);








