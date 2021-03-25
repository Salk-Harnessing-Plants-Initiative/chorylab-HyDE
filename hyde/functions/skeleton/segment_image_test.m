function [a] = segment_image_test(old_image)
%Convert raw image to binary image, skeletonize
    cot1 = NaN;
    cot2 = NaN;
    petioleangle = NaN;
    leafangle = NaN;
    imsize = size(old_image);
    sizex=size(old_image,2);
    sizey=size(old_image,1);
    threshold = graythresh(old_image);
    bw=im2bw(old_image, threshold);
    bw=1-bw;
    bw = imrotate(bw,180);
    skeleton=skeletonize_image(old_image);
    
    [branchpointlist,bpcmat,bpemat,CC] = skel2graph_test(skeleton);
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
        end
    end
    if(~sourcenode)
        a = NaN;
        return;
    end
    
    %Convert connectivity matrix to a sparse matrix, and calculate the
    %shortest length of the path from the source node (base of hypocotyl)
    %to all terminal nodes.  Store the longest path in an array.  Find the
    %longest subpath (branch off of longest path) that only shares one node
    %with the longest path using the same procedure.
    sparsematrix = sparse(bpcmat);
    [distances,path,pred] = graphshortestpath(sparsematrix,sourcenode);
    distances(isinf(distances))=0;
    [longestdistance,longestpath] = max(distances);
    longestpath = cell2mat(path(longestpath));
    %Orient the graph by traversing all shortest paths to each node from
    %the source node.  Create new sparse matrix for a directed acyclic
    %graph.
    newbranchpointmatrix = zeros(numpoints);
    for i=1:length(path)
        pathi = cell2mat(path(i));
        if length(pathi) <= 1
            continue;
        end
        for j=2:length(pathi)
            newbranchpointmatrix(pathi(j-1),pathi(j)) = bpcmat(pathi(j-1),pathi(j));
        end
    end
    
    uniquenodeids = setxor(1:numpoints,longestpath);
    longestsubpath = 0;
    longestsubpathlength = 0;
    branchpointmatrix2 = newbranchpointmatrix;
    subpathdist = 0;
    for i=2:size(longestpath,2)-1
        newbranchpointmatrix = branchpointmatrix2;

        %Prevent subpath from following same edge from the test node to
        %another node in the longest path
        newbranchpointmatrix(longestpath(i-1),:)=0;
        newbranchpointmatrix(longestpath(i+1),:)=0;
        newbranchpointmatrix(:,longestpath(i-1))=0;
        newbranchpointmatrix(:,longestpath(i+1))=0;
        
        %Find all graphs from test node to an end node not in the longest
        %path.
        newsparsematrix = sparse(newbranchpointmatrix);
        for j=1:length(uniquenodeids)
            [newpathdist,newsubpath,pred] = graphshortestpath(newsparsematrix,longestpath(i),uniquenodeids(j));
            if(newpathdist == Inf)
                continue;
            end
            if(newpathdist > subpathdist)
                subpathdist = newpathdist;
                longestsubpath = newsubpath;
            end
        end
    end
    if longestsubpath(1)
        branchpoint=branchpointlist(longestsubpath(1),:);
    else
        a = NaN;
        return;
    end
    %Fill in the holes formed by node destruction using bridging (after
    %restoring all node pixels).  Store the basic seedling data to an
    %image, and draw skeleton on the raw image.
    skeleton = zeros(size(skeleton,1),size(skeleton,2));
    checkframe=imrotate(ind2rgb(old_image,gray(255)),180);
    for i=1:size(longestpath,2)-1
        points = cell2mat(bpemat(longestpath(i),longestpath(i+1)));
        nx = branchpointlist(longestpath(i),1);
        ny = branchpointlist(longestpath(i),2);
        checkframe(nx,ny,:) = [1,0,0];
        skeleton(nx,ny) = 1;
        for j=1:size(points,1)
            [k,l] = ind2sub(imsize,points(j));
            checkframe(k,l,:)=[1,0,0];
            skeleton(k,l) = 1;
        end
    end
    for i=1:size(longestsubpath,2)-1
        points = cell2mat(bpemat(longestsubpath(i),longestsubpath(i+1)));
        nx = branchpointlist(longestsubpath(i),1);
        ny = branchpointlist(longestsubpath(i),2);
        checkframe(nx,ny,:) = [1,0,0];
        skeleton(nx,ny) = 1;
        for j=1:size(points,1)
            [k,l] = ind2sub(imsize,points(j));
            checkframe(k,l,:)=[1,0,0];
            skeleton(k,l) = 1;
        end
    end
    new_image=bwmorph(skeleton,'bridge');
    new_image=bwmorph(new_image,'skel');
    %Partition the new skeleton into the hypocotyl and two cotyledons.
    %Segment these regions into a new data structure, and determine which
    %belongs to the hypocotyl
    [x,y] = ind2sub(imsize,find(bwmorph(new_image,'branchpoints')));
    if(length(x) == 1)
        branchpoint = [x,y];
    end
    broken_image = new_image;
    broken_image(branchpoint(1)-1:branchpoint(1)+1,branchpoint(2)-1:branchpoint(2)+1) = 0;
    wholeregions = regionprops(bwconncomp(broken_image),'PixelList','BoundingBox','Centroid','Image');
    hypocotylregion = 0;
    cotyledonregion1 = 0;
    cotyledonregion2 = 0;
    testx = branchpointlist(sourcenode,2);
    testy = branchpointlist(sourcenode,1);
    hypocotyl_assigned = 0;
    cotyledon1_assigned = 0;
    cotyledon2_assigned = 0;
    for i=1:size(wholeregions,1)
        xlim=[wholeregions(i).BoundingBox(1),wholeregions(i).BoundingBox(1)+wholeregions(i).BoundingBox(3)];
        ylim=[wholeregions(i).BoundingBox(2),wholeregions(i).BoundingBox(2)+wholeregions(i).BoundingBox(4)];
        if(testx >= xlim(1) && testx <= xlim(2)&&testy>=ylim(1)&&testy<=ylim(2))
            hypocotylregion = wholeregions(i);
            hypocotyl_assigned = 1;
        elseif i==1 || (i==2 && hypocotyl_assigned)
            cotyledonregion1 = wholeregions(i);
            cotyledon1_assigned = 1;
        else
            cotyledonregion2 = wholeregions(i);
            cotyledon2_assigned = 1;
        end
    end
    if(hypocotyl_assigned+cotyledon1_assigned+cotyledon2_assigned < 3)
        a = NaN;
        return;
    end
    %Calculate the length of the hypocotyl by spline-smoothening the points
    %in this region
    
    %Calculate the leaf angle by assigning the left and right cotyledons,
    %choosing the 10th pixel away from the branchpoint, and assigning two
    %vectors relative to a hypocotyl vector.
    if norm(hypocotylregion.PixelList(end,:)-branchpoint) < norm(hypocotylregion.PixelList(1,:)-branchpoint)
        hypocotylregion.PixelList = flipud(hypocotylregion.PixelList);
    end
    if norm(cotyledonregion1.PixelList(end,:)-branchpoint) < norm(cotyledonregion1.PixelList(1,:)-branchpoint)
        cotyledonregion1.PixelList = flipud(cotyledonregion1.PixelList);
    end
    if norm(cotyledonregion2.PixelList(end,:)-branchpoint) < norm(cotyledonregion2.PixelList(1,:)-branchpoint)
        cotyledonregion2.PixelList = flipud(cotyledonregion2.PixelList);
    end
    edt = bwdist(1-bw);
    a = NaN(sum(imsize),2,3);
    hpts = sortrows(hypocotylregion.PixelList,2);
    hedt = NaN(size(hpts,1),1);
    for i=1:size(hpts,1)
        [~,p] = extrema(edt(hpts(i,2),:));
        [~,minp] = min(abs(p-hpts(i,1)));
        newp = p(minp);
        hedt(i) = edt(hpts(i,2),newp);
    end
    hpts = sub2ind(imsize,hpts(:,2),hpts(:,1));
    c1pts = sortrows(cotyledonregion1.PixelList,2);
    c1pts = sub2ind(imsize,c1pts(:,2),c1pts(:,1));
    c2pts = sortrows(cotyledonregion2.PixelList,2);
    c2pts = sub2ind(imsize,c2pts(:,2),c2pts(:,1));
    
    %%Extend hypocotyl to cotyledon skeleton regions: Find direction of
    %%cotyledon regions, keep extending until a local maximum is reached
    extended1 = cell2mat(bpemat(longestsubpath(1),longestsubpath(2)));
    for i=2:length(longestsubpath)-1
        extended1 = [extended1;cell2mat(bpemat(longestsubpath(i),longestsubpath(i+1)))];
    end
    a = hpts;
end