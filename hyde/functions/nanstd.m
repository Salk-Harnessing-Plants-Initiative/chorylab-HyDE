function [stdeviation] = nanstd(vector)
  newvector = vector(~isnan(vector));
  stdeviation = std(newvector);
end