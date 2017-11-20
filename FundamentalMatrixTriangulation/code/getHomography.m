function H = getHomography(homoPts1, homoPts2)
% homoPts1 - from an image
%           (x, y, 1) is a set of points (N-by-3, N>=4) and each row  
%           is a point in 2-dim projective coordinates (homogeneous coods).
% homoPts2 - from the other image
%           (x', y', 1) is a set of points (N-by-3, N>=4) and each row  
%           is a point in 2-dim projective coordinates (homogeneous coods).

    if size(homoPts1) ~= size(homoPts2)
        error('The size of homoPts1 and homoPts2 do not match.')
    end
    
    if size(homoPts1, 1)<4 || size(homoPts2, 1)<4
        error('Insufficient matches to solve homography matrix.')
    end
    
    numMatches = size(homoPts1, 1);
    
    % create matrix A (2*numMatches-by-9)
    A = [];
    for i = 1:numMatches
        p1 = homoPts1(i, :);
        p2 = homoPts2(i, :);
        
        %A_i = [p1 , zeros(1, 3) , -p1*p2(1);
        %       zeros(1, 3) , p1 , -p1*p2(2);];
        %A_i = [zeros(1, 3) , p1 , -p1*p2(1);
        %        p1 , zeros(1, 3), -p1*p2(2)];
        A_i = [ zeros(1, 3) , -p1 , p2(2)*p1;
                p1 , zeros(1, 3) , -p2(1)*p1];
        
        A = [A; A_i];
    end
    
    % solve A*h=0
    [~, ~, V] = svd(A);
    h = V(:, 9);
    %H = reshape(h, 3, 3)';
    H = reshape(h, 3, 3);
    H = H ./ H(3, 3);
end
