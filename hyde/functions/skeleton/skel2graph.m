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
    centerpt = sub2ind(imsize,round(sizey/2),1);
    if(CC.NumObjects > 1)
        mindist = sizey;
        objid = 0;
        for i=1:CC.NumObjects
            temp_mindist = min(dist_idx(cell2mat(CC.PixelIdxList(i)),centerpt,imsize));
            if(min(temp_mindist < mindist))
                mindist = temp_mindist;
                objid = i;
            end
        end
        CC.PixelIdxList = CC.PixelIdxList(objid);
        skeleton = logical(cc2im(CC));
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
    %%loop through all branch and endpoints, find the shortest distance
    %%between them, as well as the edge connecting them.
    bpcmat = zeros(numpoints);
    bpemat = cell(numpoints);
    for i=1:numpoints-1
        pti = sub2ind(imsize,branchpointlist(i,1),branchpointlist(i,2));
        for j=i+1:numpoints
            ptj = sub2ind(imsize,branchpointlist(j,1),branchpointlist(j,2));
            [bpcmat(i,j),bpemat(i,j)] = skeleton_distance(skeleton, pti,ptj);
            bpcmat(j,i) = bpcmat(i,j);
            bpemat(j,i) = bpemat(i,j);
        end
    end
end