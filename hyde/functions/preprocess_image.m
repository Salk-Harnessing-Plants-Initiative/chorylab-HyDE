function [new_image] = preprocess_image(old_image)
  threshold = graythresh(old_image);
  new_image=im2bw(old_image, threshold);
  new_image = bwdist(new_image,'cityblock');
%  for i=1:size(new_image,1)
%    for j=1:size(new_image,2)
%      if(new_image(i,j) == 0) new_image(i,j) = 1;
%      else new_image(i,j) = 0;
%      end;
%    end;
%  end
  new_image = imrotate(new_image,180);
end