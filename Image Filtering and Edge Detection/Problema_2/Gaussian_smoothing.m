%Fuction that applies a Gaussian filter in the Spatial Domain
function [img_smooth] = Gaussian_smoothing(img_noise,kernel,stdev)

%Create the Gaussian Filter
G = fspecial('gaussian',kernel,stdev);
          
%Apply the Gaussian Filter          
img_smooth = imfilter(img_noise,G);

end

