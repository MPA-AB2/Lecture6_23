function [tracks] = ant_tracking(pth_ants)

%% Initialization

imgs = imageDatastore(pth_ants);
imgs = readall(imgs);

% video = VideoWriter('ants.avi');
% open(video);
% for i=1:length(imgs)
%   writeVideo(video,imgs{i,1});
% end
% close(video); %close the file

%% Object detection initialization

videoSource = VideoReader('ants.avi');

% detector = vision.ForegroundDetector(...
%     'NumTrainingFrames', 6, ...
%     'InitialVariance', 40*40);

Hblob = vision.BlobAnalysis(...
    'CentroidOutputPort', false, 'AreaOutputPort', false, ...
    'BoundingBoxOutputPort', true, ...
    'MinimumBlobAreaSource', 'Property', 'MinimumBlobArea', 250);

shapeInserter = vision.ShapeInserter('BorderColor','White');

%% tracking initialization

tracks = cell(1, 6);
for i = 1:6
    tracks{i} = zeros(videoSource.NumFrames, 2);
end

centers_all= {};
area_all= {};
%% looking for bounding box 

videoPlayer = vision.VideoPlayer();
counter = 0;
while hasFrame(videoSource)
    frame  = readFrame(videoSource);
    %      fgMask = detector(frame);
    frame = rgb2gray(frame);
    counter = counter + 1

    
    fgMask = frame<65;
    se = strel('disk', 4);
    fgMask = imerode(fgMask,se);
    se = strel('disk',14);
    fgMask = imclose(fgMask,se);
    
%     figure(1); imshow(fgMask)
    bbox = Hblob(fgMask);
    [center, area] = GetCenter(bbox);

    centers_all{counter} = center;
    area_all{counter} = area;
    
    out = shapeInserter(frame,bbox);
%     videoPlayer(out);
%     pause(0.1);
end

release(videoPlayer);

%% centers all

not_six = zeros(1, size(centers_all,2));
for k  = 1:size(centers_all,2)
    if size(centers_all{k},1) ~= 6
        not_six(k) = 1;

        area_live = area_all{k};
        [~,max_area]=max(area_live);
        if size(centers_all{k},1) == 5
            new_mat = [centers_all{k}(1:max_area,:); centers_all{k}(max_area:end,:)];
            centers_all{k} = new_mat;
        end
        if size(centers_all{k},1) == 4
            new_mat = [centers_all{k}(1:max_area,:); centers_all{k}(max_area,:);centers_all{k}(max_area:end,:)];
            centers_all{k} = new_mat;
        end
        if size(centers_all{k},1) == 3
            new_mat = [centers_all{k}(1:max_area,:); centers_all{k}(max_area,:); centers_all{k}(max_area,:);centers_all{k}(max_area:end,:)];
            centers_all{k} = new_mat;
        end
        if size(centers_all{k},1) == 2
            new_mat = [centers_all{k}(1:max_area,:); centers_all{k}(max_area,:); centers_all{k}(max_area,:); centers_all{k}(max_area,:);centers_all{k}(max_area:end,:)];
            centers_all{k} = new_mat;
        end
        if size(centers_all{k},1) == 1
            new_mat = [centers_all{k}(1:max_area,:); centers_all{k}(max_area,:); centers_all{k}(max_area,:); centers_all{k}(max_area,:); centers_all{k}(max_area,:);centers_all{k}(max_area:end,:)];
            centers_all{k} = new_mat;
        end
        if size(centers_all{k},1) == 0
            new_mat = [0 0; 0 0;0 0;0 0;0 0;0 0];
            centers_all{k} = new_mat;
        end
    end
end
%% save tracks

% inicialization first coordinate
for j = 1:6 
    tracks{1,j}(1,:) = centers_all{1,1}(j,:);
end

% other coordinates
for i = 1 : size(centers_all, 2)
    c = centers_all{1,i}(:, :);
    t = [];
    for j = 1 : 6
        t = [tracks{1,j}(i,:);...
            tracks{1,j}(i,:);...
            tracks{1,j}(i,:);...
            tracks{1,j}(i,:);...
            tracks{1,j}(i,:); ...
            tracks{1,j}(i,:)];
        %             tracks{1,j}(i,:) = centers_all{1,i}(j,:);
        pom = (double(c)-t).^2;
        dists=sum(pom,2);
        [~, idx_min]=min(dists);
        % save
        tracks{1,j}(i,:) = centers_all{1,i}(idx_min, :);
        c(idx_min, :) = [Inf, Inf];
    end
end
%%
% imshow(imgs{1,1}); hold on
% mravenci = tracks;
% figure
% imshow(frame); hold on
% plot(mravenci{1,1}(:,1),mravenci{1,1}(:,2), '-r', 'LineWidth', 1); hold on
% plot(mravenci{1,2}(:,1),mravenci{1,2}(:,2), '-g', 'LineWidth', 1); hold on
% plot(mravenci{1,3}(:,1),mravenci{1,3}(:,2), '-b', 'LineWidth', 1); hold on
% plot(mravenci{1,4}(:,1),mravenci{1,4}(:,2), '-w', 'LineWidth', 1); hold on
% plot(mravenci{1,5}(:,1),mravenci{1,5}(:,2), '-y', 'LineWidth', 1); hold on
% plot(mravenci{1,6}(:,1),mravenci{1,6}(:,2), '-m', 'LineWidth', 1); hold on
%%
% EvaluationAnts(tracks)
end