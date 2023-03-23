function [trajectories] = ant_tracking(folder)

files = dir([folder,'/*.jpg']);
file_names = {files.name}';

Im = (cell(size(file_names)));

for i = 1:length(file_names)
    Im{i,1} = im2double(rgb2gray(imread([folder,'\',file_names{i,1}])));
end

trajectories = cell(1,6);

ImBW = imbinarize(Im{1},'adaptive','ForegroundPolarity','dark','Sensitivity',0.2);
ImBW = ~ImBW;
ImBW = bwareafilt(ImBW,6);

coordinates = regionprops(ImBW, 'Centroid');
centroids = cat(1,coordinates.Centroid);

for k = 1:length(centroids)
    trajectories{k}(1,:) = centroids(k,:);
end

for i = 2:length(file_names)

    Im = im2double(rgb2gray(imread([folder,'\',file_names{i,1}])));
    ImBW = imbinarize(Im,'adaptive','ForegroundPolarity','dark','Sensitivity',0.2);
    ImBW = ~ImBW;
    ImBW = bwareafilt(ImBW,6);
    
    centroidOld = centroids;
    coordinates = regionprops(ImBW, 'Centroid');
    centroids = cat(1,coordinates.Centroid);

    % Check for num of centroids, if less then 6
    % Then recalculate 
    if size(centroids,1)<6
        BW = ~BW;
        Distance = -bwdist(BW);
        Distance = imhmin(Distance,6);
        Distance(BW) = -Inf;

        Ld = watershed(Distance);
        BW2 = BW;
        BW2(Ld == 0) = 0;

        se1 = strel('sphere',5);
        BW2 = imerode(BW2, se1);

        se2 = strel('rectangle',10 , 60);
        BW2 = imerode(BW2, se2);

        BW3 = bwareafilt(BW2,6);
        
        coordinates = regionprops(BW3, 'Centroid');
        centroids = cat(1,coordinates.Centroid);
    end

    % Euclid distance
    EucDist = zeros(6,6);
    for j = 1:6
        for k = 1:6
            EucDist(j,k) = sqrt((centroidOld(j,1)-centroids(k,1))^2 + (centroidOld(j,2)-centroids(k,2))^2);
        end
    end

    [~,index] = min(EucDist);
    for k = 1:length(index)
        trajectories{k}(i,:) = centroids(index(k),:);
    end
end
end