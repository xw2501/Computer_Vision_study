function mask = computeMask(img_cell)
mask = zeros(size(cell2mat(img_cell(1))));
N = size(img_cell, 1);
threshold = 0;

for i = 1:N
    mask = mask + im2bw(cell2mat(img_cell(i)), threshold);  % add the new image to the previous images
end

mask(find(mask~=0)) = 1;    % where the value is not 0 is the image and set to 1
                            % where the value is 0 is the background and set to 0
