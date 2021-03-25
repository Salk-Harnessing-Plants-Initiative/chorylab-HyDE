classdef hypocotylmovie
  %UNTITLED4 Summary of this class goes here
  %   Detailed explanation goes here
  
  properties
    length_curve
    growth_curve
    method
    raw_data
    timevector
    movie
    is_defined = 0
    id = ''
  end
  
  methods
    function hm = hypocotylmovie(raw_data, pixelspermm, timevector, movie, id, method)
      if(nargin > 0)
        raw_data = raw_data/pixelspermm;
        index = 1:length(timevector);
        treatframe = index(~timevector);
        if(isempty(treatframe)) treatframe = 1; end;
        scalefactor = nanmean(raw_data(1:treatframe));
        raw_data = raw_data - scalefactor;
        y = raw_data(~isnan(raw_data));
        x = timevector(~isnan(raw_data));
        hm.method = method;
        if(strcmp(method,'polynomial'))
          hm.length_curve = polyfit(x,y,6);
          hm.growth_curve = polyder(hm.length_curve);
        elseif(strcmp(method,'spline'))
          %hm.length_curve = spap2(6,4,x,y);
          hm.length_curve = spaps(x,y,0.015);
          hm.length_curve=spap2(4,2,x,y);
          hm.growth_curve = fnder(hm.length_curve);
        end
        hm.raw_data = raw_data;
        hm.timevector = timevector;
        hm.movie = movie;
        hm.is_defined = 1;
        hm.id = id;
      end
    end
    function [hyp_length] = get_length(hm, t)
      if(strcmp(hm.method,'polynomial'))
        hyp_length = polyval(hm.length_curve,t);
      elseif(strcmp(hm.method,'spline'))
        hyp_length = fnval(hm.length_curve,t);
      end
    end
    function [growth_rate] = get_growth_rate(hm, t)
      if(strcmp(hm.method,'polynomial'))
        growth_rate = polyval(hm.growth_curve,t);
      elseif(strcmp(hm.method,'spline'))
        growth_rate = fnval(hm.growth_curve,t);
      end
    end
    function [data_matrix] = get_data(hm, varargin)
      t = hm.timevector;
      data_matrix = zeros(length(t), 4);
      for i=1:length(t)
        data_matrix(i,1) = t(i);
      if(strcmp(hm.method,'polynomial'))
        data_matrix(i,2) = polyval(hm.length_curve,t(i));
        data_matrix(i,3) = polyval(hm.growth_curve,t(i));
      elseif(strcmp(hm.method,'spline'))
        data_matrix(i,2) = fnval(hm.length_curve,t(i));
        data_matrix(i,3) = fnval(hm.growth_curve,t(i));
      end
        data_matrix(i,4) = hm.raw_data(i);
      end
    end
    function write_data(hm, filename)
      raw_data = hm.raw_data;
      csvwrite(filename,raw_data);
    end
    function write_movie(hm, filename)
      movie2avi(hm.movie,filename, 'compression', 'none');
    end
    function lgcal = not(hm)
      if(hm.is_defined == 1)
        lgcal = 0;
      else lgcal = 1;
      end
    end
    function lgcal = isnan(hm)
      if(hm.is_defined == 1)
        lgcal = 0;
      else lgcal = 1;
      end
    end
  end
end

