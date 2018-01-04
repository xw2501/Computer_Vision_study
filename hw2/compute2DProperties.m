function [db, out_img] = compute2DProperties(orig_img, labeled_img)

%% compute objects number and create database
obj_num = max(max(labeled_img));            %object number
att_num = 7;                                %attribute number
db = zeros(att_num, obj_num);               %create database
temp = zeros(3, obj_num);                   %temp database for a' b' c'
for i = 1:obj_num
    db(1, i) = i;
end

%% compute other attributes
for i = 1:size(labeled_img, 1)                                                  %i--current row number
    for j = 1:size(labeled_img, 2)                                              %j--current column number
        if labeled_img(i, j)~=0
            db(7, labeled_img(i, j)) = db(7, labeled_img(i, j)) + 1;            %area
            db(2, labeled_img(i, j)) = db(2, labeled_img(i, j)) + i;            %row position
            db(3, labeled_img(i, j)) = db(3, labeled_img(i, j)) + j;            %column position
            temp(1, labeled_img(i, j)) = temp(1, labeled_img(i, j)) + i^2;      %a'
            temp(2, labeled_img(i, j)) = temp(2, labeled_img(i, j)) + i*j;      %b'/2
            temp(3, labeled_img(i, j)) = temp(3, labeled_img(i, j)) + j^2;      %c'
        end
    end
end
for i = 1:obj_num
    db(2, i) = db(2, i) / db(7, i);                                             %compute row position
    db(3, i) = db(3, i) / db(7, i);                                             %compute column position
    temp(1, i) = temp(1, i) - db(7, i)*db(2, i)^2;                              %compute a
    temp(2, i) = 2*(temp(2, i) - db(7, i)*db(2, i)*db(3, i));                   %compute b
    temp(3, i) = temp(3, i) - db(7, i)*db(3, i)^2;                              %compute c
    db(4, i) = (temp(1, i)+temp(3, i))/2 - sqrt((temp(1, i)-temp(3, i))^2+temp(2, i)^2)/2;      %compute minimum moment of inertia
    db(5, i) = atan2(temp(2, i), (temp(1, i)-temp(3, i)))/2;                    %compute orientation
    db(6, i) = db(4, i)/((temp(1, i)+temp(3, i))/2 + sqrt((temp(1, i)-temp(3, i))^2+temp(2, i)^2)/2);       %compute roundness
    db(7, i) = db(4, i)/db(7, i);                                               %compute attribute 7, (minimum moment of inertia)/(area)
end

%% illustrate centre and orientation
out_img = orig_img;
figure, imshow(out_img);
title('properties compute result');
for i = 1:obj_num
    hold on;
    scatter(db(3, i), db(2, i), 'b', '*');
    text(db(3, i) + 15, db(2, i), num2str(i), 'Color', 'r');
end

N = 100;                %length of orientation line
lines = zeros(obj_num, N);
xset = zeros(1, N);
for i = 1:obj_num
    for j = 1:N
        k = j + db(2, i) - N/2;
        xset(j) = round(k);
        lines(i, j) = round((k - db(2, i))*tan(db(5, i)) + db(3, i));
    end
    hold on;
    line(lines(i, :), xset(:), 'Color', 'g', 'LineStyle', '--');
end
hold off;
gfframe = getframe(gcf);
out_img = frame2im(gfframe);
