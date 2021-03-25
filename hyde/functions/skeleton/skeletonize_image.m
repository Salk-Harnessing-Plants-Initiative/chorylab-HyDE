function [s] = skeletonize_image(I)
    buff=50;
    threshold = graythresh(I);
    bw=1-im2bw(I, threshold);
%   new_image=imfill(new_image);
    bw = imrotate(bw,180);
    CC = bwconncomp(bw);
    source = sub2ind(size(I),1,round(size(I,2)/2));
    if(CC.NumObjects > 1)
        mindist = size(I,2);
        objid = 0;
        for i=1:CC.NumObjects
            testdist = min(dist_idx(source,cell2mat(CC.PixelIdxList(i)),size(I)));
            if(testdist < mindist)
                mindist = testdist;
                objid = i;
            end
        end
        CC.PixelIdxList = CC.PixelIdxList(objid);
        bw = cc2im(CC);
    end
    y=zeros(size(bw,1)+buff,size(bw,2));
    y(buff+1:size(bw,1)+buff,1:size(bw,2)) = bw;
    y(1:buff+1,:) = repmat(bw(1,:),buff+1,1);
    y = bwmorph(y,'close',Inf);
    s = skeleton(y)>35;
    s = bwmorph(s,'thin','Inf');
    s=s(buff+1:size(s,1),1:size(s,2));
end