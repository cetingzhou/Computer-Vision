function compositeImg = stitch(img1, img2, H)
homoTrans = maketform('projective', H);
% transfrom the imge and store the boundaries of the transformed image
[~, x_img2Trans, y_img2Trans] = imtransform(img2, homoTrans, 'XYScale', 1);
img1Trans = maketform('affine', eye(3));
% put the transfomed images into a same size frame
x = [min(1, x_img2Trans(1)), max(size(img1, 2), x_img2Trans(2))];
y = [min(1, y_img2Trans(1)), max(size(img1, 1), y_img2Trans(2))];
img2Trans = imtransform(img2, homoTrans, 'XData', x, 'YData', y, 'XYScale', 1);
img1Trans = imtransform(img1, img1Trans, 'XData', x, 'YData', y, 'XYScale', 1);

% composite two images by simply averaging the pixel values where the two images overlap
black = [0 0 0];
for i = 1:size(img1Trans, 1)
    for j = 1:size(img1Trans, 2)
        img1Pixel = [img1Trans(i, j, 1) img1Trans(i, j, 2) img1Trans(i, j, 3)];
        img2Pixel = [img2Trans(i, j, 1) img2Trans(i, j, 2) img2Trans(i, j, 3)];
        if isequal(black, img1Pixel)
            compositeImg(i, j, :) = img2Trans(i, j, :);
        else if isequal(black, img2Pixel)
            compositeImg(i, j, :) = img1Trans(i, j, :);
            else 
            % averaging the pixel values where the two images overlap
            %compositeImg(i, j, :) = (img1Trans(i, j, :) + img2Trans(i, j, :))/2;
            compositeImg(i, j, :) = (img1Trans(i, j, :) + img2Trans(i, j, :))/2;
            end
        end
    end
end

end
       
            