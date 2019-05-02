%test file
clc;
clear all;

for z = 1:3
%Loop runs the background removal function on each image in the dataset
test1 = imread(sprintf('shopping cart white background\\s%d.jpg',z));

%Image converted to grayscale, binazrized, colors are inverted, structuring
%element is used to open, hole filling occurs, and pixel areas ># are
%opened 
test_gray = rgb2gray(test1);
test_bin = imbinarize(test_gray);
test_diff = ones(size(test_bin))-test_bin;

test_fill = imfill(test_diff);

test_open2 = bwareaopen(test_fill, 10000);

%Generate the color image from the separated foreground

test_color(:,:,1) = uint8(test_open2).*test1(:,:,1);
test_color(:,:,2) = uint8(test_open2).*test1(:,:,2);
test_color(:,:,3) = uint8(test_open2).*test1(:,:,3);

%figure(z), imshow(test_color);
testt{z} = test_color;
end

%%
% Feature Matching
s1 = rgb2gray(testt{1});
s2 = rgb2gray(testt{2});

s1_surf = detectSURFFeatures(s1);
s2_surf = detectSURFFeatures(s2);


[s1_features,s1_valid_points] = extractFeatures(s1,s1_surf);
[s2_features,s2_valid_points] = extractFeatures(s2,s2_surf);
 
% figure(11); imshow(s1); hold on;
% plot(s1_valid_points.selectStrongest(100));
%  figure(12); imshow(s2); hold on;
%  plot(s2_valid_points.selectStrongest(100));

% s1_binFeat= binaryFeatures(uint8(s1_features));
% s2_binFeat= binaryFeatures(uint8(s2_features));

indexPairs = matchFeatures(s1_features,s2_features, 'Unique',true);

matchedPoints1 = s1_valid_points(indexPairs(:,1));
matchedPoints2 = s2_valid_points(indexPairs(:,2));
%%
newObject1 = [];
newObject2=[];
loop = size(matchedPoints1);
s=1;
min = 120;
max = 170;
scale_thresh = 2; %Note: Minimum scale allowed is 1.6
strength =5000;
for v = 1:loop(1)
    %Calculates the distance between the 2 feature points
  norm_temp = norm(matchedPoints2.Location(v,:) - matchedPoints1.Location(v,:));
  %Distance between matches tuning 
  if  (norm_temp > min && norm_temp < max)
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
mp_select1 = matchedPoints1(newObject1);
mp_select2 = matchedPoints2(newObject2);
%%

% figure; showMatchedFeatures(testt{1},testt{2},mp_select1,mp_select2);
% legend('matched points 1','matched points 2');

%%

%Depth Mapping and Structure Estimation

%%
figure(12); imshow(roi{27}); hold on;
plot(features{27,2}.selectStrongest(100));














