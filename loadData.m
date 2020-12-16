function [Descr_tr, Label_tr, Descr_te, Label_te] = loadData(path)
% Loading data from path

    folder = [path 'TrainImg\'];
    c = 0;
    for i = 1 : 4
        file_list = dir([folder num2str(i)]);
        for j = 1 : length(file_list)-2
            c = c + 1;
            name = file_list(j+2).name;
            ind = strfind(name, '__');
    %         if ~isempty(ind)
    %             movefile(fullfile(file_list(j+2).folder, name),fullfile(file_list(j+2).folder, [name(1:ind) name(ind+2:end)]));
    %             name = [name(1:ind) name(ind+2:end)];
    %         end
            Descr_tr(:,:,c) = imread(fullfile(file_list(j+2).folder, name));
            Label_tr(1, c) = i;
            ind = strfind(name, '_');
            if strcmp(name(ind:ind+2),'_OD')
                Label_tr(2, c) = 1; % OD=1, OS=0
            else
                Label_tr(2, c) = 0;
            end
            if i < 3
                if strcmp(name(ind(3)+1),'l')
                    Label_tr(3, c) = 1; % left=1, right=0
                else
                    Label_tr(3, c) = 0;
                end
                Label_tr(4, c) = str2double(name(ind(3)+2:end-4)); % frame
            else
                Label_tr(3, c) = -1;
                Label_tr(4, c) = -1;
            end
        end
    end

    folder = [path 'TestImg\'];
    c = 0;
    for i = 1 : 5
        load([folder 'markers' num2str(i)]);
        file_list = dir([folder num2str(i)]);
        for j = 1 : length(file_list)-2
            c = c + 1;
            Descr_te(:,:,c) = imread(fullfile(file_list(j+2).folder, file_list(j+2).name));
            Label_te(1:4,c) = reshape(markers(markers(:,2)==str2double(file_list(j+2).name(1:end-4)),[1 3])', [4,1]);
            Label_te(5:6,c) = [i, str2double(file_list(j+2).name(1:end-4))];
        end
    end
    save([path '\SDOCT'], 'Descr_tr', 'Label_tr', 'Descr_te', 'Label_te')
end