function line_detected_img = lineFinder(orig_img, hough_img, hough_threshold)
line_detected_img = orig_img;                                           % initialize parameters
figure, imshow(line_detected_img);
theta_num = size(hough_img, 1);
rho_num = size(hough_img, 2);
theta_range = pi;
theta_bin = theta_range / theta_num;
rho_range = sqrt(size(orig_img, 1)^2 + size(orig_img, 2)^2);
rho_bin = rho_range * 2 / rho_num;
fil_theta = 3;                                                          % block size of suppression on theta
fil_rho = 2;                                                            % block size of suppression on rho

%% preprocessing
for i = theta_num-fil_theta:theta_num    % supress points aournd theta=pi -- margin part
    for j = 1:round(rho_num/2)
        if (hough_img(i, j)>=hough_threshold)
            hough_img(i, j) = 0;
        end
    end
end

for i = 1:fil_theta    % suppress points within block -- margin part
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

for i = 1+fil_theta:theta_num-fil_theta    % suppress points within block -- middle part
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

%% draw lines
for i = 1:theta_num    % draw lines based on theta_rho pair with value larger than threshold
    for j = 1:rho_num
        if (hough_img(i, j)>=hough_threshold)
            x_set = [1:size(line_detected_img, 2)];
            y_set = (x_set*sin((i-1)*theta_bin) + j*rho_bin - rho_range) / cos((i-1)*theta_bin);
            hold on;
            line(x_set, y_set, 'LineWidth', 3, 'Color', 'y');
        end
    end
end

gfframe = getframe(gcf);                                                % save drawn image
line_detected_img = frame2im(gfframe);