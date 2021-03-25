function [a] = segment_image(old_image)
%Convert raw image to binary image, skeletonize
    threshold = graythresh(old_image);
    old_image = threshold_image(old_image);
    imsize = size(old_image);
    sizex=size(old_image,2);
    
    bw=im2bw(old_image, threshold);
    bw=1-bw;
    bw = imrotate(bw,180);
    skeleton=skeletonize_image(old_image);
    
    [branchpointlist,bpcmat,bpemat,CC] = skel2graph(skeleton);
    bpcmat = weight_skeleton(skeleton.*bwdist(1-bw,'euclidean'),bpemat);
    numpoints = size(branchpointlist,1);
    if(numpoints == 1)
        a = NaN;
        return;
    end

    %Find the starting point of the hypocotyl (centermost pixel on first
    %row of the image).
    bottomcenterdist = sizex;
    idealsourcenode = [1,sizex/2];
    sourcenode = 0;
    for i=1:numpoints
        node = branchpointlist(i,:);
        testdist = dist(node,idealsourcenode);
        if(node(1)==1 && testdist < bottomcenterdist)
%        if(testdist < bottomcenterdist)
            bottomcenterdist = testdist;
            sourcenode = i;
            sourceidx = sub2ind(imsize,branchpointlist(sourcenode,1),branchpointlist(sourcenode,2));
        end
    end
    if(~sourcenode)
        a = NaN;
        return;
    end
    [~,farthest_node1] = max(bpcmat(sourcenode,:));
    longest_path_idx = sub2ind(size(bpemat),sourcenode,farthest_node1);
    longest_path_pixels = bpemat(longest_path_idx);
    bpimat = cellmat_intersection(bpemat,longest_path_pixels);
    branchpointlistidx = sub2ind(imsize,branchpointlist(:,1),branchpointlist(:,2));
    dist2path = zeros(numpoints,1);
    for i=1:numpoints
        dist2path(i) = min(dist_idx(branchpointlistidx(i),cell2mat(longest_path_pixels),imsize));
    end
    bpimat(dist2path > 1,:) = NaN;
    bpimat(:,dist2path <= 1) = NaN;
    [~,longest_subpath] = matrix_max((bpimat<=1).*bpcmat);
    if(bpcmat(sourcenode,longest_subpath(1)) > bpcmat(sourcenode,longest_subpath(2)))
        branchnode = longest_subpath(2);
        farthest_node2 = longest_subpath(1);
    else
        branchnode = longest_subpath(1);
        farthest_node2 = longest_subpath(2);
    end
    branchidx = sub2ind(imsize,branchpointlist(branchnode,1),branchpointlist(branchnode,2));
    hpts = cell2mat(bpemat(sourcenode,branchnode));
    c1pts = cell2mat(bpemat(branchnode,farthest_node1));
    c2pts = cell2mat(bpemat(branchnode,farthest_node2));
    
    Ic1 = logical(zeros(imsize));
    Ic2 = logical(zeros(imsize));
    Ih = logical(zeros(imsize));
    Ic1(c1pts) = 1;
    Ic2(c2pts) = 1;
    Ih(hpts) = 1;
    hpts = trace_skeleton(Ih,sourceidx);
    c1pts = trace_skeleton(Ic1,branchidx);
    c2pts = trace_skeleton(Ic2,branchidx);
    edt = bwdist(1-bw,'euclidean');
    if(length(c1pts) >= 10)
        [~,extension1] = max(edt(c1pts(1:10)));
    elseif(~isempty(c1pts))
        [~,extension1] = max(edt(c1pts));
    else
        extension1 = 0;
    end
    if(length(c2pts) >= 10)
        [~,extension2] = max(edt(c2pts(1:10)));
    elseif(~isempty(c2pts))
        [~,extension2] = max(edt(c2pts));
    else
        extension2 = 0;
    end
    if(extension1 > extension2)
        hpts = [hpts;c1pts(2:extension1)];
    else
        hpts = [hpts;c2pts(2:extension2)];
    end
    a = hpts;
    %%New method 10/31/2012
%     Io = zeros(imsize);
%     for i=1:numpoints
%         Io(cell2mat(bpemat(sourcenode,i))) = Io(cell2mat(bpemat(sourcenode,i)))+1;
%     end
%     Io = (Io.^4) .* edt;
%     [~,branchpoint] = matrix_max(Io);
%     branchpoint = sub2ind(imsize,branchpoint(1),branchpoint(2));
%     sourcepoint = sub2ind(imsize,branchpointlist(sourcenode,1),branchpointlist(sourcenode,2));
%     [~,hpts] = skeleton_distance(skeleton,sourcepoint,branchpoint);
%     a = cell2mat(hpts);
    %%bc
end