function index_map = generateIndexMap(gray_stack, w_size)
index_map = zeros(679, 860, 25);
img = zeros(681, 862, 25);      % for calculating 'similar laplacian' of each point, pad origin image with 0
img_lap = zeros(679+2*w_size, 860+2*w_size, 25);    % for calculating sum of 'similar laplacian' within a window, pad matrix of laplacian with 0
lap_x = [-1, 2, -1];
lap_x = cat(3, lap_x, lap_x, lap_x, lap_x, lap_x,...    % extend lap_x to compute 25 images in a single computation
    lap_x, lap_x, lap_x, lap_x, lap_x,...
    lap_x, lap_x, lap_x, lap_x, lap_x,...
    lap_x, lap_x, lap_x, lap_x, lap_x,...
    lap_x, lap_x, lap_x, lap_x, lap_x);
lap_y = [-1; 2; -1];
lap_y = cat(3, lap_y, lap_y, lap_y, lap_y, lap_y,...    % same as lap_x
    lap_y, lap_y, lap_y, lap_y, lap_y,...
    lap_y, lap_y, lap_y, lap_y, lap_y,...
    lap_y, lap_y, lap_y, lap_y, lap_y,...
    lap_y, lap_y, lap_y, lap_y, lap_y);
max_times = zeros(679, 860);

for i = 1:25
    img(2:680, 2:861, i) = cell2mat(gray_stack(i));
end

for i = 1:679    % compute 'similar laplacian' for each pixel
    for j = 1:860
        img_lap(i+w_size, j+w_size, :) = abs(sum(img(i, j:j+2, :).*lap_x, 2)) + abs(sum(img(i:i+2, j, :).*lap_y, 1));
    end
end

for i = 1:679    % find the index with max sum within the window
    for j = 1:860
        index_map(i, j, :) = sum(sum(img_lap(i:i+2*w_size, j:j+2*w_size, :), 1), 2);
        index = find(index_map(i, j, :)==max(index_map(i, j, :)));
        max_times(i, j) = index(1);
    end
end

index_map = max_times;

