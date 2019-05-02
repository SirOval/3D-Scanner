%Background Removal Function

function roi = background_removal(dataset_in,x_in,back_color)    

if(back_color == 'w')
    back = 1;
   % polarity = 'dark';
else
    back = 0;
    %polarity = 'bright';
end
    
%Structuring element for image opening is generated (initialized outside of
%loop to prevent re-initialization on each run through
%se1 = strel('octagon',30);
roi = cell(1,(x_in));
%Loop runs the background removal function on each image in the dataset
for y = 1:(x_in)
test = dataset_in{y};

%Image converted to grayscale, binazrized, colors are inverted, structuring
%element is used to open, hole filling occurs, and pixel areas ># are
%opened 
test_gray = rgb2gray(test);
test_bin = imbinarize(test_gray,'global');
%dddd
if(back)
    test_diff = ones(size(test_bin))-test_bin;
else
test_diff = test_bin;
end

%test_open = imopen(test_diff, se1);
test_fill = imfill(test_diff);
test_open2 = bwareaopen(test_fill, 10000);

%Generate the color image from the separated foreground

test_color(:,:,1) = uint8(test_open2).*test(:,:,1);
test_color(:,:,2) = uint8(test_open2).*test(:,:,2);
test_color(:,:,3) = uint8(test_open2).*test(:,:,3);

roi{y} = test_color;

end
end

