function [] = plot_paths1(ant_paths)
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here
pathToAnts = 'V:\4_mag\Lecture6_23\MED\Ants';
fileList = dir(fullfile(pathToAnts, '*.jpg'));
    bar = ["r","b","g","m","c","y"];
for i = 1:size(fileList,1)
    image = strcat(fileList(i).folder,'\',fileList(i).name);
    figure (1)
    imshow(image)
    hold on
    for j=1:6
    line(ant_paths{j}(1:i,1), ant_paths{j}(1:i,2),'Color',bar(j))
    end
    hold off
    
end