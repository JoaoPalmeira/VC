%Function that applies Non Maxima Supression
function [ enh_img ] = nonmax(img_mag,img_dir)
    
    [h,w] = size(img_dir);
    enh_img = zeros(h+2,w+2);
    [h,w]=size(img_dir);
    
    for i=2:h+1
        for j=2:w+1
            enh_img(i,j)=img_mag(i-1,j-1);
        end
    end

    for i=2:h-1 % row
        for j=2:w-1 % col         
            if (img_dir(i,j)>=-22.5 && img_dir(i,j)<=22.5) || ...
                (img_dir(i,j)<-157.5 && img_dir(i,j)>=-180)
                if (img_mag(i,j) >= img_mag(i,j+1)) && ...
                   (img_mag(i,j) >= img_mag(i,j-1))
                    enh_img(i,j)= img_mag(i,j);
                else
                    enh_img(i,j)=0;
                end
            elseif (img_dir(i,j)>=22.5 && img_dir(i,j)<=67.5) || ...
                (img_dir(i,j)<-112.5 && img_dir(i,j)>=-157.5)
                if (img_mag(i,j) >= img_mag(i+1,j+1)) && ...
                   (img_mag(i,j) >= img_mag(i-1,j-1))
                    enh_img(i,j)= img_mag(i,j);
                else
                    enh_img(i,j)=0;
                end
            elseif (img_dir(i,j)>=67.5 && img_dir(i,j)<=112.5) || ...
                (img_dir(i,j)<-67.5 && img_dir(i,j)>=-112.5)
                if (img_mag(i,j) >= img_mag(i+1,j)) && ...
                   (img_mag(i,j) >= img_mag(i-1,j))
                    enh_img(i,j)= img_mag(i,j);
                else
                    enh_img(i,j)=0;
                end
            elseif (img_dir(i,j)>=112.5 && img_dir(i,j)<=157.5) || ...
                (img_dir(i,j)<-22.5 && img_dir(i,j)>=-67.5)
                if (img_mag(i,j) >= img_mag(i+1,j-1)) && ...
                   (img_mag(i,j) >= img_mag(i-1,j+1))
                    enh_img(i,j)= img_mag(i,j);
                else
                    enh_img(i,j)=0;
                end
            end
        end
    end
    
    enh_img = uint8(enh_img(2:h+1,2:w+1));

end