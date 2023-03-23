% function [returnCell] = myLoopName(pathToAnts)
clear all; close all; clc;
pathToAnts = 'V:\Ladicky\AB2\cv6\Lecture6_23\MED\Ants';
fileList = dir(fullfile(pathToAnts, '*.jpg'));
returnCell = cell(size(fileList,1),1);
for i=1:size(fileList,1)
    thisImage = strcat(fileList(i).folder,'\',fileList(i).name);
    disp(thisImage);
    thisImage = im2gray(imread(thisImage));
    thisImage = thisImage<30;
    [row,col] = find(thisImage>0);
    returnCell{i} = [row,col];
end

% end