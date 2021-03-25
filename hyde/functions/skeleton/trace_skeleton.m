function [m] = trace_skeleton(s,p,varargin)
%%Returns the n pixels from tracing a skeleton image, s, starting from
%%point, p (index).
  if(isempty(varargin))
      n = sum(sum(s));
  else
      n = cell2mat(varargin(1));
  end
  D1 = bwdistgeodesic(s,p);
  idx = find(~isnan(D1));
  pts = D1(idx);
  [~,sorted] = sort(pts);
  idx = idx(sorted);
  m = idx(1:n);
end