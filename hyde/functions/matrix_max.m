function [a,b] = matrix_max(m)
  %%Given a 2D matrix, m, returns the maximum value, a, and the coordinates,
  %%b.
  
  [a,idx] = max(m(:));
  [b(1),b(2)] = ind2sub(size(m),idx);
end