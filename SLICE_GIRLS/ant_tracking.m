function trajectories = ant_tracking(path)

% Find files in dir
files = dir([path, '*.jpg']);
numFiles = length(files);
images = cell(numFiles,1);

% Prealocate trajectories
trajectories = cell(1,6);
paths = zeros(numFiles,2,6);

for i = 1:numFiles
    images{i} = imread([path, files(i).name]);
    
    % Binary mask
    im = im2double(rgb2gray(images{i}));
%     im = medfilt2(im, [5,5], 'symmetric');
%     im = imgaussfilt(im);
    
    mask = imbinarize(im, 0.12);
    mask = ~mask;
    
    % Apply morphological operations to remove noise and fill in holes.
%     mask = imopen(mask, strel('disk', 4));
%     mask = imclose(mask, strel('disk', 4));
    mask = imfill(mask, 'holes');
    mask = bwareaopen(mask, 24);
    
    comp = bwconncomp(mask);
    
    % If we have less than 6 objects
    while comp.NumObjects < 6
        
        % Find biggest object
        highestLen = 0;
        lenIdx = 0;
        for j = 1:comp.NumObjects
            if length(comp.PixelIdxList{j}) > highestLen
                lenIdx = j;
                highestLen = length(comp.PixelIdxList{j});
            end
        end
        
        % Create mask from it
        maskJoint = zeros(size(im));
        maskJoint(comp.PixelIdxList{lenIdx}) = 1;
        
        % Set obj in original mask to zero
        mask(comp.PixelIdxList{lenIdx}) = 0;
        
        % Split the object
        maskJoint = imerode(maskJoint, strel('disk', 3));
        compJoint = bwconncomp(maskJoint);
        
        while (comp.NumObjects + compJoint.NumObjects) < 6
            maskJoint = imerode(maskJoint, strel('disk', 3));
            compJoint = bwconncomp(maskJoint);
            
            if compJoint.NumObjects == 0
                compJoint.NumObjects = Inf;
            end
        end
        
        % Join the mask
        mask = mask + maskJoint;
        comp = bwconncomp(mask);
    end

    % If we have more than 6 objects    
    comp.CenterIdx = struct2cell(regionprops(comp,'Centroid'));
    
    if comp.NumObjects > 6
        distMat = pdist(cell2mat(comp.CenterIdx'), 'euclidean');
        upgma = linkage(distMat,'average');
        joinedComps = cluster(upgma,'MaxClust',6,'Criterion','distance');

        for k = 1:max(joinedComps)
            group = joinedComps == k;
            if sum(group) > 1
                comp.PixelIdxListJoined{k} = vertcat(comp.PixelIdxList{group});
            else
                comp.PixelIdxListJoined{k} = comp.PixelIdxList{group};
            end
        end
        
        comp.PixelIdxList = comp.PixelIdxListJoined;
        comp.NumObjects = 6;
    end
    
    % Calculate centroids
    centroids = regionprops(comp,'Centroid');

    % Assign first position
    if i == 1
        for j = 1:6
            paths(i,:,j) = centroids(j).Centroid;
        end
    else
        % Find nearest location
        indPrev = 1:6;
        indNext = 1:length(centroids);
        for j = 1:5
            X = reshape([centroids(indNext).Centroid],2,length(indNext))';
            Y = squeeze(paths(i-1,:,indPrev))';
            
            Xx = X(:,1);
            Xy = X(:,2);
            Yx = Y(:,1);
            Yy = Y(:,2);
            
            xDif = repmat(Xx,1,length(indPrev)) - repmat(Yx',length(indNext),1);
            yDif = repmat(Xy,1,length(indPrev)) - repmat(Yy',length(indNext),1);
            
            D = sqrt(xDif.^2 + yDif.^2);
%             D = pdist2(X,Y);
            
            minimum = min(min(D));
            [cent,pth] = find(D == minimum, 1);
            
            paths(i,:,indPrev(pth)) = centroids(indNext(cent)).Centroid;
            
            indPrev = [indPrev(1:pth-1) indPrev(pth+1:end)];
            indNext = [indNext(1:cent-1) indNext(cent+1:end)];
        end
        
        % Assign remaining ant
        paths(i,:,indPrev) = centroids(indNext).Centroid;
        
    end

end

% Save trajectories
for j = 1:6
    trajectories(1,j) = {paths(:,:,j)};
end




