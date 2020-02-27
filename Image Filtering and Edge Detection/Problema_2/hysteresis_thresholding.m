%Fuction that applies hysteresis_thresholding
function [edge_img] = hysteresis_thresholding(BW,img_thresh, lower, upper)
[M,N] = size(img_thresh);

%padding
img_padded  = padarray(BW,[1 1],0,'both');

edge_img=img_thresh;

T_Low = lower * max(max(BW));
T_High = upper * max(max(BW));
T_res = zeros (M, N);
for i = 1  : M
    for j = 1 : N
        if (img_padded(i, j) < T_Low)
            T_res(i, j) = 0;
        elseif (img_padded(i, j) > T_High)
            edge_img(i, j) = 1;
        %Using 8-connected components
        elseif ( img_padded(i+1,j)>T_High || img_padded(i-1,j)>T_High || img_padded(i,j+1)>T_High || img_padded(i,j-1)>T_High || img_padded(i-1, j-1)>T_High || img_padded(i-1, j+1)>T_High || img_padded(i+1, j+1)>T_High || img_padded(i+1, j-1)>T_High)
            edge_img(i,j) = 1;
        end
    end
end

end
