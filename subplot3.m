%Note: Still needs some work

function plots = subplot3(images,file_num)

for 1:file_num
    if rem(y, 3) == 1
    figure(y)
    end
   for w = 1:3
    subplot(1,3,w)
    imshow(roi{y})
   
end


