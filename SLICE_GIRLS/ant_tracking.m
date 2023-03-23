function trajectories = ant_tracking(path)

% Find files in dir
files = dir([path, '*.jpg']);
numFiles = length(files);
images = cell(numFiles,1);

% Prealocate trajectories
trajectories = cell(1,6);
paths = zeros(numFiles,2,6);


% figure(1);
for i = 1:numFiles
    images{i} = imread([path, files(i).name]);
    
    % Binary mask
    im = im2double(rgb2gray(images{i}));
    im = medfilt2(im, [7,7], 'symmetric');
    
    mask = imbinarize(im, 0.2);
    mask = ~mask;
    
    % Apply morphological operations to remove noise and fill in holes.
    mask = imopen(mask, strel('rectangle', [3,3]));
    mask = imclose(mask, strel('rectangle', [3,3]));
    mask = imfill(mask, 'holes');
    
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
        maskJoint = imerode(maskJoint, strel('rectangle', [3, 3]));
        compJoint = bwconncomp(maskJoint);
        
        while compJoint.NumObjects == 1
            maskJoint = imerode(maskJoint, strel('rectangle', [3, 3]));
            compJoint = bwconncomp(maskJoint);
        end
        
        % Join the mask
        mask = mask + maskJoint;
        comp = bwconncomp(mask);
    end

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

end




