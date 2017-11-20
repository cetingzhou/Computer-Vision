% Blobs are scale-invariant features. 
% The Laplacian has a strong response not only at blobs, but also along
% edges, which means some spots are not repeatable in different scale.
% input image data
imgFile = '../data/butterfly.jpg';
img = imread(imgFile);

% convert image to grayscale and double type
img_gray = rgb2gray(img);
I = im2double(img_gray);

% setting the parameters
num_scales = 15;
sigma = 2;
scale_factor = sqrt(sqrt(2));
threshold = 0.1;

%%%%%%%%%%%%%%%%% Using two methods to generates scale space %%%%%%%%%%%%%%
downsample = true;
% h, w - dimensions of image
[h, w] = size(I);
scale_space = zeros(h, w, num_scales);
%% 1) generating the scale space by increasing the filter size
tic
if downsample ~= true
    for i = 1:num_scales
        % the only parameter we are dealing with is sigma
        scaledSigma = sigma * scale_factor^(i-1);
        % filter size depends on sigma 
        % a good filter size should capture the essence of LoG with that sigma
        % filter size should be an odd value, i.e. 5x5
        filterSize = 2 * ceil(3 * scaledSigma) + 1;
        % create a Laplacian of Gaussian kernel
        LoG = fspecial('log', filterSize, scaledSigma);
        
        % using LoG filter on the image
        filteredImage = imfilter(I, LoG, 'same', 'replicate');
        % scale normalization
        filteredImage = filteredImage * scaledSigma^2;
        
        % store the filteredImage in the 3-D array
        scale_space(:, :, i) = abs(filteredImage);
    end
end
toc
%% 2) generating the scale space by downsampling the image
% It is more efficient to dowbsample the image by a factor 1/k
% instead of increasing the kernel size by a factor of k. 
tic
if downsample == true
    filterSize = 2 * ceil(3 * sigma) + 1;
    LoG = fspecial('log', filterSize, sigma);
    for i = 1:num_scales
        if i == 1
            downsampledImg = I;
        else
            downsampledImg = imresize(I, 1/(scale_factor^(i-1)));
        end
        % using LoG filter on the downsamped image
        filteredImg = imfilter(downsampledImg, LoG, 'same', 'replicate');
        % scale normalization
        filteredImg = filteredImg * sigma^2;
        
        % upsample the filtered response using the 'bicubic' interpolation
        upsampledImg = imresize(filteredImg, [h, w], 'bicubic');
        % store the upsample image in the 3-D array
        scale_space(:, :, i) = abs(upsampledImg);
    end
end
toc
%%%%%%%%%%%%%%%%%%%%%%%%% Non-Maximum Suppression %%%%%%%%%%%%%%%%%%%%%%%%%
%% do non-maxima suppression in individual layer 2D images
scale_space_maxima = zeros(h, w, num_scales);
for i = 1:num_scales
    scale_space_maxima(:, :, i) = ordfilt2(scale_space(:, :, i), 9, ones(3));
end

%% do non-maxima suppression in the depth direction
for i = 1:num_scales
%    if i == 1
%        lower_level = i;
%        upper_level = i+1;
%    elseif i < num_scales
%        lower_level = i-1;
%        upper_level = i+1;
%    else
%        lower_level = i-1;
%        upper_level = i;
%    end
    scale_space_maxima(:, :, i) = ...
        max(scale_space_maxima(:, :, :), [], 3);
end
maxima_location = scale_space_maxima == scale_space;
scale_space_NMS = scale_space .* maxima_location;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Blob Detection %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% define the radius of the blob is in terms of sigma
radius = zeros(1, num_scales);
for i = 1:num_scales
    radius(i) = sqrt(2) * sigma * scale_factor^(i-1);
end

%% find the center of the blobs and store the centers and radius in blobs
blobs = [];
% threshold filter
thresholdFilter = scale_space_NMS > threshold;
scale_space_NMS = scale_space_NMS .* thresholdFilter;

for i = 1:num_scales
    [blob_rows, blob_cols] = find(scale_space_NMS(:, :, i));
    % blobs: row1 is x pos; row2 is y pos; row3 is radius
    new_blobs = [blob_rows'; blob_cols'];
    new_blobs(3, :) = radius(i);
    blobs = [blobs, new_blobs];
end

%% Draw the Blobs
cx = blobs(1, :);
cy = blobs(2, :);
rad = blobs(3, :);
show_all_circles(I, cy', cx', rad');
            
        
        
        