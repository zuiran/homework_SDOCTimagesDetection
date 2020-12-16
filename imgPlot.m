evalfun = utils;

% ni = 1;
clear Errs
% for ni = 1 : size(Descr_te, 3)
ni = 147;
    im = Descr_te(:,:,ni);
    im = evalfun.bifilt(im);
    im = imresize(im, [400, 600]);
    tag = [ceil(Label_te([2,4],ni)*0.39)-1, Label_te([1,3],ni)*3-1];
    Line_rpe = Line_rpes{ni};
    initPoints = InitPoints{ni};
    Pos = Clusters{ni};
    
    imshow(Gy(:,:, ni)); hold on;
    for i = 1 : length(Pos)
        pos = Pos{i};
        plot(pos(:,2), pos(:,1), '.')
    end
    
%     imshow(im); hold on
%     for orient = [1 2]
%         pos_ni = Line_rpe{orient};
%         plot(pos_ni(:,2), pos_ni(:,1), 'Linewidth',1.5)
%     end
%     plot(tag(:,2), tag(:,1), 'c*')
%     plot(initPoints(:,2), initPoints(:,1), 'r*')

%     Errs(1, ni) = norm(tag(1,:) - initPoints(1,:));
%     Errs(2, ni) = norm(tag(2,:) - initPoints(2,:));
%     Errs(1+err, ni) = norm(tag(1,:) - initPoints(1,:));
%     Errs(2+err, ni) = norm(tag(2,:) - initPoints(2,:));
%     Errs(3, ni) = 0;
    
%     Errs(ni) = sum((tag-initPoints).^2, 'all');
      Errs(:, ni) = sqrt(sum((tag-initPoints).^2, 2));
%     Folder = '11_28\initPoint_update\'; 

%     mkdir(['Pic\' Folder]); warning off
%     saveas(gcf, ['Pic\' Folder num2str(ni) '.jpg'])
% end