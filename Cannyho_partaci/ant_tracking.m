function [trajectories] = ant_tracking(path)
    imagefiles =  dir([path,'/*.jpg']);
    cd(path)
    
    bw = zeros(1024,1024);
    point = [];
    Points = [];
    
    cesta= cell(1,6);
    matrix = zeros( 6,2);
    
    for i = 1: length(cesta)
        cesta{i} = matrix;
    end
    
    for i=1:length(imagefiles)
        file1 = imagefiles(i).name;
    %     file2 = imagefiles(i+1).name;
        frame1= imread(file1);
    
        frame1 = im2gray(frame1); 
    
        level = 50;
        bw(frame1>level) = 0;
        bw(frame1<level) = 1;
       
         se = strel("diamond",3);
        mask = imopen(bw, strel('diamond', 3));
        mask = imclose(mask, strel('diamond', 2));
    
        mask = imfill(mask, 'holes');
    
        [L,number] = bwlabel(mask,8);
    
    
        for m = 1:6
             
            [y, x] = find(L == m);
           %point= regionprops(L, "Centroid");
             point = [round(mean(x)) round(mean(y))];
            Points(m,1:2) = point;
            if i == 1
                cesta{m}(i,:) = Points(m,:);
            end
    
    
            if i>1
                if m == 6
                    old= [cesta{1}(i-1,:); cesta{2}(i-1,:) ;cesta{3}(i-1,:); cesta{4}(i-1,:); cesta{5}(i-1,:); cesta{6}(i-1,:)];
                    new = Points;
                    for p = 1:6
                        %D = pdist([new(p,:);old(p,:)],"fasteuclidean")
                        D  = sqrt(sum((old(p,:) - new).^2,2));
                        [val, idx] = min(D);
                        cesta{p}(i,:) = new(idx,:);
                    end
                end
            end
    
        end
    %             figure(2)
    %             imshow(frame1)
    %             hold on 
    %             line(cesta{1,3}(1:i,1),cesta{1,3}(1:i,2),'Color','r','LineWidth',1)
    %             hold off
               
    end
    
    
trajectories = cesta;
end


