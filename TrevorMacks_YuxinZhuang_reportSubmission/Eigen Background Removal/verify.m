function ttag = verify(labels)
ttag=1;
for l=1:max(labels(:))
    limg=labels==l;
    L=bwlabel(limg);
    if max(L(:))>1
        ttag=0;
        break;
    end
end
end