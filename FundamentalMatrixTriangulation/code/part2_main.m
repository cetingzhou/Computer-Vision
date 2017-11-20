clear all; clc;

% load image
img1Filename = '../data/part2/house1.jpg';
img2Filename = '../data/part2/house2.jpg';
img1 = imread(img1Filename);
img2 = imread(img2Filename);

matches = [];
F = [];

% set
method = 1; % 1-groundtruth, 2-RANSAC
normalizeOpen = true;
% convert to double and to grayscale
img1_double = im2double(img1);
img2_double = im2double(img2);

img1_gray = rgb2gray(img1_double);
img2_gray = rgb2gray(img2_double);

% using ground truth matches
residual_gt = 0;
if method == 1
    matches = load('../data/part2/house_matches.txt');
    %matches = load('../data/part2/library_matches.txt');
    N = size(matches, 1);
    homoPts1 = [matches(:, 1:2), ones(N, 1)];
    homoPts2 = [matches(:, 3:4), ones(N, 1)];
    % compute the fundamental matrix
    F = fit_fundamental(homoPts1, homoPts2, normalizeOpen);
    % compute the residual
    for i = 1:N
        residual_gt = residual_gt + (homoPts2(i, :) * F * homoPts1(i, :)')^2;
    end
end

% using RANSAC to 
residual_ransac = 0;
if method == 2
    harrisParams.sigma = 3;  harrisParams.harrisThresh = 0.01;
    harrisParams.radius = 3; harrisParams.disp = 0;
    neighbors = 6;
    numMatches = 200;
    [matchPts1, matchPts2] = getMatches(img1_gray, img2_gray, neighbors,...
                                    numMatches, harrisParams);
    homoPts1 = [matchPts1, ones(numMatches, 1)];
    homoPts2 = [matchPts2, ones(numMatches, 1)];
    matches = [matchPts1, matchPts2];
    params.numIter = 2000; params.inlierDistThreshold = 0.001;
    [F, inliers] = RANSAC(params, homoPts1, homoPts2, normalizeOpen);
    residual_ransac = mean(inliers);
end

% transform points from the 1st img to get epipolar lines in the 2nd image
numMatches = size(matches, 1);
L = (F * [matches(:,1:2) ones(numMatches,1)]')'; 

% find points on epipolar lines L closest to matches(:,3:4)
L = L ./ repmat(sqrt(L(:,1).^2 + L(:,2).^2), 1, 3); % rescale the line
pt_line_dist = sum(L .* [matches(:,3:4) ones(numMatches,1)],2);
closest_pt = matches(:,3:4) - L(:,1:2) .* repmat(pt_line_dist, 1, 2);

% find endpoints of segment on epipolar line (for display purposes)
pt1 = closest_pt - [L(:,2) -L(:,1)] * 10; % offset from the closest point is 10 pixels
pt2 = closest_pt + [L(:,2) -L(:,1)] * 10;

% display points and segments of corresponding epipolar lines
figure;
imshow(img2); hold on;
plot(matches(:,3), matches(:,4), '+r');
line([matches(:,3) closest_pt(:,1)]', [matches(:,4) closest_pt(:,2)]', 'Color', 'r');
line([pt1(:,1) pt2(:,1)]', [pt1(:,2) pt2(:,2)]', 'Color', 'g');


