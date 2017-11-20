function [H, inlierIndex] = RANSAC(params, homoPts1, homoPts2)
% The Random Sample Consensus(RANSAC) works in the following steps:
% - Pick 4 matches randomly from homoPts1 and homoPts2;
% - Estimate a homography matrix from the 4 matches;
% - Look for additional inliers. Apply the estimated homography matrix from
%   the previous step to points from one image and compare with points in
%   the other image to see if the distance is below some threshold. If so,
%   it's an inlier. If not, it's an outlier;
% - Repeat step1 to step3 multiple times;
% - Return the estimated homography matrix that yielded the most inliers.

H = [];
numInliers = 0;
inlierIndex = [];
inliers = [];
n = size(homoPts1, 1);
% Start the iteration
for i = 1:params.numIter
    % Pick 4 matches randomly
    temp_inlierIndex = randsample(n, 4);
    randPts1 = homoPts1(temp_inlierIndex, :);
    randPts2 = homoPts2(temp_inlierIndex, :);
    temp_H = getHomography(randPts1, randPts2);
    if (rank(temp_H) < 3)
        continue;
    end
    % divide the each point by the 3rd coord to get [x y 1]
    transPts1 = homoPts1 * temp_H;
    transPts1(:, 1) = transPts1(:, 1) ./ transPts1(:, 3);
    transPts1(:, 2) = transPts1(:, 2) ./ transPts1(:, 3);
    % calculate the sqaure difference
    SD = sum((transPts1(:, [1, 2]) - homoPts2(:, [1, 2])).^2, 2);
    % find inliers below threshold
    inliers_id = find(SD < params.inlierDistThreshold);
    temp_inliers = SD(inliers_id);
    temp_numInliers = length(temp_inliers);
    % compute the number of inliers with this estimated H
    if temp_numInliers > numInliers        % find the results with most inliers
        numInliers = temp_numInliers;      % Update the number of inliers
        H = temp_H;                        % Update H
        inlierIndex = temp_inlierIndex;    % Update inlierIndex
        inliers = temp_inliers;
    end
end
H
end
