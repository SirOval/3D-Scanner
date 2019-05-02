%Reformats depth matrix into voxel based formating

function voxel = depth2vox(depth)

max = depth(1,1);
min = depth(1,1);
for x = 1:size(depth,1)
    for y = 1:3
        
        if(depth(x,y) > max)
            max = depth(x,y);
        end
        if (depth(x,y) < min)
            min = depth(x,y);
        end
        
    end
end

max_r = int16(round((max*1.25/4)-(min*0.75/4));
voxel = zeros(max_r,max_r,max_r,'int16');
neg_count = 0;
for index = 1:size(depth,1)

    xx = int16(round((depth(index,1)-min)/4));
    yy = int16(round((depth(index,2)-min)/4));
    zz = int16(round((depth(index,3)-min)/4));
    
    if(zz == 0)
        zz =1;
    end
    if(zz < 0)
        zz =1;
        neg_count = neg_count +1;
    end
    voxel(xx,yy,zz) = 1;
end
end