function [sv] = smooth(v,pts)
  pts = pts - 1;
  sv = zeros(1,length(v)-pts);
  for i=1:length(v)-pts
     sv(i) = mean(v(i:i+pts));
     if(isnan(sv(i)))
         x=1;
     end
  end
end