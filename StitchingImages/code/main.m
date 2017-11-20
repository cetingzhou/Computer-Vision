clear all; clc;

% load image
img1Filename = '../data/part1/uttower/left.jpg';
img2Filename = '../data/part1/uttower/right.jpg';
img1_rgb = imread(img1Filename);
img2_rgb = imread(img2Filename);

% convert to double and to grayscale
img1_double = im2double(img1_rgb);
img2_double = im2double(img2_rgb);

img1_gray = rgb2gray(img1_double);
img2_gray = rgb2gray(img2_double);

% get the imge size
[height1, width1] = size(img1_gray);
[height2, width2] = size(img2_gray);

% getMaches of the two images
harrisParams.sigma = 2;  harrisParams.harrisThresh = 0.05;
harrisParams.radius = 2; harrisParams.disp = 1;
neighbors = 20;
numMatches = 50;
[matchPts1, matchPts2] = getMatches(img1_gray, img2_gray, neighbors,...
                                    numMatches, harrisParams);

% convert the maches to homogeneous coordinates
homoPts1 = [matchPts1, ones(numMatches, 1)];
homoPts2 = [matchPts2, ones(numMatches, 1)];

% implement RANSAC to get homography matrix
params.numIter = 20000; params.inlierDistThreshold = 400;
[H, inlierIndex] = RANSAC(params, homoPts2, homoPts1);

% show the warp image
%homoTrans = maketform('projective', H);
%img1Trans = imtransform(img1_rgb, homoTrans);
%figure, imshow(img1Trans); title('warped image');
% Stitch the images together with the correct overlap

%H = [1.3854 0.2055 0.0004; 
%    -0.1032 1.2285 -0.0001; 
%    610.0279 -177.5902 1.0];
compositeImg = stitch(img1_double, img2_double, H);
figure, imshow(compositeImg);
title('Alignment by homography');