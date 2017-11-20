function F = fit_fundamental(homoPts1, homoPts2, normalizeOpen)
% the size of both homoPts1 and homoPts2 is Nx3.
% each row of homoPts1 is the coordinate of corner in the img1.
% each row of homoPts2 is the coordinate of corner in the img2.
% normalize: whether or not to normalize the mathes before estimating the
% fundamental matrix.

% number of matches
N = size(homoPts1, 1);

if normalizeOpen == true
    [homoPts1, trans1] = normalize(homoPts1);
    [homoPts2, trans2] = normalize(homoPts2);
    
    A = [homoPts1(:, 1).*homoPts2(:, 1), homoPts1(:, 1).*homoPts2(:, 2), ...
         homoPts1(:, 1), homoPts1(:, 2).*homoPts2(:, 1), homoPts1(:, 2).*homoPts2(:, 2) ...
         homoPts1(:, 2), homoPts2(:, 1), homoPts2(:, 2), ones(N, 1)];

    [~, ~, V] = svd(A);
    F = reshape(V(:, 9), 3, 3)';

    % the rank of fundamental matrix must be 2
    [U, D, V] = svd(F);
    F = U * diag([D(1, 1) D(2, 2) 0]) * V';
    
    % denormalize
    F = trans2' * F * trans1;
end


if normalizeOpen == false

    A = [homoPts1(:, 1).*homoPts2(:, 1), homoPts1(:, 1).*homoPts2(:, 2), ...
         homoPts1(:, 1), homoPts1(:, 2).*homoPts2(:, 1), homoPts1(:, 2).*homoPts2(:, 2) ...
         homoPts1(:, 2), homoPts2(:, 1), homoPts2(:, 2), ones(N, 1)];

    [~, ~, V] = svd(A);
    F = reshape(V(:, 9), 3, 3)';

    % the rank of fundamental matrix must be 2
    [U, D, V] = svd(F);
    F = U * diag([D(1, 1) D(2, 2) 0]) * V';
    
end
