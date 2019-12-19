%Read in dataset images
% Input Arguments:
%     -direc = folder directory of dataset
%     -folder_directory = folder directory with image descriptor 
%     -index1 = x + #. # is the index number of the first image in the dataset. 
%     Images are read in by incrementing the index and concatenating it into the
%     folder directory
% Output Arguments:
%     -dataset = The image dataset stored in cells
%     -file_num = The number of files in the dataset

function [dataset,file_num] = data_in(direc,folder_directory,index1)

%Gets the # of images in the dataset, and sets the size of the dataset
%variable. Doing this ahead of time saves time/reduces processing. Assumes
%that only images from the dataset are in the directory folder
a=dir([direc '/*.jpg']);
dataset=cell(1,size(a,1));

%Reads in each image and puts it into the dataset variable (cell). If there is no
%image at an index, the loop breaks/ends
for x =1:1000
    capture_temp = sprintf(folder_directory,x+index1);
    if exist(capture_temp,'file') == 0
        file_num = x-1;
        break
    else
        dataset{x} = imread(capture_temp);
    end
end




