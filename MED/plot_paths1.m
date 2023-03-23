function [] = plot_paths1(image, ant_paths)
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here
figure
imshow(image)
hold on
bar = ["r-","b-","g-","m-","c-","y-"];
for i = 1:length(ant_paths)
    plot(ant_paths{i}(:,1), ant_paths{i}(:,2), bar(i))
end