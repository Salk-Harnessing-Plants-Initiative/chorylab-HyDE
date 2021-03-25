function [new_image] = preprocess_image(old_image)
  threshold = graythresh(old_image);
  new_image=im2bw(old_image, threshold);
  new_image = bwdist(new_image,'euclidean');
  new_image = imrotate(new_image,180);
end