function [trajectories] = ant_tracking(path)
%% find names of files
filesInfo = dir(fullfile(path,"\*.jpg"));
files = {filesInfo.name};

trajectories = cell(1,6);
%% loading first image and detecting ants   
currIm = rgb2gray(im2double(imread(fullfile(path,files{1}))));

thr = multithresh(currIm,6);
threshIm = imfill(currIm<thr(1),'holes');
threshIm = bwareaopen(threshIm,50);
info = regionprops(threshIm);
[~,sortedObjects] = sort(cell2mat({info(:).Area}),'descend');
%% for each ant motion tracking
for idx = 1:6
    
    % create point tracker and coord matrix
    pointTracker = vision.PointTracker('BlockSize',[39,39]);%('NumPyramidLevels',2,'BlockSize',[27,27])
    trajectories{idx} = zeros(length(files),2);

   % detect feature points
    points = detectHarrisFeatures(threshIm,"ROI",info(sortedObjects(idx)).BoundingBox);
%     points = detectFASTFeatures(threshIm,"ROI",info(sortedObjects(idx)).BoundingBox);
%     points = detectMinEigenFeatures(threshIm,"ROI",info(sortedObjects(idx)).BoundingBox);
    points = points.Location;

    % initialize point tracker
    initialize(pointTracker,points,currIm);
    
    % save starting coords
    trajectories{idx}(1,:) = mean(points);
    
    % for each image find position of ant using keypoints
    for i = 2:length(files)
        currIm = rgb2gray(im2double(imread(fullfile(path,files{i}))));

        [points,validity] = pointTracker(currIm);
    
        trajectories{idx}(i,:) = median(points(validity,:));   
    end
end
end