function [curvelength] = get_length(curve, interval, precision)
  %calculates length of polynomial, curve, over an interval [start,end],
  %with specified precision.
  x=interval(1):precision:interval(2);
  points = polyval(curve, x);
  distance = 1;
  for i=2:length(points)
    p1=[interval(1)+(i-1)*precision, points(i)];
    p2=[interval(1)+(i-2)*precision, points(i-1)];
    distance = distance + dist(p1, p2);
  end
  curvelength = distance;
end