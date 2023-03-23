function [center, area] = GetCenter(bbox)
% 

% hold on
for i = 1:size(bbox, 1)

%     rectangle('Position',bbox(i,:), 'EdgeColor','r', 'LineWidth',2)
    x = bbox(i,1);
    y = bbox(i,2);
    w = bbox(i,3);
    h = bbox(i,4);
    center(i,1) = x+ceil(w/2);
    center(i,2) = y+ceil(h/2);
    area(i,1) = w*h;
%     plot(center(1), center(2), '.g', 'LineWidth', 25)
end

end