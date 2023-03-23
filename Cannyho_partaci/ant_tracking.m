function [trajectories] = ant_tracking(path)
    imagefiles =  dir([path,'/*.jpg']);
    cd(path)
    
    bw = zeros(1024,1024);
    Points = [];
    cesta= cell(1,6);

    file1 = imagefiles(1).name;
    frame1= imread(file1);
    frame1 = im2gray(frame1);     
    level = 35;
    bw(frame1>level) = 0;
    bw(frame1<level) = 1;
    bw = imopen(bw, strel('diamond', 3));
    bw = imclose(bw, strel('sphere', 2));
    bw = imfill(bw, 'holes');

    [L,~] = bwlabel(bw,8);
    for m = 1:6
        [y, x] = find(L == m);
        point = [round(median(x)) round(median(y))];
        Points(m,1:2) = point;
        cesta{m} = point;
    end
    
    pointTracker = vision.PointTracker;
    initialize(pointTracker,Points,frame1)

    for i = 2:length(imagefiles)
        frame = im2gray(imread(imagefiles(i).name));
        [points,~] = pointTracker(frame);
        for j = 1:6
            cesta{j}(i,:) = round(points(j,:));
        end
    end
trajectories = cesta;
end