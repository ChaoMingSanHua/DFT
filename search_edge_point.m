function points = search_edge_point(img)
[rows, cols] = size(img);

points = [];
flag = false;
for y = 1:cols
    for x = rows:-1:1
        if img(y, x)
            start = [y, x];
            points = [points; start];
            flag = true;
            break;
        end
    end
    if flag
        break
    end
end

n_max = 200;
x_diff = [];
y_diff = [];
for n = 1:n_max
    x_diff_i = zeros(1, 8 * n);
    for i = 1:8 * n
        if i <= n
            x_diff_i(i) = -i + 1;
        elseif i <= 3 * n + 1
            x_diff_i(i) = -n;
        elseif i <= 5 * n
            x_diff_i(i) = i - 5 * n + n - 1;
        elseif i <= 7 * n + 1
            x_diff_i(i) = n;
        else
            x_diff_i(i) = 8 * n - i + 1;
        end
    end
    x_diff = [x_diff, x_diff_i];
    y_diff = [y_diff, x_diff_i(2*n+1:end), x_diff_i(1:2*n)];
end

new_point = start;
flag = false;
while norm(start - new_point) > 2 || length(points) < 5
    for n = 1:n_max
        for i = 1:8 * n
            if new_point(1) + y_diff(i + (n-1)*n*4) > 0 && new_point(1) + y_diff(i + (n-1)*n*4) <= 480 ...
                    && new_point(2) + x_diff(i + (n-1)*n*4) > 0 && new_point(2) + x_diff(i + (n-1)*n*4) <= 800
                if img(new_point(1) + y_diff(i + (n-1)*n*4), new_point(2) + x_diff(i + (n-1)*n*4)) && ...
                        ~(ismember([new_point(1) + y_diff(i + (n-1)*n*4), new_point(2) + x_diff(i + (n-1)*n*4)], points, "row"))
                    new_point = [new_point(1) + y_diff(i + (n-1)*n*4), new_point(2) + x_diff(i + (n-1)*n*4)];
                    points = [points; new_point];
                    flag = true;
                    break;
                end
            end
        end
        if flag
            flag = false;
            break;
        end
    end
end