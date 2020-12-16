% clear; close;tic
% evalfun = utils;
% 
% %% Data loading from data_folder
% data_folder = 'Dataset';
% [Descr_tr, Label_tr, Descr_te, Label_te] = evalfun.loadData(data_folder);
% tim(1) = toc;
% 
% 
% %% Preprocessing and binarizing y-direction gradient of test images
% Gy = imgProcessing(Descr_te);
% tim(2) = toc - sum(tim);
% 
% 
% %% Deep First Searching for clustring y gradient lagger than zero
% Clusters = DFS(Gy);
% tim(3) = toc - sum(tim);
% 
% 
% %% Flatting and filtering clustres to form curves of left and right parts of RPE layer
% Line_rpes = getRpe(Clusters);
% tim(4) = toc - sum(tim);
% 
% 
% %% Initializing point according to curvatures of left and right REP curves
% InitPoints = initPoint(Line_rpes, Label_te); % UPDATA = True
% tim(5) = toc - sum(tim);


%% update points from initpoints
    tic
for fea = {'lbp', 'hog', 'none', 'both'} % {'hog', 'lbp', 'none', 'both'} %{'hog'}
    tim2(1) = toc;
    fea = fea{1};
    Best_points = updatePoint(Descr_tr, Label_tr, Descr_te, Label_te, Line_rpes, InitPoints, fea); % UPDATA = True
    tim2(2) = toc - sum(tim2);

    %% calculate pixel distance
    [errs_init1, mean_errs_init_i1] = calDistance(Label_te, InitPoints); % RESIZE = true
    [errs_best1, mean_errs_best_i1] = calDistance(Label_te, Best_points);
    tim2(3) = toc - sum(tim2);
    
    [errs_init2, mean_errs_init_i2] = calDistance(Label_te, InitPoints, 0); % RESIZE = true
    [errs_best2, mean_errs_best_i2] = calDistance(Label_te, Best_points, 0);
    tim2(4) = toc - sum(tim2);

%% save workspave
save(['Workspace\workspace_12_15_' fea])
end


