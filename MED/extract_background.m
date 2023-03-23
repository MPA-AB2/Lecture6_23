files = dir("Ants/*.jpg");
STRIDE = 5;
im = imread(fullfile(files(1).folder, files(1).name));
s = size(im);
s(3) = ceil(length(files)/STRIDE);
image_stack = zeros(s);

for i = 1:STRIDE:length(files)
    im = imread(fullfile(files(i).folder, files(i).name));
    im_gray = im2gray(im);
    image_stack(:,:, 1 + (i-1)/STRIDE) = im_gray;
end

% background = median(image_stack, 3);
background = max(image_stack, [], 3);
background = uint8(background);
figure
imshow(background)

