function [trajectory] = ant_tracking(path)

names = dir([path,'\*.jpg']);
%%

obr = imread([path,'\',names(1).name]);
obr = rgb2gray(obr);

obrn = obr;
% mean(mean(obr))/10
obrn(obr >= 30) = 0;
obrn(obr < 30) = 1;

    
se = strel('disk',3);
    
obrn = imdilate(obrn,se);
    
CC = bwconncomp(obrn);
s = regionprops(CC, 'centroid');
centroids = cat(1,s.Centroid);
    
centroids = round(centroids);

trajectory = {};
for i = 1:size(centroids,1)
    trajectory{i} = centroids(i,:);
end

pointTracker = vision.PointTracker;

initialize(pointTracker,centroids,obr)

for i = 2:size(names,1)
    frameRGB = imread([path,'\',names(i).name]);%'\Ants\'
    frameGray = im2gray(frameRGB);
    [points,~] = pointTracker(frameGray);


    for j = 1:size(centroids,1)
        trajectory{j}(i,:) = round(points(j,:));
    end
end
end
