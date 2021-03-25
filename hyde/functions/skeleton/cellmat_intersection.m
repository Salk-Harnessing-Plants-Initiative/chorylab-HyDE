function [imat] = cellmat_intersection(e,l)
%%Takes a cell array, l, and a cell matrix, e, which contains an array of lists.
%%Returns a matrix the same dimensions as e containing the intersection of
%%l and e(i,j)
l1 = cell2mat(l);
imat = zeros(size(e));
for i=1:size(e,1)-1
    imat(i,i) = NaN;
    for j=i+1:size(e,1)
        l2 = cell2mat(e(i,j));
        imat(i,j) = length(intersect(l1,l2));
        imat(j,i) = imat(i,j);
    end
end
end