%% computeHomography, compute the homography of soucre image and destination image
function H_3x3 = computeHomography(src_pts_nx2, dest_pts_nx2)
N = size(src_pts_nx2, 1);
A = zeros(2*N, 9);
for i = 1:N    % generate the A matrix
    A(2*i-1:2*i, :) = [src_pts_nx2(i, 1), src_pts_nx2(i, 2), 1, 0, 0, 0, -dest_pts_nx2(i, 1)*src_pts_nx2(i, 1), -dest_pts_nx2(i, 1)*src_pts_nx2(i, 2), -dest_pts_nx2(i, 1);...
        0, 0, 0, src_pts_nx2(i, 1), src_pts_nx2(i, 2), 1, -dest_pts_nx2(i, 2)*src_pts_nx2(i, 1), -dest_pts_nx2(i, 2)*src_pts_nx2(i, 2), -dest_pts_nx2(i, 2)];
end
[V, U] = eig(A.'*A);    % compute eigenvalue and vector of (A^T)A
U = U * ones(9, 1);     % transform the eigenvalues from a matrix to an vector
H_3x3 = V(:, find(U==min(U)));  % find the corresponding eigen vector of the smallest eigenvalue
H_3x3 = reshape(H_3x3, 3, 3).'; % reshape the vector to a 3x3 matrix