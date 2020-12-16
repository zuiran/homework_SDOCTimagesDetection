ni = 1;
for l = 1 : 5
    Label = Label_te(:, Label_te(5,:)==l);
    Descr = Descr_te(:,:, Label_te(5,:)==l);
    [~, ind] = sort(Label(6,:), 'ascend');
    Label = Label(:, ind);
    Descr = Descr(:,:, ind);

%     inits = InitPoints(Label_te(5,:)==l);
%     inits = inits(ind);
    inits = Best_points(:, Label_te(5,:)==l);
    inits = inits(:, ind);

    mean_descr = mean(Descr, 1);
    imshow(squeeze(mean_descr), [])
    hold on
    for i = 1 : length(Label)
        pos = Label([1 3 6], i);
%         init = inits{i};
        init = inits(:, i);
        plot(pos(3)-min(Label(6,:))+1, pos(1), 'c.')
        plot(pos(3)-min(Label(6,:))+1, pos(2), 'c.')

%         plot(pos(3)-min(Label(6,:))+1, ceil(init(1,2)/3), 'g.')
%         plot(pos(3)-min(Label(6,:))+1, ceil(init(2,2)/3), 'g.')
        plot(pos(3)-min(Label(6,:))+1, ceil(init(1)/3), 'r.')
        plot(pos(3)-min(Label(6,:))+1, ceil(init(3)/3), 'r.')

    end
                hold off
    
%     Folder = '11_29\initPoint_update_Z_fit\'; 
%     mkdir(['Pic\' Folder]); warning off
%     saveas(gcf, ['Pic\' Folder num2str(l) '.jpg'])
end

% imwrite(gcf, ['Pic\' Folder num2str(l) '2.jpg'])
