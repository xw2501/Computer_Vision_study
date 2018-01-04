function hough_img = generateHoughAccumulator(img, theta_num_bins, rho_num_bins)
length = size(img, 2);                  % x length of origin image 
height = size(img, 1);                  % y length of origin image
points_dict = find(img~=0)-1;                                           % all the edge points
len_dict = floor(points_dict / height)+1;                               % x axis indice of edge points
hei_dict = mod(points_dict, height)+1;                                  % y axis indice of edge points

rho_range = sqrt(length^2 + height^2);                                  % range of tho
theta_range = pi;                                                       % range of theta

theta_bins = theta_range / theta_num_bins;
rho_bins = rho_range * 2 / rho_num_bins;
theta_dict = zeros(theta_num_bins, 1);
for i = 1:theta_num_bins    % reset theta range
    theta_dict(i) = (i-1)*theta_bins;
end
rho_dict = zeros(rho_num_bins, 1);
for i = 1:rho_num_bins    % reset rho range
    rho_dict(i) = i*rho_bins - rho_range;
end

hough_img = zeros(theta_num_bins, rho_num_bins);
for i = 1:theta_num_bins    % go through all theta and rho combination in edge image for polling
    for j = 1:rho_num_bins
        for k = 1:size(len_dict, 1)
            if (round((len_dict(k)*sin(theta_dict(i)) - cos(theta_dict(i))*hei_dict(k) + rho_dict(j)))==0)
                hough_img(i, j) = hough_img(i, j) + 1;
            end
        end
    end
end

hough_img = round(hough_img / max(max(hough_img)) * 255);               % rescale points value
