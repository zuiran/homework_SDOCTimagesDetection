function Best_points = updatePoint(Descr_tr, Label_tr, Descr_te, Label_te, Line_rpes, InitPoints, fea, UPDATE)
% update points from initpoints by considering svm confident and two
% distance information

    evalfun = utils;
    if nargin < 8
        UPDATE = true;
    end
    
%     for fea = {'hog'} % {'none', 'both', }
% fea = fea{1};
Mdl =  evalfun.svm(Descr_tr, Label_tr, fea);
for ni = 1 : size(Descr_te, 3)
    im = Descr_te(:, :, ni);
    im = evalfun.bifilt(im);
    im = imresize(im, [400, 600]);
    initPoints = InitPoints{ni};

    Line_rpe = Line_rpes{ni};
    f = fit([Line_rpe{1}(:,2); Line_rpe{2}(:,2)], [Line_rpe{1}(:,1); Line_rpe{2}(:,1)],'fourier5'); %fourier5
    %     plot(f, [Line_rpe{1}(:,2); Line_rpe{2}(:,2)], [Line_rpe{1}(:,1); Line_rpe{2}(:,1)])
    %     legend('off')

    for orient = 1 : 2
        patch_l = 20;
        patch_r = 30;
        if orient == 2
            patch_l = 30;
            patch_r = 20;
        end

        patch_u = 10;
        patch_d = 20;
        step = 5;

        x = initPoints(orient, 2); x = round(x);
        y = initPoints(orient, 1); y = round(y);
        c = 0;
%             clear Patches Posit
        for i = -patch_l : step : patch_r
            for j = -patch_u : step : patch_d
                c = c + 1;
                x1 = x + i;
                y1 = round(f(x1) + j);
    %             y1 = y + j; 
                Patches(:,:, c) = im(y1-40:y1+40, x1-40:x1+40);
                Posit(c, :) = [x1, y1];
            end
        end
        f_patches = evalfun.exFea(Patches, fea);
        [l, c] = predict(Mdl, f_patches');
        t1 = find(l==orient);
        if isempty(t1)
            [~, t1] = sort(c(:,orient), 'descend');
            t1 = t1(1:30);
        end
        c1 = c(t1, :);
        c1 = c1(:, orient) - (c1(:,3)+c1(:,4))/2;
        c1 = (c1-min(c1,[],1)) ./ (max(c1,[],1)-min(c1,[],1));

        coors = Posit(t1, :);
        e1 = sum((coors-[x y]).^2, 2);
        e1 = (e1-min(e1,[],1)) ./ (max(e1,[],1)-min(e1,[],1));
        e2 = sum((coors - [coors(:,1) f(coors(:,1))]).^2, 2);
        e2 = (e2-min(e2,[],1)) ./ (max(e2,[],1)-min(e2,[],1));
        scor = c1 - (1*e1+0.5*e2);
        [~, ind] = sort(scor, 'descend');

        if orient == 1
            Best_points(1:2, ni) = coors(ind(1),:)';
        else
            Best_points(3:4, ni) = coors(ind(1),:)';
        end
    end
end
%     end

%% smooth
if UPDATE
    Label = Label_te([5 6],:);
    for ni = 1 : size(Descr_te, 3)
        l = Label(1, ni);
        ind_l = find(Label(1,:)==l);
        best_points = Best_points(:, ni);
        best_points_l = Best_points(:, ind_l);
        frames = 1 : length(ind_l);
        ni_frame = find(ind_l==ni);
        Aframes = [flip(frames), frames, flip(frames)];
        ind = find(Aframes==ni_frame);
        step = 5;
        if ind(1) <= step
            ind = ind(2:end);
        end
        for orient = 1 : 2
            Line_rpe = Line_rpes{ni}{orient};
            if orient == 1
                tind = 1 : 2;
            else
                tind = 3 : 4;
            end
            best_point = best_points(tind);
            best_point_l = best_points_l(tind, :);
            mean_prePoint = mean(best_point_l(:, Aframes(ind-step:ind-1)), 2);
            mean_nxtPoint = mean(best_point_l(:, Aframes(ind+1:ind+step)), 2);
            if ~all((best_point(2)-mean_prePoint(2)).*(best_point(2)-mean_nxtPoint(2))<0)
                mean_x = ceil((mean_prePoint(1)+mean_nxtPoint(1))/2);
                mean_y = ceil((mean_prePoint(2)+mean_nxtPoint(2))/2);
                best_point = [mean_x, mean_y];
            end
            uPpoint(tind) = best_point;   
        end
        UPpoints(:, ni) = uPpoint;
    end
    Best_points = UPpoints;
end

