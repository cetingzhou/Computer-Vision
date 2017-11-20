function [filterBank, dictionary] = getFilterBankAndDictionary(imPaths)
% Creates the filterBank and dictionary of visual words by clustering using kmeans.

% Inputs:
%   imPaths: Cell array of strings containing the full path to an image 
%            or relative path wrt the working directory.
% Outputs:
%   filterBank: N filters created using createFilterBank()
%   dictionary: a dictionary of visual words from the filter responses using k-means.

    filterBank  = createFilterBank();

    %% TODO Implement your code here
    % Number of visual words in dictionary: K is [100, 300].
    K = 100;
    
    % Number of random pixels to take the response of: alpha is [50, 200].
    alpha = 50;
    
    alphaT = zeros(alpha * length(imPaths), 1, 3);
    
    % Load each file by iterating from 1:length(imPaths)
    for T = 1:length(imPaths)
        
        img = imread(imPaths{T});
        % if image is gray-scale
        if (size(img, 3) == 1)
            img = repmat(img, [1, 1, 3]);
        end
        
        % Generate a random permutation of the pixels to select for their
        % responses.
        numPixel = numel(img(:,:,1));
        randomPixels = randperm(numPixel, alpha);
    
        r = img(:,:,1);
        g = img(:,:,2);
        b = img(:,:,3);
        rCol = r(:);
        gCol = g(:);
        bCol = b(:);
        rAlphaPixels = rCol(randomPixels);
        gAlphaPixels = gCol(randomPixels);
        bAlphaPixels = bCol(randomPixels);
        alphaT(1+alpha*(T-1) : T*alpha, 1) = rAlphaPixels;
        alphaT(1+alpha*(T-1) : T*alpha, 2) = gAlphaPixels;
        alphaT(1+alpha*(T-1) : T*alpha, 3) = bAlphaPixels;
    end

    filterResponses = extractFilterResponses(alphaT, filterBank);
    [~, dictionary] = kmeans(filterResponses, K, 'EmptyAction', 'drop');
    dictionary = dictionary';
end

