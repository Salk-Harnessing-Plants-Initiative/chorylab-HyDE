function [movobj] = process_movie(directory, step, timevector, id, pixelspermm)
  D=dir(directory);
  num_frames = length(1:step:length(D));
  num_expected_frames = length(timevector);
  lengths = NaN(num_frames,1);
  movie = [];
  framenum = 1;
  prevtp = 0;
  maxconsecnan = 0;
  tmpmaxconsecnan = 0;
  %cycle through each frame
  if(num_expected_frames ~= num_frames)
    movobj = NaN;
    return;
  end
  for i=1:step:length(D);
    %Store image data
    raw=imread(D(i).name);
    frameobj = frame(raw);
    raw_frames((i+(step-1))/step) = frameobj;
  end
  myEx = 0;
  for i=1:num_frames
    raw = raw_frames(i).raw_image;
    binary = raw_frames(i).EDT_image;
    %get midline data, if a reliable termination point can be determined
    [midline, tp] = get_midline(binary, prevtp);
    if(prevtp == 0 && ~isnan(tp)) %if this is the first frame, initialize tp and prevtp
      prevtp = tp;
    elseif(abs(prevtp-tp) <= 10) %if the previous tp is less than 5 pixles away from the current tp, assign
      prevtp = tp;
      if(tmpmaxconsecnan > maxconsecnan) maxconsecnan = tmpmaxconsecnan; end;
      tmpmaxconsecnan = 0;
    else %if the tp jumps more than 5 pixels, ignore
      tmpmaxconsecnan = tmpmaxconsecnan + 1;
      continue;
    end
    
    %get the pixel interval, find the midline length, and draw a red line
    %on the image
    midline_curve = polyfit(1:length(midline),midline(1:length(midline)), 4);
    midline_length = get_length(midline_curve,[1,length(midline)],.1);
    disp([i,midline_length]);
    processed_image = draw_curve(raw, midline_curve,[1,length(midline)]);
    imshow(processed_image);
    drawnow();
    if(i==1)
        try
            movie = zeros(size(raw,1),size(raw,2),3,length(1:step:length(D)));
        catch myEx
            disp(myEx.message);
        end
        if(myEx)
            return;
        end
    end
    movie(:,:,:,framenum) = processed_image;
    framenum = framenum + 1;
    lengths(i) = midline_length;
  end
  if(tmpmaxconsecnan > maxconsecnan) maxconsecnan = tmpmaxconsecnan; end;
  if(maxconsecnan >= 10)
    movobj = 0;
    return;
  end;
  movie = immovie(movie);
  raw_data = lengths(1:num_frames);
  movobj = hypocotylmovie(raw_data.', pixelspermm, timevector, movie, id,'spline');
end