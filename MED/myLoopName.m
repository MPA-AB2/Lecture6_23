% function [returnCell] = myLoopName(pathToAnts)
clear all; close all; clc;
pathToAnts = 'V:\Ladicky\AB2\cv6\Lecture6_23\MED\Ants';
fileList = dir(fullfile(pathToAnts, '*.jpg'));
returnCell = cell(size(fileList,1),1);
for i=1:size(fileList,1)
    thisImageName = strcat(fileList(i).folder,'\',fileList(i).name);
    thisImage = im2gray(imread(thisImageName));
    
    thisImage(thisImage<50) = 0;
    points = detectSIFTFeatures(thisImage,"ContrastThreshold",0.025);
    points = points(points.Scale>4);
    points = points(points.Scale<10);
    locations = points.Location; %matrix with random values
    k = dsearchn(P,PQ)
    imshow(thisImage);
    hold on;
    plot(points)
    [row,col] = find(thisImage>0);
    returnCell{i} = [row,col];
end

% end