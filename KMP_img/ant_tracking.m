function [trajectory] = ant_tracking(path)

names = dir([path,'Ants\*.jpg']);
%%
obr = imread([path,'Ants\00000001.jpg']);
obr = rgb2gray(obr);

obrn = obr;
    
obrn(obr > 25.5) = 0;
obrn(obr < 25.5) = 1;

    
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

for i = 2:215
    frameRGB = imread([path,'\Ants\',names(i).name]);%'\Ants\'
    frameGray = im2gray(frameRGB);
    [points,~] = pointTracker(frameGray);


    for j = 1:size(centroids,1)
        trajectory{j}(i,:) = round(points(j,:));
    end
end
end
