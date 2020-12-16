% Gy2 = imgProcessing2(Descr_te);
% 
% ni = 1;
% for ni = 116 : length(InitPoints)
%     initPoints = InitPoints{ni};
% 
%     % figure(1)
%     subplot(1,2,1)
%     imshow(Gy2(:,:,ni),[]); hold on
%     tag = [ceil(Label_te([2,4],ni)*0.39)-1, Label_te([1,3],ni)*3-1];
%     plot(tag(:,2), tag(:,1), 'c*')
%     plot(initPoints(:,2), initPoints(:,1), 'r*')
% 
%     % figure(2)
%     subplot(1,2,2)
%     imshow(Gy(:,:,ni),[]); hold on
%     tag = [ceil(Label_te([2,4],ni)*0.39)-1, Label_te([1,3],ni)*3-1];
%     plot(tag(:,2), tag(:,1), 'c*')
%     plot(initPoints(:,2), initPoints(:,1), 'r*')
%     
%     fol = 'Pic\11_30\ana_t05\'; mkdir(fol); warning off
%     saveas(gcf, [fol num2str(ni) '.jpg'])
% end

%% plot left&right clusters
% [Line_rpe_all, Orient_ind] = getRpe(Clusters);
% ni = 200;
% for ni = 1 : 295  %% 26
    im = Descr_te(:, :, ni);
    im = evalfun.bifilt(im);
    im = imresize(im, [400, 600]);
    % f = fspecial('gaussian', 9, 9);
    % im = imfilter(im, f, 'same'); 
    % im = medfilt2(im, [9, 9]);

    Line_rpe = Line_rpes{ni};
%     imshow(im, []); hold on
%     for i = 1 : 2
% %     pos = Clusters{ni}{Orient_ind(i,ni)};
% %     plot(pos(:,2), pos(:,1), '.')
%     
%         line_rpe = Line_rpe{i};
%         plot(line_rpe(:,2), line_rpe(:,1), '-.', 'Linewidth',1.5)
%         f = fit(line_rpe(:,2), line_rpe(:,1),'poly3');
%         if i == 1
%             t = line_rpe(1,2):300;
%         else
%             t = 300:line_rpe(end,2);
%         end
%         plot(t, f(t), 'Linewidth',1.5)
%     end

    tag = [ceil(Label_te([2,4],ni)*0.39)-1, Label_te([1,3],ni)*3-1];
%     plot(tag(:,2), tag(:,1), 'c*')
% 
    initPoints = InitPoints{ni};
%     plot(initPoints(:,2), initPoints(:,1), 'r*')
    
%     fol = 'Pic\11_30\ana_fitPoly3\'; mkdir(fol); warning off
%     saveas(gcf, [fol num2str(ni) '.jpg'])
    
%     close all
% end












