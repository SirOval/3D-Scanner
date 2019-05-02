%Background Removal Function

function roi = backg_new(dataset_in,x_in,back_color)
if(back_color == 'w')
    back = 1;
else
    %Assumes background color is black
    back = 0;
end
    
%Structuring element for image opening is generated (initialized outside of
%loop to prevent re-initialization on each run through
%se1 = strel('octagon',30);
roi = cell(1,(x_in));
%Loop runs the background removal function on each image in the dataset
for ind = 1:x_in
test = dataset_in{ind};

%Image converted to grayscale, binazrized, colors are inverted, structuring
%element is used to open, hole filling occurs, and pixel areas ># are
%opened 
test_gray = rgb2gray(test);

test_bin = imbinarize(test_gray,'global');

if(back)
    test_diff = ones(size(test_bin))-test_bin;
else
test_diff = test_bin;
end
%Image resized to be 1/4 the size to speed up processing
test_resize = imresize(test_diff,0.25);


%test_open = imopen(test_diff, se1);
%Fills holes and gets rid of objects consisting of 2500 pixels or less
test_fill = imfill(test_resize);
test_open2 = bwareaopen(test_fill, 2500);

%Finds all nonzero element locations, forms a boundary from them, and
%generates a mask of 1's inside the boundary
[y,x] = find(test_open2);
K = boundary(x, y);
boundary_x = x(K);
boundary_y = y(K);
mask = poly2mask(boundary_x, boundary_y, size(test_open2,1), size(test_open2,2) );
%Image resized back to original size
mask_resize = imresize(mask,4);

%Generate the color image from the separated foreground
test_color(:,:,1) = uint8(mask_resize).*test(:,:,1);
test_color(:,:,2) = uint8(mask_resize).*test(:,:,2);
test_color(:,:,3) = uint8(mask_resize).*test(:,:,3);

roi{ind} = test_color;

end
end






