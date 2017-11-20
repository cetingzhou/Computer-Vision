function [matchPts1, matchPts2] = getMatches(img1, img2, neighbors,...
    numMatches, harrisParams)

% use harris.m to find Harris corner of the two images.
[~, r1, c1] = harris(img1, harrisParams.sigma, harrisParams.harrisThresh,...
    harrisParams.radius, harrisParams.disp);
[~, r2, c2] = harris(img2, harrisParams.sigma, harrisParams.harrisThresh,...
    harrisParams.radius, harrisParams.disp);

% extract local neighborhoods around every keypoint in both image, and form
% descriptors simly by "flattening" the pixel values in each neighborhood
% to one-dimensional vectors.
descriptors1 = []; numCorners1 = size(r1, 1);
descriptors2 = []; numCorners2 = size(r2, 1);

% pad the image
padFilter = zeros(2 * neighbors + 1);
padFilter(neighbors + 1, neighbors + 1) = 1;
paddedImg1 = imfilter(img1, padFilter, 'replicate', 'full');
paddedImg2 = imfilter(img2, padFilter, 'replicate', 'full');

for i = 1:numCorners1
    try
        rowRange = r1(i) : r1(i)+2*neighbors;
        colRange = c1(i) : c1(i)+2*neighbors;
        neighborhood = paddedImg1(rowRange, colRange);  % extract local neighbors
        descriptors1(i, :) = neighborhood(:);          % flattening
    catch 
        continue
    end
end

for i = 1:numCorners2
    try
        rowRange = r2(i) : r2(i)+2*neighbors;
        colRange = c2(i) : c2(i)+2*neighbors;
        neighborhood = paddedImg2(rowRange, colRange);  % extract local neighbors
        descriptors2(i, :) = neighborhood(:);          % flattening
    catch
        continue
    end
end

% Normalize all descriptors to have zero mean and unit standard deviation
descriptors1 = zscore(descriptors1')';
descriptors2 = zscore(descriptors2')';

% naive way to extract matches
distances = dist2(descriptors1, descriptors2);
[~, distInd] = sort(distances(:), 'ascend');
bestMatches = distInd(1:numMatches);
[rowInd, colInd] = ind2sub(size(distances), bestMatches);
descrpt1_selected = rowInd;
descrpt2_selected = colInd;

match_r1 = r1(descrpt1_selected);
match_c1 = c1(descrpt1_selected);
match_r2 = r2(descrpt2_selected);
match_c2 = c2(descrpt2_selected);

matchPts1 = [match_c1, match_r1];
matchPts2 = [match_c2, match_r2];

% get the imge size
[~, width1] = size(img1);
% Display lines connecting the matched features
plot_r = [match_r1, match_r2];
plot_c = [match_c1, match_c2 + width1];
figure; imshow([img1 img2]); hold on; title('top matched features');
hold on; 
plot(match_c1, match_r1,'ys');           %mark features from the 1st img
plot(match_c2 + width1, match_r2, 'ys'); %mark features from the 2nd img
for i = 1:numMatches             %draw lines connecting matched features
    plot(plot_c(i,:), plot_r(i,:));
end

end
