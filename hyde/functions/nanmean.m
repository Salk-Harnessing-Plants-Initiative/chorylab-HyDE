function [average] = nanmean(vector)
newvector = vector(~isnan(vector));
average = mean(newvector);
end

