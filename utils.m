function fun = utils
% Some useful gadgets

    fun.exFea = @extractFeature;
    fun.bifilt = @bilatfilter;
    fun.findFrame = @findFrame;
    fun.getPatch = @getPatch;
    fun.getColor = @getColor;
    fun.uniformMatrix = @uniformMatrix;
    fun.loadData = @loadData;
    fun.svm = @svmClassifier;
end

function [Descr_tr, Label_tr, Descr_te, Label_te] = loadData(data_folder)
    if isfile([data_folder '\SDOCT.mat'])
        load([data_folder '\SDOCT.mat'])
    else
        [Descr_tr, Label_tr, Descr_te, Label_te] = loadData(data_folder);
    end
end

function im = bilatfilter(im)
    patch = imcrop(im, [150,970, 50,50]);
    patchVar = std2(patch)^2;
    DoS = 2*patchVar;
    im = imbilatfilt(im, DoS,7);
end

function Fea = extractFeature(Im, method)
    for i = 1 : size(Im, 3)
        im = Im(:,:, i);
        switch method
            case 'hog'
%                 Fea(:, i) = extractHOGFeatures(im)';
                Fea(:, i) = normc(extractHOGFeatures(im)');
            case 'lbp'
                Fea(:, i) = normc(extractLBPFeatures(im)');
            case 'both'
                fea = [normc(extractHOGFeatures(im)'); normc(extractLBPFeatures(im)')];
                Fea(:, i) = normc(fea);
            case 'none'
                Fea(:, i) = normc(double(reshape(im, size(im,1)*size(im,2), 1)));
        end
    end
end

function Mdl = svmClassifier(Descr_tr, Label_tr, fea)
    Des = extractFeature(Descr_tr, fea);
    svmM = templateSVM('KernelFunction' ,'rbf');
    Mdl = fitcecoc(Des', Label_tr(1,:)', 'Learners', svmM);
    error = resubLoss(Mdl);
end

function D = findFrame(ni, orient, Label_te, Label_tr, Descr_tr)
    frame = Label_te(6, ni);
    uFrame = Label_tr(4,Label_tr(1,:)==orient);
    uFrame = unique(uFrame);
    Aframe = [flip(uFrame) uFrame flip(uFrame)];  
    ind = find(Aframe==frame);
    while isempty(ind)
       frame = frame + 1; 
       ind = find(Aframe==frame);
    end
    interval = 5;
    while ind(1) <= interval 
        ind = ind(2:end);
    end

    D = Descr_tr(:,:, Label_tr(1,:)==orient&Label_tr(4,:)>min(Aframe(ind(1)-interval),...
            Aframe(ind(1)+interval))&Label_tr(4,:)<max(Aframe(ind(1)-interval), Aframe(ind(1)+interval)));
end

function m = uniformMatrix(M)
    m = (M-min(M(:))) / (max(M(:))-min(M(:)));
end

function c = getColor(name)
    Name = {'cold_white', 'pale_yellow', 'orange', 'pale_red', 'navy_blue', 'cyan'};
    Color = [225, 238, 210; % Cold white
             219, 208, 167; % pale yellow
             230, 155, 3;   % orange 
             209, 73,  78;  % pale red
             18,  53,  85;  % navy blue
             3,   101, 100]./255;% cyan
    if strcmp(Name,name)
        c = Color(strcmp(Name,name), :);
    end
    
    Classic = [0,      0.4470, 0.7410;
               0.8500, 0.3250, 0.0980;
               0.9290, 0.6940, 0.1250;
               0.4940, 0.1840, 0.5560;
               0.4660, 0.6740, 0.1880;
               0.3010, 0.7450, 0.9330;
               0.6350, 0.0780, 0.1840];
    if strcmp('classic', name)
        c = Classic;
    end
end

%% Im must be a square matrix!
function Patch = getPatch(Im, w)
    center = floor((size(Im,1)+1)/2);
    w = floor((w+1)/2);
    for i = 1 : size(Im, 3)
        im = Im(:,:, i);
        Patch(:,:, i) = im(center-w:center+w, center-w:center+w);
    end
end










