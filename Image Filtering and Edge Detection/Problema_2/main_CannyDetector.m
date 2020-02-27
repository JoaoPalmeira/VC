%Fuction that applies the algorithms described on section two of the second
%problem
function [img_mag,enh_img,edge_img ] = main_CannyDetector(noisy,filter_size,variance)
    dlg_title = 'Tutorial';
    num_lines = 1;
    
    %Applies lowpass gaussian filter
    smooth=Gaussian_smoothing(noisy,filter_size,variance);
    
    %Applies directional gradients and obtains magnitude and phase of image
    [img_mag,img_dir]=gradient(smooth);
    
    %Applies non maxima suppression and obtains enhanced image
    enh_img=nonmax(img_mag,img_dir);
    
    prompt = {'Qual é o mínimo thereshold?'};
    answer = inputdlg(prompt,dlg_title,num_lines);
    lower=str2double(answer{1});
    
    prompt = {'Qual é o máximo thereshold? (normalmente o dobro do mínimo)'};
    answer = inputdlg(prompt,dlg_title,num_lines);
    upper=str2double(answer{1});
    %Applies double threshold and get set of weak and strong edges aswell
    %as suppression of values < lower threshold
    [str_wk_set,thresh_img]=double_threshold(enh_img,lower,upper);
    
    %Applies hysteresis thresholding getting the "true" edges 
    edge_img= hysteresis_thresholding(str_wk_set,thresh_img, lower, upper);
    
end

