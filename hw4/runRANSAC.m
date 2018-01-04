%% runRANSAC, implement the RANSAC algorithm
function [inliers_id, H] = runRANSAC(Xs, Xd, ransac_n, eps)
N = size(Xs, 1);    % initialize parameters
rand('seed',sum(100*clock));
max_point = 0;
H = zeros(3, 3);
for i = 1:ransac_n    % find the homography with most matched pairs
    index = randsample(N, 4);   % randomly choose 4 indice
    indice = [];
    H_temp = computeHomography(Xs(index, :), Xd(index, :)); % compute the homography according to chosen four pairs
    Xd_temp = (H_temp * [Xs.'; ones(1, N)]).';  % compute the transformed 'Xd' according to current homography
    match_point = 0;
    for j = 1:N    % find matched pairs of current homography
        scale = 1 / Xd_temp(j, 3);  % rescale the 'Xd' so that it has z equals to 1
        Xd_temp(j, :) = Xd_temp(j, :) * scale;  
        % if current pair is a match, add one to the counter and append
        % current index
        if Xd_temp(j, 1)>Xd(j, 1)-eps && Xd_temp(j, 1)<Xd(j, 1)+eps...
                && Xd_temp(j, 2)>Xd(j, 2)-eps && Xd_temp(j, 2)<Xd(j, 2)+eps
            match_point = match_point + 1;
            indice(size(indice, 1)+1, 1) = j;
        end
    end
    % if current homography has the most matched pairs, save current
    % homography and the indices of matched pairs
    if match_point>max_point
        max_point = match_point;
        H = H_temp;
        inliers_id = indice;
    end
end