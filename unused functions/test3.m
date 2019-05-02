                        
tic
[dataset, file_num] = data_in('shopping cart white background',...
                        'shopping cart white background\\s%d.jpg',0);                   
disp('Dataset Input time');
toc
%%
%Note to self: look up bundle adjustment
%Remove background of the image 
tic
roi = background_removal(dataset,file_num,'w');
%roi = background_removal_black(dataset,x);
disp(' ');
disp('Background Removal Function Runtime:');
toc

%%
%SURF Feature generation and matching between adjacent images
%Check the function for a description of the output and input fields
%NOTE: Time permitting, look into grid based filtering using shi-Tomasi response
%for selecting feature points and matches
tic 
[mpselect,features] = feature_matching(roi,file_num,[120,170],2,0);
disp(' ');
disp('Feature Matching Function Runtime:');
toc
%%

% indexPairs = matchFeatures(features{1,2},features{2,1}, 'Unique',true);
% 
% matchedPoints1 = mpselect{1,2}(indexPairs(:,1));
% matchedPoints2 = mpselect{2,1}(indexPairs(:,2));
%%

[u,v, alpha,depth] = inverse_depth_mapping(roi,file_num,mpselect,2);

%%
scatter3(depth(:,1),depth(:,2),depth(:,3));













