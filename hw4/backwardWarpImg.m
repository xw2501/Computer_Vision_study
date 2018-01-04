%% backwardWarpImg, return the backward warp result and mask
function [mask, result_img] = backwardWarpImg(src_img, resultToSrc_H,...
    dest_canvas_width_height)
width = dest_canvas_width_height(1);    % find the size of canvas
height = dest_canvas_width_height(2);
result_img = zeros(height, width, 3);
mask = zeros(height, width);
width_limit = size(src_img, 2);     % find the size of source image
height_limit = size(src_img, 1);
dest_matrix = zeros(height * width, 3);     % a matrix used for mapping the points

for i = 1:height    % create a matrix for mapping the destination canvas back to source image
    dest_matrix((i-1)*width+1:i*width, :) = [(1:width).', ones(width, 1)*i, ones(width, 1)];
end
mapping = (resultToSrc_H * dest_matrix.').';    % mapping the destination canvas to source image
for i = 1:height*width    % scale the mapping so that all points in mapping matrix has a 'z' equals to 1
    scale = 1 / mapping(i, 3);
    mapping(i, :) = mapping(i, :) * scale;
end
for i = 1:height*width    % draw the source image on canvas, using backward warp according to mapping matrix, and generate mask 
    x_index = round(mapping(i, 1));
    y_index = round(mapping(i, 2));
    if x_index>0 && x_index<width_limit && y_index>0 && y_index<height_limit
        mask(ceil(i/width), mod(i, width)+1) = 1;
        result_img(ceil(i/width), mod(i, width)+1, :) = src_img(y_index, x_index, :);
    end
end