function refocusApp(rgb_stack, depth_map)
figure,
img = zeros(679, 860, 3, 25);
current_index = 1;

for i = 1:25
    img(:, :, :, i) = cell2mat(rgb_stack(i));
end

imshow(img(:, :, :, current_index));
while(true)    % continous showing one of the images
    [input_y, input_x] = ginput();
    input_x = round(input_x);
    input_y = round(input_y);
    display(input_x);
    display(input_y);
    if input_x<1 || input_y<1 || input_x>679 || input_y>860    % if input index is out of bound, break
        break;
    end
    to_index = depth_map(input_x, input_y);
    for i = current_index:to_index    % show the images one by one
        imshow(img(:, :, :, i));
        pause(0.3);
    end
    current_index = to_index;       % update current index
end
close(gcf);