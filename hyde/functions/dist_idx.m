function [d] = dist_idx(p1,p2,imsize)
  if(size(p1,2) > size(p1,1))
      p1 = p1';
  end
  if(size(p2,2) > size(p2,1))
      p2 = p2';
  end
  [p1x,p1y] = ind2sub(imsize,p1);
  [p2x,p2y] = ind2sub(imsize,p2);
  p1 = [p1x,p1y];
  p2 = [p2x,p2y];
  d = dist(p1,p2);
end