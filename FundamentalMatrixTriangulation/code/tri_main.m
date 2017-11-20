clc; clear all;
% load the camera matrices and determine the camera centers
camera_matrix1 = load('../data/part2/house1_camera.txt');
camera_center1 = get_cam_center(camera_matrix1);

camera_matrix2 = load('../data/part2/house2_camera.txt');
camera_center2 = get_cam_center(camera_matrix2);

matches = load('../data/part2/house_matches.txt');
numMatches = size(matches, 1);

% homogenize the coordinates as (x, y, 1)
x1 = [matches(:,1:2), ones(numMatches, 1)];
x2 = [matches(:,3:4), ones(numMatches, 1)];

triangPts = zeros(numMatches, 3);
projImg1 = zeros(numMatches, 2);
projImg2 = zeros(numMatches, 2);

% calcualte the triangulated points and project them onto each image plane
for i = 1:numMatches
    pt1 = x1(i,:);
    pt2 = x2(i,:);
    
    crossProduct1 = [    0   , -pt1(3) ,  pt1(2); 
                      pt1(3) ,    0    , -pt1(1); 
                     -pt1(2) ,  pt1(1) ,    0   ];
                 
    crossProduct2 = [    0   , -pt2(3) , pt2(2); 
                       pt2(3),    0    ,-pt2(1); 
                      -pt2(2),  pt2(1) ,   0   ];    
                  
    assembly = [ crossProduct1 * camera_matrix1;
                 crossProduct2 * camera_matrix2 ];
    
    [~,~,V] = svd(assembly);
    homo_triangPts = V(:,end)';
    
    % de-homogenize
    triangPts(i,:) = dehomo(homo_triangPts);
    
    %project the triangulated point
    homoProj1 = (camera_matrix1 * homo_triangPts')';
    
    projImg1(i,:) = dehomo((camera_matrix1 * homo_triangPts')');
    projImg2(i,:) = dehomo((camera_matrix2 * homo_triangPts')');
    
end

% plot the triangulated points and the camera centers
figure; 
axis equal; hold on; 
plot3(-triangPts(:,1), triangPts(:,2), triangPts(:,3), '.r');
plot3(-camera_center1(1), camera_center1(2), camera_center1(3),'*b');
plot3(-camera_center2(1), camera_center2(2), camera_center2(3),'*g');
grid on; 
xlabel('x'); ylabel('y'); zlabel('z');
axis equal; hold off;
 
% calculate the error distance
distances1 = diag(dist2(matches(:,1:2), projImg1));
distances2 = diag(dist2(matches(:,3:4), projImg2));
display(['Mean Residual img1: ', num2str(mean(distances1))]);
display(['Mean Residual img2: ', num2str(mean(distances2))]);