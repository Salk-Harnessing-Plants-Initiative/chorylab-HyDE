function [s] = dist(p1, p2)
  s=sqrt( ( (p1(:,1)-p2(:,1)).^2) + (p1(:,2)-p2(:,2)).^2);
end