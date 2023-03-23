function [ant_paths] = MED(path)
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here
files = dir(fullfile(path, "*.jpg"));
NUM_ANTS = 6;

counts = zeros(1, 21);
se21 = ones(5);
se21([1 5], [1 5]) = 0;
SEs = {strel([0 1 0; 1 1 1; 0 1 0]), strel(ones(3)), strel(se21)};
% ant_paths = cell(1,6);

for i = 1:length(files)
    im = imread(fullfile(files(i).folder, files(i).name));
    im_gray = im2gray(im);
    im_bw = im_gray < 30;
    im_bw = imfill(im_bw,"holes");
    im_bw = bwareaopen(im_bw, 24);

    labeled = bwlabel(im_bw);
    ant_count = max(max(labeled));
    
    

    if ant_count > NUM_ANTS
        for j = 1:length(SEs)
            im_bw_new = imclose(im_bw, SEs{j});
            labeled = bwlabel(im_bw_new);
            ant_count = max(max(labeled));
            if ant_count == NUM_ANTS
                im_bw = im_bw_new;
                break;
            elseif ant_count < NUM_ANTS
                break;
            elseif j == length(SEs)
                im_bw = im_bw_new;
            end
        end
    end

    counts(i) = ant_count;
    centroids = regionprops(im_bw, 'Centroid');
    centroids = struct2cell(centroids);

    if i == 1
        ant_paths = centroids;
    else
        ant_paths = sort_ants_to_paths(ant_paths, centroids);
    end
        

end
end