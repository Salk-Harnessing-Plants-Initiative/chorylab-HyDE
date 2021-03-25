function [hypocotyl_midpoints, tp] = get_midline(seedling_image, prevtp,method)
%returns midline coordinate vector along the height of the image.
%-1 is returned for each y value that does not correspond to a midline
%point.
if(strcmp(method,'slice'))
    height=size(seedling_image,1);
    width = size(seedling_image,2);
    previousmidpoint = 0;
    hypocotyl_midpoints = NaN(1,height);
    hypocotyl_distances = NaN(1,height);
    for i=1:height
        [distances,midpoints] = getpeaks(seedling_image(i,:));
        if(i==1)
            previousmidpoint = width/2;
        end
        horiz_distance = abs(midpoints - previousmidpoint);
        [~,testmidpointidx] = min(horiz_distance);
        testmidpoint = midpoints(testmidpointidx);
        if(isempty(testmidpoint) || ~testmidpoint)
            break;
        else
            hypocotyl_midpoints(i) = testmidpoint;
            hypocotyl_distances(i) = distances(testmidpointidx);
            previousmidpoint = testmidpoint;
        end
    end
    smooth_dist = smooth(hypocotyl_distances,7);
    int = get_midline_interval(smooth_dist);
    %if any stretch of the same value occur, remove all but the last
    if(~isnan(int))
        %    termination_point = get_tp(hypocotyl_distances,int,prevtp);
        termination_point = get_tp(smooth_dist,int,prevtp);
        if(isnan(termination_point)) tp=NaN; hypocotyl_midpoints = NaN; return; end;
        hypocotyl_midpoints = hypocotyl_midpoints(int(1):termination_point);
        tp = termination_point;
    else
        hypocotyl_midpoints = NaN;
        tp = NaN;
    end;
elseif(strcmp(method,'skeleton'))
    I = seedling_image;
    imsize = size(I);
    hypocotyl_midpoints = segment_image(I);
    if(isempty(hypocotyl_midpoints))
        hypocotyl_midpoints = NaN;
        tp = NaN;
    else
        tp = hypocotyl_midpoints(end);
    end
else
    hypocotyl_midpoints = NaN;
    tp = NaN;
end
end
