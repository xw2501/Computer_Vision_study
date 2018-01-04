function labeled_img = generateLabeledImage(gray_img, threshold)
%% generate a clean binary image
figure, imshow(gray_img);
title('gray image')
binary_img = im2bw(gray_img, threshold);
figure, imshow(binary_img);
title('binary image')
k = 4;
labeled_img = bwlabel(binary_img, k);