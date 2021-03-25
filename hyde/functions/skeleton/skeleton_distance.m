function [d,e] = skeleton_distance(s,p1,p2)
   D1 = bwdistgeodesic(s,p1,'quasi-euclidean');
   D2 = bwdistgeodesic(s,p2,'quasi-euclidean');
   D = D1+D2;
   D = round(D*8)/8;
   D(isnan(D)) = inf;
   e = find(imregionalmin(D)==1);
   [~,idx] = sort(D1(e));
   e = {e(idx)};
   d = length(cell2mat(e));
end