function tp = get_tp(hypocotyl_distances,int,prevtp)
%%Finds termination point in euclidean distance transform

  curve = polyfit((int(1):int(2)),hypocotyl_distances(int(1):int(2)),4);
  derivative = polyder(curve);
  tp = int(2);
  return;
  for i=int(2):-1:int(1)
    if(polyval(derivative,i) <= 0.13)
      tp=i;
      return;
    end
  end
  tp = NaN;
end