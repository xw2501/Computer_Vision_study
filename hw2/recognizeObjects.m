function output_img = recognizeObjects(orig_img, labeled_img, obj_db)
%% compute properties of target image    
[db, ~] = compute2DProperties(orig_img, labeled_img);

% set this value to true to choose first method, set to false to choose second method
choose1 = false;

%% method one for matching-- choose the most 'like' one 
% match objects of origin image and objects of target image based on roundness and attribute 7
if choose1
    match = zeros(2, size(obj_db, 2));
    for i=1:size(match, 2)
        att_7 = Inf;                                %diffrence of attribute 7, by default Inf
        roundness = Inf;                            %diffrence of roundness, by default Inf
        for j=1:size(db, 2)
            if abs(db(7, j) - obj_db(7, i)) < att_7 && abs(db(6, j) - obj_db(6, i)) < roundness
                att_7 = abs(db(7, j) - obj_db(7, i));
                roundness = abs(db(6, j) - obj_db(6, i));
                match(1, i) = db(1, j);
            end
        end
    end
end

%% method two for matching-- use a threshold, choose the first object with a diffrence smaller than the threshold
% match objects of origin image and objects of target image based on roundness and attribute 7
if ~choose1
    threshold = 0.1;
    match = zeros(2, size(obj_db, 2));
    for i=1:size(match, 2)
        for j=1:size(db, 2)
            if abs(db(7, j) - obj_db(7, i))/obj_db(7, i) < threshold && abs(db(6, j) - obj_db(6, i))/obj_db(6, i) < threshold
                match(1, i) = db(1, j);
                break;
            end
        end
    end
end

%% output
output_img = orig_img;
figure, imshow(output_img);
title('match result');
for i = 1:size(match, 2)
    if match(1, i)==0
        continue;
    end
    hold on;
    scatter(db(3, match(1, i)), db(2, match(1, i)), 'b', '*');
    text(db(3, match(1, i)) + 15, db(2, match(1, i)) + match(2, i)*15, num2str(i), 'Color', 'r');
    for j = i+1:size(match, 2)
        if match(1, j)==match(1, i)
            match(2, j) = match(2, j) + 1;
        end
    end
end

N = 100;                %length of orientation line
lines = zeros(size(match, 2), N);
xset = zeros(1, N);
for i = 1:size(match, 2)
    if match(1, i)==0
        continue;
    end
    for j = 1:N
        k = j + db(2, match(1, i)) - N/2;
        xset(j) = round(k);
        lines(i, j) = round((k - db(2, match(1, i)))*tan(db(5, match(1, i))) + db(3, match(1, i)));
    end
    hold on;
    line(lines(i, :), xset(:), 'Color', 'g', 'LineStyle', '--');
end
hold off;
gfframe = getframe(gcf);
output_img = frame2im(gfframe);