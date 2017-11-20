function [wordMap] = getVisualWords(img, filterBank, dictionary)
% Compute visual words mapping for the given image using the dictionary of visual words.

% Inputs:
% 	img: Input RGB image of dimension (h, w, 3)
% 	filterBank: a cell array of N filters
% Output:
%   wordMap: WordMap matrix of same size as the input image (h, w)

    %% TODO Implement your code here
    filterResponses = extractFilterResponses(img, filterBank);
    
    % compute the distance between the filter responses and the visual words
    % the size of dist is K x MH
    dist = pdist2(dictionary', filterResponses, 'euclidean');
    
    % find the minimum distance and record the index(visual word)
    % each pixel belong to the visual word wrt the minimum distance
    [minDist, ind] = min(dist, [], 1);
    imgDim = size(img);
    wordMap = reshape(ind', imgDim(1:2));

end
