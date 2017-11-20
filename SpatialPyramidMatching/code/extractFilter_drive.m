img = imread('../data/library/sun_bgomlouerpzheglz.jpg');
filterBank = createFilterBank();
img_filtered = extractFilterResponses(img, filterBank);

% display = zeros(3,4,3);
display = cell(20,1);

L = zeros(size(img, 1), size(img, 2), length(filterBank));
a = zeros(size(img, 1), size(img, 2), length(filterBank));
b = zeros(size(img, 1), size(img, 2), length(filterBank));

layer_L = 1;
layer_a = 1;
layer_b = 1;

for i = 1:3:60
    L(:, :, layer_L) = reshape(img_filtered(:, i), ...
        size(img, 1), size(img, 2));
    layer_L = layer_L + 1;
end

for i = 2:3:60
    a(:, :, layer_a) = reshape(img_filtered(:, i), ...
        size(img, 1), size(img, 2));
    layer_a = layer_a + 1;
end

for i = 3:3:60
    b(:, :, layer_b) = reshape(img_filtered(:, i), ...
        size(img, 1), size(img, 2));
    layer_b = layer_b + 1;
end

for i = 1:20
    display{i} = cat(3, L(:, :, i), a(:, :, i), b(:, :, i));
end

for i = 1:20
    imwrite(display{i}, sprintf('../filter_collage_%d.jpg',i));
end



