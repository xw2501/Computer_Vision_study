%% 
% use all 5 images to compute normals and albedo using the method given in
% lecture
function [normals, albedo_img] = ...
    computeNormals(light_dirs, img_cell, mask)

points = find(mask==1);
albedo_img = zeros(size(cell2mat(img_cell(1))));
normals = zeros([size(cell2mat(img_cell(1))), 3]);
[height, width] = size(cell2mat(img_cell(1)));
img_num = length(img_cell);
img_array = zeros([height, width, img_num]);
for i = 1:img_num
    img_array(:, :, i) = cell2mat(img_cell(i));     % transform cell to matrix
end
S = light_dirs;

for i = 1:length(points)
    x_ = floor(points(i) / height) + 1;
    y_ = mod(points(i), height);
    I = img_array(y_, x_, :);
    I = reshape(I, 5, 1, 1);
    N = (S.'*S)^-1*S.'*I;
    albedo_img(y_, x_) = norm(N);   % albedo
    normals(y_, x_, :) = N / albedo_img(y_, x_);    % surface normals
end
albedo_img = albedo_img / 255;  % normalize albedo