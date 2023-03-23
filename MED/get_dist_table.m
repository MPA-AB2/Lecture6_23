function [dist_table] = get_dist_table(ant_paths, new_centroids)
    dist_table = zeros(length(ant_paths), length(new_centroids));
    for path = 1:length(ant_paths)
        for cent = 1:length(new_centroids)
            dist_table(path, cent) = pdist2(ant_paths{path}(end,:), ...
                new_centroids{cent});
        end
    end
end


% for prvni = 1:pocet_bodu
%     for druhy = 1:pocet_bodu
%         matice_vzdalenosti(prvni, druhy) = pdist(body(prvni, :), body(druhy, :));
%     end
% end