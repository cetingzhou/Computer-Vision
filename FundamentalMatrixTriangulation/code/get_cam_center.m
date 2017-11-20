function camera_center = get_cam_center( camera_matrix )
    [~, ~, V] = svd(camera_matrix);
    camera_center = V(:,end);
    camera_center = dehomo(camera_center');
end