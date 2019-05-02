%Inverse Depth Mapping Function
%This function takes in matched feature points for the whole dataset and
%generates depth points for each one. Then the depths are assigned to their
%corresponding locations. For reference, look at Yi_Ma's book on 3D
%reconstruction in ch8.
%INPUTS:
%     -file_num = # of images in the dataset
%     -mpselect = matched feaure points between adjacent images 
%     -rot_angle = rotation angle between image captures
% OUTPUTS:
%     -alpha = depth of each matched feature point (reassigned each loop iteration
%     -depth = matrix with all matched feature point locations and corresponding depths
function [alpha,depth] = inverse_depth_mapping(file_num,mpselect,rot_angle)

    depth_size = 0;
    %depth = zeros(3000,3);
    for n = 1:file_num-1
     feat_size = mpselect{n,1}.Count;
     u_hat = cell(feat_size,1);
     v = cell(feat_size,1);
     %Define Translation Matrix
     T = [1;1;1]; 
    
     %Define Rotation Matrix
     x = rot_angle;
     rotz = [cos(x) -sin(x) 0; sin(x) cos(x) 0; 0 0 1];  %Z axis rot
     rotx = [1 0 0; 0 cos(x) -sin(x); 0 sin(x) cos(x)];  %X axis rot
     %roty = [cos(x) 0 -sin(x); 0 1 0; sin(x) 0 cos(x)];  %Y axis Rot
     
     rot = rotz*rotx;

    %Inverse Depth Map
    %Generates u_hat and v for inverse depth mapping equation
    for ii = 1:feat_size
    
        loc1 = mpselect{n,2}.Location(ii,:); 
        u_hat{ii,1} = [0 -1 loc1(1,2); 1 0 -loc1(1,1); -loc1(1,2) loc1(1,1) 0];
        
        loc2 = mpselect{n,1}.Location(ii,:); 
        v{ii,1} = [loc2(1,1); loc2(1,2); 1];
    
    end
    
    %im1
      %generates depths using equation from Muratov's paper (note, paper
      %has slight typo in it. Original reference is Yi ma ch8
    alpha = zeros(feat_size,1);
    for zz = 1:feat_size      
        alpha(zz,1) = (transpose(u_hat{zz,1}*T)*u_hat{zz,1}*rot*v{zz,1})/...
            (norm(u_hat{zz,1}*T))^2;    
    end
    
    
    %puts depth xyz points into a single matrix called depth
        for gg = 1:feat_size
            
            index = depth_size + gg;
            loc2 = mpselect{n,1}.Location(gg,:);            
            depth(index,:) = [loc2(1,1), loc2(1,2), alpha(gg,1)]; 
            
%            if(loc2(1,1) < 400)
%               depth(index,:)=[  ];
%            end
%            if(loc2(1,2) >4000)
%                 depth(index,:)=[  ];
%            end

     
            
        end
             if (n>1)
                depth_size = index;
                end
    end
    
        
end
   








