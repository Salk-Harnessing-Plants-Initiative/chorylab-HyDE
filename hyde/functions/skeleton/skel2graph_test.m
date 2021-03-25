function [branchpointlist,bpcmat,bpemat,CC] = skel2graph_test(skeleton)

%Finds connectivity of branch and end points on a skeleton.  Requires the
%bioinformatics toolbox from MATLAB (specifically, the graph theory
%functions.  Returns four variables:
%   branchpointlist - x,y coordinates of branch points and end points in
%       the skeleton image
%   bpcmat - the connectivity matrix of all branch and end points in the
%       image (undirected) valued by the distance of the edge connecting
%       each point
%   bpemat - the same connectivity matrix as bpcmat, but the values are a
%       cell array of the pixel indices in the connected component
%       structure, CC
%   CC - the connected componant structure, contains the pixel indices of
%       all foreground pixels in the largest region in skeleton.

    imsize = size(skeleton);
    sizex = size(skeleton,2);
    sizey = size(skeleton,1);
    CC = bwconncomp(skeleton);
    objid = 0;
    if(CC.NumObjects > 1)
        maxlen = 0;
        objid = 0;
        for i=1:CC.NumObjects
            if(length(cell2mat(CC.PixelIdxList(i))) > maxlen)
                maxlen = length(cell2mat(CC.PixelIdxList(i)));
                objid = i;
            end
        end
        CC.PixelIdxList = CC.PixelIdxList(objid);
        skeleton = cc2im(CC);
        CC = cell2mat(CC.PixelIdxList);
    else
        CC = cell2mat(CC.PixelIdxList); %%connected component structure -- contains all foreground pixels in image
    end
    [endpointsi,endpointsj] = ind2sub(imsize,find(bwmorph(skeleton,'endpoints')==1));
    [branchpointsi,branchpointsj] = ind2sub(imsize,find(bwmorph(skeleton,'branchpoints')==1));
    branchpoints = [branchpointsi,branchpointsj];
    endpoints = [endpointsi,endpointsj];
    newendpoints = endpoints;
    newpoints = [branchpoints;endpoints];
    for i=1:size(newpoints,1)
        if(~skeleton(newpoints(i,1),newpoints(i,2)))
            newpoints(i,:) = NaN;
        end
    end
    newpoints(isnan(newpoints(:,1)),:) = [];
    branchpointlist = newpoints;
    numpoints = size(branchpointlist,1);
    broken_skeleton = skeleton;
    for i=1:numpoints
        pt = branchpointlist(i,:);
        if(pt(1) > 1 && pt(1) < imsize(1))
            broken_skeleton(pt(1)-1:pt(1)+1,pt(2)) = 0;
        elseif(pt(1) < imsize(1))
            broken_skeleton(pt(1):pt(1)+1,pt(2)) = 0;
        elseif(pt(1) > 1)
            broken_skeleton(pt(1)-1:pt(1),pt(2)) = 0;
        end
            
        if(pt(2) > 1 && pt(2) < imsize(2))
            broken_skeleton(pt(1),pt(2)-1:pt(2)+1) = 0;
        elseif(pt(2) < imsize(2))
            broken_skeleton(pt(1),pt(2):pt(2)+1) = 0;
        elseif(pt(2) > 1)
            broken_skeleton(pt(1),pt(2)-1:pt(2)) = 0;
        end
    end
%     broken_skeleton = bwmorph(broken_skeleton,'diag');
%     broken_skeleton = bwmorph(broken_skeleton,'skel');
%     bp = bwmorph(broken_skeleton,'branchpoints');
%     while(sum(sum(bp)))
%         broken_skeleton = broken_skeleton - bp;
%         bp = bwmorph(broken_skeleton,'branchpoints');
%     end
    CC_broken = bwconncomp(broken_skeleton);
    bpcmat = NaN(numpoints);
    bpemat = cell(numpoints);
    %Test whether two branch points are directly adjacent to one another
    %(and thus connected).
    x = branchpointlist(:,1);
    y = branchpointlist(:,2);
    distmat = sqrt((bsxfun(@minus,x,x').^2)+(bsxfun(@minus,y,y').^2));
    bpedges = intersect(find(distmat > 0),find(distmat <= sqrt(2)));
    bpcmat(bpedges) = 0;
    for i=1:CC_broken.NumObjects
        edge = CC_broken.PixelIdxList(i);
        im = zeros(imsize);
        im(cell2mat(edge)) = 1;
        epts = find(bwmorph(im,'endpoints')==1);
        [x,y] = ind2sub(imsize,epts);
        cpts = sqrt((bsxfun(@minus,x',branchpointlist(:,1)).^2) + (bsxfun(@minus,y',branchpointlist(:,2)).^2));
        uniquepts = find(sum(cpts <= sqrt(8),2));
        if(size(cpts,2) < 2)
            cpts = find(cpts < sqrt(8));
        elseif(length(uniquepts) == 2)
            cpts = uniquepts;
        else
            cpts(cpts > sqrt(8)) = NaN;
            [~,cpts] = min(cpts);
        end
%         cpts = find(sum(cpts <= sqrt(8),2));
        if(length(cpts) < 2) 
            continue; 
        end;
        conns = perms(cpts);
        bpcmat(sub2ind([numpoints,numpoints],conns(:,1),conns(:,2))) = length(edge{1});
        bpemat(sub2ind([numpoints,numpoints],conns(:,1),conns(:,2))) = edge;
    end
    bpcmat = bpcmat + 1;
    bpcmat(isnan(bpcmat)) = 0;
end