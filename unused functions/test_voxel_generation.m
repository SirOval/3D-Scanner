%Test Voxel Generation 


num = 7;
min=2;
max=5;

voxel = zeros(6,6,6);

for x=1:num
    for y=1:num 
        for z = 1:num
            if((min<=x) && (x<max))
                if((min<=y) && (y<=max))
                    if((min<=z) && (z<=max))
               
                voxel(x,y,z) = 1;
                    end
                end
            
            end
        end
    end
end
% %%
% voxel2 = zeros(216,3);
% 
% for x = 1:216
%     voxel2(x,:) = [
% 
% 
% 
% 

%%
scatter3(voxel(:,1,1),voxel(1,:,1),voxel(1,1,:));
                
                
                
                
      