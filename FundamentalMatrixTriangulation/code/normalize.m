function [homoNormal, T] = normalize(homoPts)

means = mean(homoPts, 1);
newhomoPts(:, 1) = homoPts(:, 1) - means(1);
newhomoPts(:, 2) = homoPts(:, 2) - means(2);

dist = sqrt(newhomoPts(:, 1).^2 + newhomoPts(:, 2).^2);
scale = sqrt(2) / mean(dist);

T = [scale , 0 , -scale*means(1);
     0 , scale , -scale*means(2);
     0 ,     0 ,       1        ];
 
homoNormal = (T * homoPts')';

end
