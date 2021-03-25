function [peaks,locations] = getpeaks(vector)
%%Finds all peaks in vector
  peaks = [];
  locations = [];
  for i=2:length(vector)-1
    if(vector(i-1) < vector(i) && vector(i) >= vector(i+1))
      peaks = [peaks,vector(i)];
      locations = [locations,i];
    elseif(vector(i-1) <= vector(i) && vector(i) > vector(i+1))
      peaks = [peaks,vector(i)];
      locations = [locations,i];
    end
  end;
end