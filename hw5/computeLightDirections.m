function light_dirs_5x3 = computeLightDirections(center, radius, img_cell)
N = size(img_cell, 1);
light_dirs_5x3 = zeros(N, 3);
source_intensity = zeros(N, 1);

for i = 1:size(img_cell)
    img = cell2mat(img_cell(i));        % transform image from cell to matrix
    height = size(img, 1);
    source_intensity(i) = max(max(img));    % find the point with highest intensity
    max_point = find(img==source_intensity(i));     % find the index of the point
    x_ = mean(max_point / height) - center(1) + 1;  % calculate the direction vector according to center and highest intensity point
    y_ = mean(mod(max_point, height)) - center(2);
    z_ = sqrt(radius^2 - x_ - y_);
    length = sqrt(x_^2 + y_^2 + z_^2);      % normalize direction vector
    light_dirs_5x3(i, :) = [x_, y_, z_] / length;
end