mpselect = cell(file_num,2);
features = cell(file_num,2);
%matchedPoints4ims = cell(file_num,2);

ind=1;
s1 = rgb2gray(roi{1});
s1_surf = detectSURFFeatures(s1);
[s1_features,s1_valid_points] = extractFeatures(s1,s1_surf);

for ind=4
%  
%     if(ind>2)
%     s1_features = s2_features;
%     s1_valid_points = s2_valid_points;
%     end

s2 = rgb2gray(roi{ind});
s2_surf = detectSURFFeatures(s2);
[s2_features,s2_valid_points] = extractFeatures(s2,s2_surf);

indexPairs = matchFeatures(s1_features,s2_features, 'Unique',true);

matchedPoints1 = s1_valid_points(indexPairs(:,1));
matchedPoints2 = s2_valid_points(indexPairs(:,2));

if (ind == 2)
featMatch1 = s1_features(indexPairs(:,1));
featMatch2 = s2_features(indexPairs(:,2));
end

if(ind == 3)
featMatch3 = s1_features(indexPairs(:,1));
featMatch4 = s2_features(indexPairs(:,2));
end

end
%%
indexPairs2 = matchFeatures(featMatch1,featMatch4);

matchedPoints3 = featMatch1(indexPairs2(:,1));
matchedPoints4 = featMatch4(indexPairs2(:,2));

%%
figure; showMatchedFeatures(s1,s2,matchedPoints1,matchedPoints2);









