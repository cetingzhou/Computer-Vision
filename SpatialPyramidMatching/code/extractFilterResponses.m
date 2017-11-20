function [filterResponses] = extractFilterResponses(img, filterBank)
% Extract filter responses for the given image.
% Inputs: 
%   img:                a 3-channel RGB image with width W and height H
%   filterBank:         a cell array of N filters
% Outputs:
%   filterResponses:    a W x H x N*3 matrix of filter responses

% TODO Implement your code here
% Convert to Lab

% for gray-scale images
if (size(img, 3) == 1)
    img = repmat(img, [1, 1, 3]);
end

% convert image into L*a*b
doubleI = double(img);
[L, a, b] = RGB2Lab(doubleI(:, :, 1), doubleI(:, :, 2), doubleI(:, :, 3));

% count the number of the pixels of an image
pixelNum = numel(doubleI(:, :, 1));

% filter responses with size (M*N) x 3F
F = length(filterBank);
filterResponses = zeros(pixelNum, 3*F);

% apply each filter to each channel
for i = 1:length(filterBank)
    filter = filterBank{i};
    filterResponses(:, (i-1)*3+1) = ...
        reshape(imfilter(L, filter, 'same', 'conv'), pixelNum, 1);
    filterResponses(:, (i-1)*3+2) = ...
        reshape(imfilter(a, filter, 'same', 'conv'), pixelNum, 1);
    filterResponses(:, (i-1)*3+3) = ...
        reshape(imfilter(b, filter, 'same', 'conv'), pixelNum, 1);
end

end
