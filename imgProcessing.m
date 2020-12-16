function ImNew = imgProcessing(Im, threshold)
% Preprocessing of test images and binarizing gradient of images in y
% direction with a given threshold
% 1. bilateral filtering of image with gaussian kernels
% 2. resizing image to 400x600
% 3. gaussian filtering with convlution kernel of 9x9
% 4. medium filtering with convlution kernel of 9x9
% 5. caculating y gradient of image with 'sobel' convlution operator
% 6. binarizing y gradient with a given threshold
% 7. medium filtering of y gradient image with convlution kernel of 5x5

    if nargin < 2
        threshold = 0.14;
    end
    evalfun = utils;
    
    ImNew = zeros([400, 600, size(Im,3)]);
    for ni = 1 : size(Im, 3)
        im = Im(:, :, ni);
        im = evalfun.bifilt(im);
        im = imresize(im, [400, 600]);
        f = fspecial('gaussian', 9, 9);
        im = imfilter(im, f, 'same'); 
        im = medfilt2(im, [9, 9]);
        [~, gy] = imgradientxy(im);
        gy = evalfun.uniformMatrix(gy);
        gy(1:20, :) = 0;
        v = sort(gy(:), 'descend');
        mean_gy = mean(v(1 : floor(length(v)*threshold)));
        gy(gy<mean_gy) = 0;
        ImNew(:, :, ni) = medfilt2(gy, [5,5]);
    end
    
    
end


