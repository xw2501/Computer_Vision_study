
function result = computeFlow(img1, img2, win_radius, template_radius, grid_MN)
height = grid_MN(1);    % size of needle map
width = grid_MN(2);
opticalFlow = zeros(height-1, width-1, 2);  % initialize optical flow matrix for needle map
corrMax = zeros(height-1, width-1);
heightScale = round(size(img1, 1) / height);    % scale of needle map size and real image size
widthScale = round(size(img1, 2) / width);
for i = 1:height-1
    for j = 1:width-1
        indexI = i*heightScale;
        indexJ = j*widthScale;
        topWindow = max(1, indexI-win_radius);  % the index of window for search
        botWindow = min(height*heightScale, indexI+win_radius);
        lefWindow = max(1, indexJ-win_radius);
        rigWindow = min(width*widthScale, indexJ+win_radius);
        window = img2(topWindow:botWindow, lefWindow:rigWindow);
        topTemp = max(1, indexI-template_radius);   % the index of template for matching
        botTemp = min(height*heightScale, indexI+template_radius);
        lefTemp = max(1, indexJ-template_radius);
        rigTemp = min(width*widthScale, indexJ+template_radius);
        template = img1(topTemp:botTemp, lefTemp:rigTemp);
        heightOffset = indexI - topWindow + round((botTemp - topTemp)/2);   % this offset is for getting the right index of maximum matching point
        widthOffset = indexJ - lefWindow + round((rigTemp - lefTemp)/2);
        corrMap = normxcorr2(template, window);
        [mapHeight, ~] = size(corrMap);
        index = find(corrMap==max(max(corrMap)));
        corrMax(i, j) = max(max(corrMap));
        index = index(1);   % choose the first maximum matching point as the destination
        opticalFlow(i, j, 1) = mod(index-1, mapHeight) - heightOffset;  % compute the vector from the source to destination
        opticalFlow(i, j, 2) = floor(index/mapHeight) - widthOffset;
    end
end
figure, % fraw the optical flow needle map
imshow(img1);
for i = 1:height-1
    for j = 1:width-1
        if corrMax(i, j)<0.94
            continue;   % only draw the needle where we are confident with the result
        end
        hold on;
        quiver(j*widthScale, i*heightScale, opticalFlow(i, j , 2), opticalFlow(i, j, 1), 'Color', 'r', 'LineWidth', 1);
    end
end
gfframe = getframe(gcf);
result = frame2im(gfframe);