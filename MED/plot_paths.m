function [] = plot_paths(image, ant_paths)
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here
figure
imshow(image)
hold on
for i = 1:length(ant_paths)
    plot(ant_paths{i}(:,1), ant_paths{i}(:,2), '-')
end