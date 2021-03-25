function [RGB] = draw_curve(I, x, int)
  %draws red line on image I using specified horizontal points, x, from
  %interval int(1):int(2);
  RGB = imrotate(ind2rgb(I,gray(255)),180);
  for i=int(1):int(2)
    xpixel = round(polyval(x,i));
    RGB(i,xpixel,:) = [1,0,0];
  end
  RGB = imrotate(RGB,180);
end