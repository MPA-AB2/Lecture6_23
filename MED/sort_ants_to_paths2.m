function [new_paths] = sort_ants_to_paths2(ant_paths, new_centroids, max_dist)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
path_extensions = cell(1, 6);
path_ants = zeros(1,6);
cents_available = 1:length(new_centroids); % numbers of available centroids
paths_available = 1:length(ant_paths);

for i = 1:min([length(new_centroids), length(ant_paths)])
    % generate distance matrix
    table = get_dist_table(ant_paths(paths_available), ...
        new_centroids(cents_available));

    % find position of min, that means smallest eucleidean distance between
    % ant and end of path from previous iteration
    [min_val,idx] = min(table(:));
    if min_val > max_dist
        break
    end
    [path_idx,cent_idx] = ind2sub(size(table),idx);

    % assign centroid to the path (centroid and path with smallest
    % eucleidean distance are joined)
    path_ants(paths_available(path_idx)) = cents_available(cent_idx);
    path_extensions{paths_available(path_idx)} = new_centroids{cents_available(cent_idx)};

    % remove centroid an path assigned together from next iteration
    cents_available(cent_idx) = [];
    paths_available(path_idx) = [];
    
end

for i = 1:length(path_extensions)
    if isempty(path_extensions{i})
        path_extensions{i} = ant_paths{i}(end,:);
    end
end
new_paths = ant_paths;
for i = 1:length(path_extensions)
    new_paths{i} = [new_paths{i}; path_extensions{i}];
end


