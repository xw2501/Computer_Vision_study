function [center, radius] = findSphere(img)
threshold = 0;
bw_img = im2bw(img, threshold);
area = sum(sum(bw_img));    % calculate area of circle
radius = sqrt(area/pi);     % calculate radius
bw_row = sum(bw_img, 1);
bw_col = sum(bw_img, 2);
center = zeros(2, 1);
center(2) = (find(bw_row~=0, 1, 'first') + find(bw_row~=0, 1, 'last')) / 2;     % center coordinate on y axis
center(1) = (find(bw_col~=0, 1, 'first') + find(bw_col~=0, 1, 'last')) / 2;     % center coordinate on x axis
