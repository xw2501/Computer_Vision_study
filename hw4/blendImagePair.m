%% blendImagePair, blend two images according to the images and masks
function out_img = blendImagePair(wrapped_imgs, masks, wrapped_imgd, maskd, mode)
out_img = zeros(size(wrapped_imgs));
masks = masks / 255;    % regulize masks for computation
maskd = maskd / 255;    % regulize maskd for computation
masks_ex = cat(3, masks, masks, masks);     % generate mask for RGB channels
maskd_ex = cat(3, maskd, maskd, maskd);
if strcmp(mode, 'overlay')  % if 'overlay', draw the desination image over the source image
    out_img = wrapped_imgs.*masks_ex.*(1-maskd_ex) + wrapped_imgd.*maskd_ex;
end
if strcmp(mode, 'blend')    % if 'blend', using weights to blend images
    out_imgs = zeros(size(wrapped_imgs));
    out_imgd = zeros(size(wrapped_imgd));

    weightd = 1-maskd;  % reverse the mask so that the boundary has value 1 and the mask has value 0
    weights = 1-masks;
    weightd = bwdist(weightd);  % use 'bwdist' to compute the weight
    weights = bwdist(weights);
    
    weight = weights + weightd;     % sum the weight
    weight(find(weight==0)) = 1;    % to avoid 'divide 0' error
    
    % blend two images according to weights and weightd
    for i = 1:3
        out_imgs(:, :, i) = rdivide(double(wrapped_imgs(:, :, i)).*weights, weight);
        out_imgd(:, :, i) = rdivide(double(wrapped_imgd(:, :, i)).*weightd, weight);
    end
    out_img = out_imgs + out_imgd;
    if length(find(round(out_img)>1))~=0
        out_img = uint8(out_img);   % change the format of output image
    end
end