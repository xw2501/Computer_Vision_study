%% stitchImg, stitch several images
function stitched_img = stitchImg(varargin)
N = length(varargin);   % number of images
image = cell2mat(varargin(1));  % convert image from cell back to matrix
ransac_n = 200; % Max number of iteractions
ransac_eps = 3; % Acceptable alignment error 
for i = 2:N    % stitch images in iteration, when there is no more images to be connected, stop
    width = size(image, 2);     % size of current image
    height = size(image, 1);
    img_width = size(cell2mat(varargin(i)), 2);     % size of new image
    img_height = size(cell2mat(varargin(i)), 1);
    [xs, xd] = genSIFTMatches(cell2mat(varargin(i)), image);        % find matched points between current image and new image
    [inliers_id, H_3x3] = runRANSAC(xs, xd, ransac_n, ransac_eps);  % use 'runRANSAC' to filter outliers
    pt = zeros(4, 3);   % find the position after applied homography to new image
    pt(1, :) = (H_3x3 * [1;1;1]).';
    pt(2, :) = (H_3x3 * [img_width;1;1]).';
    pt(3, :) = (H_3x3 * [1;img_height;1]).';
    pt(4, :) = (H_3x3 * [img_width;img_height;1]).';
    for j = 1:4
        scale = 1 / pt(j, 3);
        pt(j, :) = round(pt(j, :) * scale);
    end
    width_l = min(0, min(pt(:, 1)));    % find the size of the connected image
    width_r = max(width, max(pt(:, 1)));
    height_t = min(0, min(pt(:, 2)));
    height_b = max(height, max(pt(:, 2)));
    new_img = zeros(height_b-height_t, width_r-width_l, 3); % create an output image of the size of connected image
    x_offset = -min(0, width_l);    % offset of current image
    y_offset = -min(0, height_t);
    new_img(1+y_offset:height+y_offset, 1+x_offset:width+x_offset, :) = image;  % draw the current image on the output image
    H_3x3 = [1, 0, x_offset; 0, 1, y_offset; 0, 0, 1] * H_3x3;  % based on the offset of current image, also apply the offset to homography
    [maskd, dest_img] = backwardWarpImg(cell2mat(varargin(i)), inv(H_3x3), [size(new_img, 2), size(new_img, 1)]);   % use 'backwardWarpImg' to compute destination image and mask
    masks = zeros(size(new_img, 1), size(new_img, 2));  % mask of output image
    for j = 1:size(new_img, 2)
        for k = 1:size(new_img, 1)
            if sum(new_img(k, j, :))~=0
                masks(k, j) = 1;
            end
        end
    end
    image = blendImagePair(new_img, masks*255, dest_img, maskd*255, 'blend');   % use 'blendImagePair' to connect output image and new image
end
stitched_img = image;