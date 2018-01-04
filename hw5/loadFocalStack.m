%%
% create a cell to store the stack
function [rgb_stack, gray_stack] = loadFocalStack(focal_stack_dir)
rgb_stack = cell(25, 1);
gray_stack = cell(25, 1);

for i = 1:25
    img = imread([focal_stack_dir '/frame' num2str(i) '.jpg']);
    rgb_stack(i) = mat2cell(im2double(img), 679, 860, 3);
    gray_stack(i) = mat2cell(rgb2gray(img), 679, 860);
end

