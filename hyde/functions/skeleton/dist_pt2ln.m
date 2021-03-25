function [d] = dist_pt2ln(p1,p2,p3)
  v1 = p2-p1;
  v2 = p3-p1;
  d1 = abs(dot(v1,v2)/norm(v1));
  d2 = dist(p2,p3);
  d = sqrt((d2^2)-(d1^2));
end