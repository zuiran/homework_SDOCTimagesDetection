function InitPoints = initPoint(Line_rpes, Label_te)
% 
    UPDATE = false;
    if nargin > 1
        UPDATE = true;
    end
    
    for ni = 1 : length(Line_rpes)
        Line_rpe = Line_rpes{ni};
        for orient = 1 : 2 % 1 for left point and 2 for right
            pos_ni = Line_rpe{orient}; 
            if max(pos_ni(:,2))<150&&orient==1 || min(pos_ni(:,2))>450&&orient==2 || size(Line_rpe{orient},1)<18
                Line_rpes{ni}{orient} = Line_rpes{ni-1}{orient};
                Line_rpe = Line_rpes{ni};
                pos_ni = Line_rpe{orient};
            end
            % fit curves by Discrete Fourier Transformation
            f=fit(pos_ni(:,2), pos_ni(:,1),'fourier8');
            if orient == 1
                pos_ni = pos_ni(151:end-3,:);
            else
                pos_ni = pos_ni(pos_ni(:,2)<450, :);
            end
            % calculate curvature of fitted curves -- \frac{|d^2 y|}{{1+dy^2}^{1.5}}
            h = abs(diff(pos_ni(1:2, 2)));
            dy = gradient(f(pos_ni(:,2)), h);
            d2y = 2*2*del2(f(pos_ni(:,2)), h);
            k = d2y ./ (1+dy.^2).^(3/2);
            [v, ind] = sort(k, 'ascend');
            if v(end) > 0.02  % ensure initialized point
                initPoint(orient,:) = pos_ni(ind(end), :);
            else
                if orient == 1
                    initPoint(orient,:) = pos_ni(end, :);
                else
                    initPoint(orient,:) = pos_ni(1, :);
                end
            end
        end
        InitPoints(ni) = {initPoint};
    end
    if UPDATE
        InitPoints = updatePoints(InitPoints, Label_te, Line_rpes);
    end
end

function UpPoints = updatePoints(InitPoints, Label_te, Line_rpes)
    Label = Label_te([5 6],:);
    for ni = 1 : length(InitPoints)
        l = Label(1, ni);
        ind_l = find(Label(1,:)==l);
        initPoints = InitPoints{ni};
        InitPoints_l = InitPoints(ind_l);
        
        frames = 1 : length(ind_l);
        ni_frame = find(ind_l==ni);
        Aframes = [flip(frames), frames, flip(frames)];
        ind = find(Aframes==ni_frame);
        step = 5;
        if ind(1) <= step
            ind = ind(2:end);
        end
        for orient = 1 : 2
            initPoint = initPoints(orient,:);
            initPoints_l = cellfun(@(i) i(orient,:), InitPoints_l, 'UniformOutput', false);
            initPoints_l = cell2mat(initPoints_l');
            
            
            Line_rpe = Line_rpes{ni}{orient};
            mean_prePoint = mean(initPoints_l(Aframes(ind-step:ind-1),:), 1);
            mean_nxtPoint = mean(initPoints_l(Aframes(ind+1:ind+step),:), 1);
            if ~all((initPoint(2)-mean_prePoint(2)).*(initPoint(2)-mean_nxtPoint(2))<0)
                mean_x = ceil((mean_prePoint(2)+mean_nxtPoint(2))/2);
                if any(Line_rpe(:,2) == mean_x)
                    initPoint = Line_rpe(Line_rpe(:,2)==ceil((mean_prePoint(2)+mean_nxtPoint(2))/2), :);
                else
%                     f = fit(Line_rpe(5:end-5,2), Line_rpe(5:end-5,1),'fourier8');
%                     f = fit(Line_rpe(5:end-5,2), Line_rpe(5:end-5,1),'poly5');
                    f = fit([Line_rpes{ni}{1}(:,2); Line_rpes{ni}{2}(:,2)], [Line_rpes{ni}{1}(:,1); Line_rpes{ni}{2}(:,1)],'fourier5');
                    initPoint = [f(mean_x), mean_x];
%                     if orient == 1
%                         initPoint = Line_rpe(end, :);
%                     else
%                         initPoint = Line_rpe(1, :);
%                     end
                end
            end
            initPoints(orient,:) = initPoint;
        end
        UpPoints{ni} = initPoints;
    end
end

