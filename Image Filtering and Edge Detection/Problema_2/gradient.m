%Function that applies sobel kernels on x and y direction and computes magnitude and phase 
function [mag,dir] = gradient(img_smooth)

%Sobel kernels
sobel_x = [1 0 -1; 2 0 -2; 1 0 -1];
sobel_y = [1 2 1 ; 0 0 0; -1 -2 -1];

img_smooth = double(img_smooth);

%Apply directional sobel filters
img_filth = imfilter(img_smooth,sobel_x);
img_filtv = imfilter(img_smooth,sobel_y);


%Obtain gradient direction in degrees
dir = atan2d(img_filtv,img_filth);

%Obtain gradient magnitude
mag = uint8(sqrt((img_filth).^2 + (img_filtv).^2));

%Show all gradient images
    figure
    subplot(2,2,1), imshow(uint8(img_filth)), title('Directional gradient: X axis ')
    subplot(2,2,2), imshow(uint8(img_filtv)), title('Directional gradient: Y axis ')
    subplot(2,2,3), imshow(mag), title('Gradient magnitude')

end

