function [Line_rpe_all, Orient_ind] = getRpe(Clusters)
% Flatting and filtering clustres to form curves of left and right parts of RPE layer
% input:  Clusters[cell] \in R^{1*n}**{length(Clusters_ni)}**{}
% output: Line_rep[cell] \in R^{1*n}**{1*2}**{}

    for ni = 1 : size(Clusters,2)
        Pos = Clusters{ni};
        len = cellfun(@(p) size(p,1), Pos);
        [~, ind_descend] = sort(len, 'descend');
        Pos_new = Pos(ind_descend(1:4));

        Lines = {}; mean_y = []; mean_x = [];
        for i = 1 : length(Pos_new)
            positions = Pos_new{i};
            x_u = unique(positions(:,2));
            x_u(end+1) = x_u(end)+1;
            line = [];
            for j = 1 : length(x_u)-1 % squeezing
                x = x_u(j);
                y = median(positions(positions(:,2)==x, 1));
                line(end+1,:) = [y, x];
                if x+1 < x_u(j+1)  % smoothing the coordinate with discontinuous x
                    for k = 1 : x_u(j+1)-x-1
                        line(end+1,:) = [y+(median(positions(positions(:,2)...
                            ==x_u(j+1), 1))-y)*k/(x_u(j+1)-x-1), x+k];
                    end
                end
            end
            % mean filtering
            filter = ones(5,1) / 5;
            line(:,1) = conv(line(:,1), filter, 'same');
            line = line(3:end-2,:);
            Lines{i} = line;
            mean_y(i) = mean(line(:,1));
    %         assert(any(mean_y==mean_y(i)));
            mean_x(i) = mean(line(:,2));
    %         assert(any(mean_x==mean_x(i)));
        end
        [~, ind_y] = sort(mean_y, 'ascend');
        [~, ind_x] = sort(mean_x, 'ascend');
        ind_left = find(sum([ind_y;ind_y] == [ind_x(1);ind_x(2)], 1));
        ind_left = ind_y(ind_left(2));
        ind_right = find(sum([ind_y;ind_y] == [ind_x(3);ind_x(4)], 1));
        ind_right = ind_y(ind_right(2));
        Line_rpe = {Lines{ind_left}, Lines{ind_right}};

        Line_rpe_all(ni) = {Line_rpe};
        Orient_ind(:, ni) = [ind_descend(ind_left), ind_descend(ind_right)];
    end
%     save Line_rpe_all_11_27 Line_rpe_all
end