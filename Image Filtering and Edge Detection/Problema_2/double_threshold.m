%Function that creates set of weak and strong edges according to threshold
%values
function [str_wk_set,thresh_img] = double_threshold(enh_img,lower,upper  )
    %make strong and weak edges set
    str_wk_set=zeros(size(enh_img));
    thresh_img=enh_img;
    %if below threshold suppress magnitude value
    thresh_img(thresh_img<lower)=0;
    %if above lower threshold tag as one on set(inbetween threshold values)
    str_wk_set(thresh_img>=lower)=1;
    %if above upper threshold tag as two
    str_wk_set(thresh_img>=upper)=2;
    


end

