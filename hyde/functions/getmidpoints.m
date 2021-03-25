function [midpointvector] = getmidpoints(imagevector)
  regstart=0;
  regend=0;
  numregions=0;
  midpointvector={};
  for i=2:length(imagevector);
    if(imagevector(i)>imagevector(i-1))
      prevpixel=fpix;
      regstart=i;
    end;
    if(prevpixel==fpix && imagevector(i)==bpix)
      prevpixel=bpix;
      regend=i-1;
      numregions=numregions+1;
      midpointvector = [midpointvector,region(regstart,regend)];
    end
  end;
  return;
end