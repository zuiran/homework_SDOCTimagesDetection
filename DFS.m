function Clusters = DFS(Gy)
% Deep First Searching for clustring y gradients lagger than zero
% input:  Gy \in R^{h*w*n}
% output: Pos \in R^{length(clusters)*n}

    interval = 7;
    Clusters = {};
    for ni = 1 : size(Gy, 3)
        clear coor
        
        gy = Gy(:,:,ni);
        Ind = gy>0;
        [coor(:,1), coor(:,2)] = find(Ind);
        
        % getting rid of useless coordinates
        for i = 1 : size(coor,1)
            pos_cur = coor(i,:);
            if pos_cur(1)-1>0 && pos_cur(1)+1<size(Ind,1) && pos_cur(2)-1>0 && pos_cur(2)+1<size(Ind,2)
                if sum(Ind([pos_cur(1)-1, pos_cur(1)-1, pos_cur(1)+1, pos_cur(1)+1],...
                           [pos_cur(2), pos_cur(2)+1, pos_cur(1), pos_cur(1)-1])) < 1
                    Ind(pos_cur(1), pos_cur(2)) = 0;
                end
            else
                Ind(pos_cur(1), pos_cur(2)) = 0;
            end
            if pos_cur(2)>295 && pos_cur(2)<305
               Ind(pos_cur(1), pos_cur(2)) = 0;
            end
        end
        
        c = 0;
        Node = [];
        
        for i = 1 : size(coor,1)
            pos_cur = coor(i,:);
            if all(Ind(pos_cur(1),pos_cur(2)))
               pos_pre = [];
               [pos_cur, pos_pre, Ind, Node] = getNode(pos_cur, pos_pre, Ind, Node);
               c = c + 1;
               Clusters{ni}{c} = Node;
               Node = [];
            end
        end
    end
end

function [pos_cur, pos_pre, Ind, Node] = getNode(pos_cur, pos_pre, Ind, Node)
% Depth First Search
    if nargin < 5
        if pos_cur(2)<370 && pos_cur(2)>210 %210
           interval = 2;
        else
           interval = 7; % max margin of nearest neighbors, default: 9 7
        end
    end
    c = 0;
    for i = -interval : interval
        for j = -interval : interval
            if any([i,j]) && pos_cur(1)+i>0 && pos_cur(2)+j>0 &&...
                    pos_cur(1)+i<=size(Ind,1) && pos_cur(2)+j<=size(Ind,2)
                if Ind(pos_cur(1)+i, pos_cur(2)+j)==1
                    c = c + 1;
                    ind(c, :) = [i, j];
                end
            end
        end
    end
    if c > 0
        Ind(pos_cur(1),pos_cur(2)) = 0;
        pos_pre = [pos_pre; pos_cur];
        pos_cur = pos_cur + ind(1,:);
        [pos_cur, pos_pre, Ind, Node] = getNode(pos_cur, pos_pre, Ind, Node);
    else
        Ind(pos_cur(1),pos_cur(2)) = 0;
        Node = [Node; pos_cur];
        if size(pos_pre, 1) > 0
            pos_cur = pos_pre(end, :);
            pos_pre = pos_pre(1:end-1, :);
            
            [pos_cur, pos_pre, Ind, Node] = getNode(pos_cur, pos_pre, Ind, Node);
        end
    end
end