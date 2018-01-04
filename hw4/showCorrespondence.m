%% result_img, generate a new image and draw the line between corresponding points
function result_img = ...
    showCorrespondence(orig_img, warped_img, src_pts_nx2, dest_pts_nx2)
result_img = [orig_img, warped_img];    % connect two images to get a new image
x_offset = size(orig_img, 2);   % offset of the second image
N = size(src_pts_nx2, 1);

figure,
imshow(result_img);
for i = 1:N    % draw a line between corresponding points   
    hold on;
    line([src_pts_nx2(i, 1), dest_pts_nx2(i, 1)+x_offset], [src_pts_nx2(i, 2), dest_pts_nx2(i, 2)], 'LineWidth',2, 'Color', [1, 1, 0]);
end
gfframe = getframe(gcf);    % save the image                                            
result_img = frame2im(gfframe);