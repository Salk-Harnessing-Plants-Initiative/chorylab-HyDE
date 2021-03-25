function [interval] = get_midline_interval(smoothedmidline)
  pseudocount = 0.25;
  if(length(smoothedmidline) <= 15)
    interval = NaN;
    return;
  end
  
  xbar = mean(smoothedmidline(1:15));
  xsigma = std(smoothedmidline(1:15)) + pseudocount;
  for i=1:length(smoothedmidline)
    if(smoothedmidline(i)-xbar > 5*xsigma)
      for j=i:length(smoothedmidline)
        incline = smoothedmidline(j)-smoothedmidline(j-1);
        if(incline < 0)
          plot(smoothedmidline(1:j-1));
          interval = [1,j-1];
          return;
        end
      end
      interval = [1,length(smoothedmidline)];
      return;
    end
  end
  interval = NaN;
end