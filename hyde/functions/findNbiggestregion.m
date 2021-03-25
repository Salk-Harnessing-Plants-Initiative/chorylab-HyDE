function [Io] = findNbiggestregion(I,n)
  CC = bwconncomp(I);
  biggest = zeros(n,2);
  for i=1:length(CC.PixelIdxList)
      l = length(cell2mat(CC.PixelIdxList(i)));
      [m,midx] = min(biggest(:,1));
      if(l > m)
          biggest(midx,1) = l;
          biggest(midx,2) = i;
      end
  end
  Io = zeros(size(I));
  for i=1:n
      Io(cell2mat(CC.PixelIdxList(biggest(i,2)))) = 1;
  end
end