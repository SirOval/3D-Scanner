%Norm---NOT USED CURRENTLY
function [mp_norm1, mp_norm2] = norm_feat(matchedPoints1,matchPoints2,v,s)

  norm_temp = norm(matchedPoints2.Location - matchedPoints1.Location);
   if  (norm_temp > 100 && norm_temp < 150)
    
    mp_norm1 = matchedPoints1(v); 
    mp_norm2 = matchedPoints2(v); 
    s = s+1;
    
   end
end
