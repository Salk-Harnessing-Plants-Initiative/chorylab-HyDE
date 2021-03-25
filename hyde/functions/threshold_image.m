function [Io] = threshold_image(I)
  I = medfilt2(I);
  range = [min(min(I)),max(max(I))];
  midpoint = round(mean(range));
  lowcutoff = range(1);
  flow = sum(sum(I==range(1)));
  for i=range(1):midpoint
      f = sum(sum(I==i));
      if(f > flow)
          flow = f;
          lowcutoff = i;
      end
  end
  Io = I;
%   mask = Io < lowcutoff;
%   mask = findNbiggestregion(mask,2);
%   mask = bwmorph(mask,'dilate',2);
%   Io(logical(mask)) = range(2);
%   Io(I < lowcutoff) = range(2);
%   mask = 1-im2bw(Io,graythresh(Io));
%   mask = bwmorph(mask,'erode',3);
%   mask = bwmorph(mask,'dilate',3);
%   mask = bwmorph(mask,'dilate',3);
%   mask = imfill(mask,'holes');
%   %mask = bwmorph(mask,'erode',3);
%   %mask = bwmorph(mask,'dilate',5);
%   %mask = imfill(mask,'holes');
%   %mask = bwmorph(mask,'majority');
%   Io = I;
%   Io(~mask) = range(2);
end