function [F, inliers] = RANSAC(params, homoPts1, homoPts2, normalizeOpen)
% The Random Sample Consensus(RANSAC) works in the following steps:
% - Pick 4 matches randomly from homoPts1 and homoPts2;
% - Estimate a homography matrix from the 4 matches;
% - Look for additional inliers. Apply the estimated homography matrix from
%   the previous step to points from one image and compare with points in
%   the other image to see if the distance is below some threshold. If so,
%   it's an inlier. If not, it's an outlier;
% - Repeat step1 to step3 multiple times;
% - Return the estimated homography matrix that yielded the most inliers.

F = [];
numInliers = 0;
inlierIndex = [];
inliers = [];
n = size(homoPts1, 1);
% Start the iteration
for i = 1:params.numIter
    % Pick 8 matches randomly
    temp_inlierIndex = randsample(n, 8);
    randPts1 = homoPts1(temp_inlierIndex, :);
    randPts2 = homoPts2(temp_inlierIndex, :);
    temp_F = fit_fundamental(randPts1, randPts2, normalizeOpen);
    
    % calculate residual
    for j = 1:n
        residual(j) = (homoPts2(j, :) * temp_F * homoPts1(j, :)')^2;
    end
    % find inliers below threshold
    inliers_id = find(residual < params.inlierDistThreshold);
    temp_inliers = residual(inliers_id);
    temp_numInliers = length(temp_inliers);
    % compute the number of inliers with this estimated H
    if temp_numInliers > numInliers        % find the results with most inliers
        numInliers = temp_numInliers;      % Update the number of inliers
        F = temp_F;                        % Update H
        inlierIndex = temp_inlierIndex;    % Update inlierIndex
        inliers = temp_inliers;
    end
end
F
end
