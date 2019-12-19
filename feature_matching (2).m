%Feature matching
%This function generates and matches the features between adjacent input images
%INPUT ARGUMENTS:
%     -roi_in = Dataset with backgrounds removed. roi=region of interest.
%     -file_num = number of images in roi_in
%     -bounds = [min,max]. The lower and upper limits for the distance between 2 matched
%     features. Recommened: [100,200] or less. Varies by application
%     -scale_thresh = The minimum scale of matched features. The minimum allowed is 1.6.
%     -strength = The minimum strength allowed for a matched feature pair
% OUTPUT ARGUMENTS:
%     -mpselect(x) = [mpselect1(x),mpselect2(x)]. Each row in this cell
%     array contains the tuned matched feature points for an image and the
%     one that follows it in the dataset. So, row 1 contains the matched
%     features between image 1 and 2, row 2 contains matched images 2 and
%     3, etc etc. This is a file_num x 2 cell array. Note: mpselect =
%     matched point select
%     -features = [feature, valid points]. The SURF feature and feature
%       points for each image. This is a file_num x 2 cell array


function [mpselect,features] = feature_matching(roi_in,file_num,bounds,scale_thresh,strength)

mpselect = cell(file_num,2);
features = cell(file_num,2);
%matchedPoints4ims = cell(file_num,2);

ind=1;
s1 = rgb2gray(roi_in{1});
s1_surf = detectSURFFeatures(s1);
[s1_features,s1_valid_points] = extractFeatures(s1,s1_surf);

for ind=2:file_num
 
    if(ind>2)
    s1_features = s2_features;
    s1_valid_points = s2_valid_points;
    end

s2 = rgb2gray(roi_in{ind});
s2_surf = detectSURFFeatures(s2);
[s2_features,s2_valid_points] = extractFeatures(s2,s2_surf);

indexPairs = matchFeatures(s1_features,s2_features, 'Unique',true);

matchedPoints1 = s1_valid_points(indexPairs(:,1),:);
matchedPoints2 = s2_valid_points(indexPairs(:,2),:);

featMatch1 = s1_features(indexPairs(:,1),:);
featMatch2 = s2_features(indexPairs(:,2),:);

newObject1 = [];
newObject2=[];
loop = size(matchedPoints1);
s=1;
for v = 1:loop(1)
    %Calculates the distance between the 2 feature points
  norm_temp = norm(matchedPoints2.Location(v,:) - matchedPoints1.Location(v,:));
  
  %Distance between matches tuning 
  if  (norm_temp > bounds(1) && norm_temp < bounds(2))
      
      %Scale of SURFpoints tuning. Assumes that the scale for corresponding
      %features is the same in adjacent images. In reality, the scale is
      %usually +/- 0.2 from the scale given in the adjacent image. This is
      %done to save some processing
      if( matchedPoints1.Scale(v)>scale_thresh)
          
          %Strength of match (metric) tuning. Ranges from 0.0 to #*(10^4)
            if (matchedPoints2.Metric(v)>strength && matchedPoints1.Metric(v)>strength)
     newObject1(s) = v; 
     newObject2(s) = v; 
       s = s+1;
            end
      end
   end
   
end
%Selects the tuned feature matches from tuning using the newObject index
mpselect{ind-1,1} = matchedPoints1(newObject1);
mpselect{ind-1,2} = matchedPoints2(newObject2);


features{ind-1,1} = featMatch1(newObject1);
features{ind-1,2} = featMatch2(newObject2);


% indexPairs4ims = matchFeatures(features{ind-1,2},features{ind+1,1}, 'Unique',true);
% 
% matchedPoints4ims{ind-1,1} = mpselect{ind-1,2}(indexPairs4ims(:,1));
% matchedPoints4ims2{ind-1,2} = mpselect{ind,1}(indexPairs4ims(:,2));
% 
end

%Code for showing feature points on a single image
% figure(11); imshow(s1); hold on;
% plot(s1_valid_points.selectStrongest(100));
%  figure(12); imshow(s2); hold on;
%  plot(s2_valid_points.selectStrongest(100));

