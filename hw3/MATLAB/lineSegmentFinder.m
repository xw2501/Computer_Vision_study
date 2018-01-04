function cropped_line_img = lineSegmentFinder(orig_img, hough_img, hough_threshold)

cropped_line_img = orig_img;
figure, imshow(cropped_line_img);

edge_img = edge(orig_img, 'canny', 0.12);

theta_num = size(hough_img, 1);                                         % initialize parameters
rho_num = size(hough_img, 2);
theta_range = pi;
theta_bin = theta_range / theta_num;
rho_range = sqrt(size(orig_img, 1)^2 + size(orig_img, 2)^2);
rho_bin = rho_range * 2 / rho_num;
fil_theta = 3;                                                          % preprocessing block size
fil_rho = 2;

%% preprocessing, same as part c
for i = theta_num-fil_theta:theta_num
    for j = 1:round(rho_num/2)
        if (hough_img(i, j)>=hough_threshold)
            hough_img(i, j) = 0;
        end
    end
end

for i = 1:fil_theta
    for j = 1+fil_rho:theta_num-fil_rho
        if (hough_img(i, j)>=hough_threshold)
            block = hough_img(1:i+fil_theta, j-fil_rho:j+fil_rho);
            if (hough_img(i, j)==max(max(block)))
                if(length(find(block==max(max(block))))~=1)
                    hough_img(i, j) = 0;
                end
            else
                hough_img(i, j) = 0;
            end
        end
    end
end

for i = 1+fil_theta:theta_num-fil_theta
    for j = 1+fil_rho:rho_num-fil_rho
        if (hough_img(i, j)>=hough_threshold)
            block = hough_img(i-fil_theta:i+fil_theta, j-fil_rho:j+fil_rho);
            if (hough_img(i, j)==max(max(block)))
                if(length(find(block==max(max(block))))~=1)
                    hough_img(i, j) = 0;
                end
            else
                hough_img(i, j) = 0;
            end
        end
    end
end

%% find line segment and draw lines
block_size = 4;                                                         % line segment search block size 
block_diff = 2;
for i = 1:theta_num    % go through all pair of (theta, rho) to search for line segments and draw it
    for j = 1:rho_num
        if (hough_img(i, j)>=hough_threshold)
            x_seg = [];
            y_seg = [];
            lines_start = zeros(2, 0);
            lines_end = zeros(2, 0);
            if (i>theta_num/4 && i<theta_num*3/4)    % in this case the search is done on y-aixs basis
                y_set = [1:size(cropped_line_img, 1)];    % y set is all points in image size(, 1)
                x_set = (y_set*cos((i-1)*theta_bin) - j*rho_bin + rho_range) / sin((i-1)*theta_bin);    % x set is the corresponding indice of y set
                for k = 1+block_size-block_diff:length(y_set)-block_size+block_diff    % search and save line points with edge points nearby
                    if (x_set(k)<(1+block_size+block_diff) || x_set(k)>(size(cropped_line_img, 2)-block_size-block_diff))
                        continue;
                    end
                    block = edge_img(y_set(k)-block_size+block_diff:y_set(k)+block_size-block_diff, round(x_set(k)-block_size-block_diff):round(x_set(k)+block_size+block_diff));
                    if (ismember(1, block))                             % if there is edge point in block, save this line point
                        x_seg(length(x_seg)+1) = x_set(k);
                        y_seg(length(y_seg)+1) = y_set(k);
                    end
                end
                lines_start(:, 1) = [1; 1];
                lines_end = lines_start;
                for k = 2:length(y_seg)    % generalize line segmennt according to saved points
                    if y_seg(k)==(y_seg(k-1) + 1)
                        lines_end(:, size(lines_end, 2)) = [k; k];
                    else
                        lines_start(:, size(lines_start, 2)+1) = [k: k];
                        lines_end(:, size(lines_end, 2)+1) = [k; k];
                    end
                end
                for k = 1:size(lines_start, 2)    % cut the line segment to have the same length as edge 
                    index_s = lines_start(1, k);
                    index_e = lines_end(1, k);
                    lines_start(:, k) = [x_seg(min(index_s+block_size, index_e)); y_seg(min(index_s+block_size, index_e))];
                    lines_end(:, k) = [x_seg(max(index_e-block_size, index_s)); y_seg(max(index_e-block_size, index_s))];
                end
            else    % in this case, search is done on x-axis basis
                x_set = [1:size(cropped_line_img, 2)];    % x set is all points in image size(, 1)
                y_set = (x_set*sin((i-1)*theta_bin) + j*rho_bin - rho_range) / cos((i-1)*theta_bin);    % y set is the corresponding indice of x set
                for k = 1+block_size-block_diff:length(x_set)-block_size+block_diff    % search and save line points with edge points nearby
                    if (y_set(k)<(1+block_size+block_diff) || y_set(k)>(size(cropped_line_img, 1)-block_size-block_diff))
                        continue;
                    end
                    block = edge_img(round(y_set(k)-block_size-block_diff):round(y_set(k)+block_size+block_diff), x_set(k)-block_size+block_diff:x_set(k)+block_size-block_diff);
                    if (ismember(1, block))
                        x_seg(length(x_seg)+1) = x_set(k);
                        y_seg(length(y_seg)+1) = y_set(k);
                    end
                end
                lines_start(:, 1) = [1; 1];
                lines_end = lines_start;
                for k = 2:length(x_seg)    % generalize line segmennt according to saved points
                    if x_seg(k)==(x_seg(k-1) + 1)
                        lines_end(:, size(lines_end, 2)) = [k; k];
                    else
                        lines_start(:, size(lines_start, 2)+1) = [k: k];
                        lines_end(:, size(lines_end, 2)+1) = [k; k];
                    end
                end
                for k = 1:size(lines_start, 2)    % cut the line segment to have the same length as edge
                    index_s = lines_start(1, k);
                    index_e = lines_end(1, k);
                    lines_start(:, k) = [x_seg(min(index_s+block_size, index_e)); y_seg(min(index_s+block_size, index_e))];
                    lines_end(:, k) = [x_seg(max(index_e-block_size, index_s)); y_seg(max(index_e-block_size, index_s))];
                end
            end
            for k = 1:size(lines_start, 2)    % draw line segments
                if sqrt((lines_start(1, k) - lines_end(1, k))^2 + (lines_start(2, k) - lines_end(2, k))^2) > 40
                    hold on;
                    line([lines_start(1, k), lines_end(1, k)], [lines_start(2, k), lines_end(2, k)], 'LineWidth', 3, 'Color', 'g');
                end
            end
        end
    end
end

gfframe = getframe(gcf);            % save drawn image
cropped_line_img = frame2im(gfframe);