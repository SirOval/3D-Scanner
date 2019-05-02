%Mesh Generation

function mask = meshg(depthm)

maxx = depth(1,1);
minn = depth(1,1);
for x = 1:size(depthm,1)
    for y = 1:2
        
        depthm(x,y) = depthm(x,y) - 1000;
        if(depthm(x,y) < 0)
            depthm(x,y) = 0;
        end
        
    end
end
for x = 1:size(depthm,1)
    for y = 1:2
        
        if(depthm(x,y) > maxx)
            maxx = depthm(x,y);
        end
        if (depthm(x,y) < minn)
            minn = depthm(x,y);
        end
        
    end
end

v = ones(length(depthm(:,1)),1);
dd = double(depthm);
inter = scatteredInterpolant(dd(:,1),dd(:,2),dd(:,3),v);

[xq,yq,zq] = meshgrid(0:2:2000);
mask = inter(xq,yq,zq);

end