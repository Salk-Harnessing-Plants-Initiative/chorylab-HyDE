function [mp] = revise_midpoint(p,E)
  imsize = size(E);
  [px,py] = ind2sub(imsize,p);
  [Ex,Ey] = ind2sub(imsize,find(E==1));
  D = sqrt(((Ex-px).^2)+((Ey-py).^2));
  [~,Eminidx] = min(D);
  E1x = Ex(Eminidx);
  E1y = Ey(Eminidx);
  v1 = [repmat(E1x-px,length(Ex),1),repmat(E1y-py,length(Ey),1)];
  v2 = [Ex-px,Ey-py];
  dp = dot(v1,v2,2);
  D(dp > 0) = NaN;
  [~,Eminidx] = min(D);
  E2x = Ex(Eminidx);
  E2y = Ey(Eminidx);
  mp = sub2ind(imsize,round((E1x+E2x)/2),round((E1y+E2y)/2));
end