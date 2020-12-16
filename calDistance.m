function [errs, mean_errs_i] = calDistance(Label_te, Points, RESIZE)
% calculating the distance between groud truth and initial/updated points

    if nargin < 3
        RESIZE = true;
    end
    if iscell(Points)
           points_cell = cellfun(@(x) [x(1,[2,1]), x(2,[2,1])]', Points, 'UniformOutput', false);
           Points = cell2mat(points_cell);
    end
    
    if ~RESIZE
        Label_te([1,3], :) = Label_te([1,3], :)*3-1;
        Label_te([2,4], :) = ceil(Label_te([2,4], :)*0.39)-1;
    else
        Points([1,3], :) = ceil(Points([1,3], :)/3);
        Points([2,4], :) = floor(Points([2,4], :)*2.56);
    end

    errs = Label_te(1:4,:) - Points;
    errs = [sqrt(errs(1,:).^2+errs(2,:).^2); sqrt(errs(3,:).^2+errs(4,:).^2)];
    errs = sum(errs, 1)/2;

    for i = 1 : length(unique(Label_te(5,:)))
        ind = Label_te(5,:)==i;
        errs_i = errs(ind);
        mean_errs_i(i) = mean(errs_i);
    end
end