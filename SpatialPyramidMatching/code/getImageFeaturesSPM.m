function [h] = getImageFeaturesSPM(layerNum, wordMap, dictionarySize)
% Compute histogram of visual words using SPM method
% Inputs:
%   layerNum: Number of layers (L+1)
%   wordMap: WordMap matrix of size (h, w)
%   dictionarySize: the number of visual words, dictionary size
% Output:
%   h: histogram of visual words of size {dictionarySize * (4^layerNum - 1)/3} (l1-normalized, ie. sum(h(:)) == 1)

    %% TODO Implement your code here
    [H, W] = size(wordMap);
    L = layerNum - 1;
    h = [];
    % create a mult-layer cell to store the histograms of each layer
    hist_cell = cell(2^L, 2^L, layerNum);
    
    if layerNum == 1
        [h] = getImageFeatures(wordMap, dictionarySize);
    end
    
    if layerNum > 1
        % first compute the histograms of the finest layer
        for l = L:-1:0
            if l==0 || l==1
                weight = 1 / 2^L;
            else
                weight = 2^(l - L - 1);
            end
            
            for row = 1:2^l
                for col = 1:2^l
                    if l == L
                        temp = getImageFeatures(wordMap(...
                            floor(H/2^l)*(row-1)+1 : floor(H/2^l)*row,...
                            floor(W/2^l)*(col-1)+1 : floor(W/2^l)*col),...
                            dictionarySize);
                        hist_cell{row, col, l+1} = temp;
                    else
                        % histograms of coarser layers can be aggregated
                        % from finer ones.
                        hist_cell{row, col, l+1} = ...
                            hist_cell{2^row-1, 2^col-1, l+2} + ...
                            hist_cell{2^row-1, 2^col, l+2} + ...
                            hist_cell{2^row, 2^col-1, l+2} + ...
                            hist_cell{2^row, 2^col, l+2};
                    end
                    h = [h; hist_cell{row, col, l+1} * weight];
                end
            end
        end
        % normalization
        h = h / sum(h);
        
end