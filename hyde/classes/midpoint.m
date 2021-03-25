classdef midpoint < handle
  %UNTITLED6 Summary of this class goes here
  %   Detailed explanation goes here
  
  properties
    point = 0;
    distance = 0;
  end
  
  methods
    function mp = midpoint(point,distance)
      if(nargin > 0)
        mp.point = point;
        mp.distance = distance;
      end
    end
    function lgcal = not(mp)
      if(mp.point || mp.distance)
        lgcal=0;
      else lgcal = 1;
      end
    end
  end
end