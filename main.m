close all; clear; clc;

original_image = imread("./imgs/alice.png");

binary_image = im2bw(original_image);

edge_image = edge(binary_image);

[rows, cols] = size(edge_image);

bottom_index = [];
for x = 1:cols
    if edge_image(rows, x)
        bottom_index = [bottom_index, x];
    end
end

for i = 1:length(bottom_index) / 2
    edge_image(rows, bottom_index(2 * i - 1): bottom_index(2 * i)) = 1;
end

edge_points = search_edge_point(edge_image);
points_complex = edge_points(:, 1) + edge_points(:, 2) * 1j;
edge_point_freq = fft(points_complex);

nums = length(edge_point_freq);
edge_point_time = zeros(nums, nums);
edge_point_time_sum = zeros(nums, 1);
for x = 1:nums
    for u = 1:nums
        edge_point_time(x, u) = (edge_point_freq(u) * exp(1j * 2 * pi * (u - 1) * (x - 1) / nums)) / nums; 
    end
    edge_point_time_sum(x) = sum(edge_point_time(x, :));
end

hfig = figure(1);
set(hfig, 'position', get(0,'ScreenSize'));
hold on;
axis equal;
xlim([0,cols]);
ylim([-rows, 0]);
set(gca,'XTick',[],'YTick',[]);
hline = [];
for i = 1:nums
    edge_point_time_cumsum = cumsum(edge_point_time(i, :));
    hline = plot(imag(edge_point_time_cumsum), -real(edge_point_time_cumsum), 'b- .');
    scatter(imag(edge_point_time_cumsum(end)), -real(edge_point_time_cumsum(end)), 'black.');
    pause(0.01);
    delete(hline);
end