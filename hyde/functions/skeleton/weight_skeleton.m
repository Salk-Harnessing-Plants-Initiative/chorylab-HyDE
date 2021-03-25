function [m] = weight_skeleton(s,bpemat)
%%returns weighted connectivity matrix, given edt-valued skeleton and edge 
%%matrix containing cell arrays with pixels connecting nodes.


n = numel(bpemat);
  m = zeros(size(bpemat));
  for i=1:n
      p = cell2mat(bpemat(i));
      m(i) = sum(s(p));
  end
end