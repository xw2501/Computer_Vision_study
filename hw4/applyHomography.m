%% applyHomography, apply the homography to source points and return the destination points
function dest_pts_nx2 = applyHomography(H_3x3, src_pts_nx2)
N = size(src_pts_nx2, 1);
src_pts_nx2 = [src_pts_nx2, ones(N, 1)].';
dest_pts_nx2 = H_3x3*src_pts_nx2;

for i = 1:N    % scale destination points so that z in (x,y,z) equals to 1
    scale = 1 / dest_pts_nx2(3, i);
    dest_pts_nx2(:, i) = dest_pts_nx2(:, i) * scale;
end

dest_pts_nx2 = dest_pts_nx2(1:2, :).';