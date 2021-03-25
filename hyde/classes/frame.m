classdef frame
  
  properties
    raw_image;
    EDT_image;
    width;
    length;
  end
  
  methods
    function fr=frame(raw_image)
      fr.raw_image = raw_image;
      fr.EDT_image = preprocess_image(raw_image);
      fr.length = size(raw_image,1);
      fr.width = size(raw_image,2);
    end
  end
end