%Show Matched Features between any 2 adjacent images in the dataset
% 
% INPUT ARGUMENTS:
%     -roi = region of interest. Dataset with the background removed
%     -mpselect = returned by feature_matching() function.Contains the filtered matched
%     feature points between the 2 images
%     -im1 = The image with a lower index
%     -im2 = The image with a higher index
%       Note: im1 and im2 must be adjacent images, aka the index of im1 plus 1 should
%     equal the imdex of im2. 
% OUPUT ARGUMENTS:
%     -fig = A figure which displays the matched points between the 2 images with 
%     lines between them

function fig = show_adjacent_matched_features(roi,mpselect,im1,im2)

fig=figure; 
showMatchedFeatures(roi{im1},roi{im2},mpselect{im1,1},mpselect{im1,2});
legend('matched points 1','matched points 2');

