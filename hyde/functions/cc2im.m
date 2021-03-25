function [im] = cc2im(CC)
    im = zeros(CC.ImageSize(1),CC.ImageSize(2));
    im(cell2mat(CC.PixelIdxList)) = 1; 
end