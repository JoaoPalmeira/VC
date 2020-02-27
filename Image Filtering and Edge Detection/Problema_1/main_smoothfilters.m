function [ imagem_ruido,imagem_smoothed ] = main_smoothfilters(varargin)
    if(nargin>=7 && nargin<=8)
    
        %Fixed parameters
        img_name=varargin{1};
        gray=varargin{2};
        ruido=varargin{3};
        ruido_param=varargin{4};
        dominio=varargin{5};
        filter=varargin{6};
        filter_size=varargin{7};
        
        %Applies histogram equalization for high contrast image
        gray=histeq(gray);
        imwrite(gray,[img_name '_equalized.png']);
        
        %Add noise to image according to parameters
        imagem_ruido=add_noise_function(gray,ruido,ruido_param);
        
        %Apply lowpass filter in spatial or frequency dominio
        if(strcmp(dominio,'spatial'))
            if(strcmp(filter,'gaussian'))
                filter_param=varargin{8};
                tic
                imagem_smoothed=filtroSpt(imagem_ruido,filter,filter_size,filter_param);
                toc
            else
                tic
                imagem_smoothed=filtroSpt(imagem_ruido,filter,filter_size);
                toc
            end
        else
             if(strcmp(filter,'gaussian'))
                tic
                imagem_smoothed=filtroFreq(imagem_ruido,filter,filter_size);
                toc
             else
                filter_param=varargin{8};
                tic
                imagem_smoothed=filtroFreq(imagem_ruido,filter,filter_size,filter_param);
                toc
             end
        end
        
        %Compare with spatial and plot of frequency domain of images
        figure
        compare_images(gray,uint8(imagem_ruido),imagem_smoothed);
    
        %Create file paths
        ficheiro1=[img_name '_' ruido '_' num2str(ruido_param) '.png'];
        if(nargin==8)
            ficheiro2=[img_name '_smooth_' filter '_' num2str(filter_size) '_' num2str(filter_param) '.png'];
        else
            ficheiro2=[img_name '_smooth_' filter '_' num2str(filter_size) '.png'];
        end
        
        %Save image in file
        imwrite(imagem_ruido,ficheiro1)
        imwrite(imagem_smoothed,ficheiro2)
        
        %Calculate SNR by obtaining variance of images
        gray=double(gray);
        imagem_smoothed=double(imagem_smoothed);
        imagem_ruido=double(imagem_ruido);
        
        signal = var(gray(:));
        smooth  = var(imagem_smoothed(:)); 
        noise = var(imagem_ruido(:));
        s2n = 10*log10( signal^2 / smooth^2 )
        srn2=10*log10( signal^2 / noise^2 )
    
    else
        warning('Numero errado de argumentos')
        return
    end
    
end

%-----------------------Add noise-----------------------------------
%Function responsible for adding noise to an image
function [noisy] = add_noise_function(gray,ruido,ruido_param)
    if(strcmp(ruido,'gaussian'))
        noisy= imnoise(gray,'gaussian',0,ruido_param);
    else
        noisy= imnoise(gray,'salt & pepper',ruido_param);
    end
end
%-------------------------------------------------------------------

%-----------------------Spatial domain-----------------------------
%Function responsible for smoothing an image in the spatial domain
function [smooth_img] = filtroSpt(varargin)
    imagem_ruido=varargin{1};
    filter=varargin{2};
    filter_size=varargin{3};
    if(strcmp(filter,'gaussian'))
        filter_param=varargin{4};
        g = fspecial('gaussian',filter_size,filter_param);
        smooth_img=imfilter(imagem_ruido,g);
    elseif (strcmp(filter,'average'))
        a=fspecial('average',filter_size);
        smooth_img=imfilter(imagem_ruido,a);
    else
        smooth_img=medfilt2(imagem_ruido,[filter_size filter_size]);
    end
end
%--------------------------------------------------------------------

%-------------------------------Spectral image----------------------------
%Function responsible for computing dft of an image
function [L,R] = compute_dft(img)
    I=fft2(img);    %Fourier transform
    F=fftshift(I);  %Center
    R=abs(F);       %Obtain real values
    L=mat2gray(log(R+1));   
end

%Function responsible for comparing original, noisy and smoothed images as spectral and plot 
function [] = compare_images(gray,noisy,smoothed)
   [L,R]=compute_dft(gray);
   subplot(3,2,1),imshow(L),title('Original spectral')
   subplot(3,2,2),plot(R),title('Original plot')
   [L,R]=compute_dft(noisy);
   subplot(3,2,3),imshow(L),title('Noisy spectral')
   subplot(3,2,4),plot(R),title('Noisy plot')
   [L,R]=compute_dft(smoothed);
   subplot(3,2,5),imshow(L),title('Smoothed spectral')
   subplot(3,2,6),plot(R),title('Smoothed plot')
end
%------------------------------------------------------------------------

%-------------------Frequency domain----------------------------------
%Function responsible for the filtering on frequency domain
function [smoothed] = filtroFreq(varargin)
    
    noisy=varargin{1};
    filter=varargin{2};
    filter_cutoff=varargin{3};
    
    dimg=double(noisy);
    [r,c] = size(dimg);
    %Get padding dimensions
    P=2*r;
    Q=2*c;

    pimg=zeros(P,Q);
    cimg=zeros(P,Q);
    
    %Pad image and center the image
    for i=1:r
        for j=1:c
            pimg(i,j)=dimg(i,j);
            cimg(i,j)=pimg(i,j)*((-1)^(i+j));
        end
    end
    
    %Apply 2d fft
    I=fft2(cimg);    
    
    if(strcmp(filter,'gaussian'))
        G=gaussianF(I,filter_cutoff);
    else
        filter_order=varargin{4};
        G=butterworthF(I,filter_cutoff,filter_order);
    end
    %Apply inverse DFT
    smoothed=iDFT(G,r,c);
    
end

%Applies inverse DFT. Arguments: Result of multiplication of filter and transformed image and sizes of original image
function[smoothed]=iDFT(G,r,c)
    %inverse 2D fft
    F=ifft2(G);
    
    %Center image
    for i=1:r*2
        for j=1:c*2
            F(i,j)=F(i,j)*((-1)^(i+j));
        end
    end
    
    %Get real part
    F=abs(F);
    
    %Remove the padding
    smoothed=zeros(r,c);
    for i=1:r
        for j=1:c
            smoothed(i,j)=F(i,j);
        end
    end
    
    smoothed=uint8(smoothed);
end

%Applies butterworth low pass filter to frequency domain image
function [G]= butterworthF(F,cutoff,order)
    [r,c]=size(F);
    d0=cutoff;

    dist=zeros(r,c);
    h=zeros(r,c);
    %Create weight distribution according to filter positions and apply butterworth function
    for i=1:r
    	for j=1:c
        	dist(i,j)=  sqrt((i-(r/2))^2 + (j-(c/2))^2);
            h(i,j)=  (1+ (dist(i,j)/d0)^(2*order))^(-1);
    	end
    end
    
    %Save spectral image of filter to check ringing
    [L,R]=compute_dft(h);
    ficheiro1=['Ringing_Butterworth_' num2str(cutoff) '_' num2str(order) '.png'];
    imwrite(L,ficheiro1);
    %Get smoothed image matrix by multiplying filter by noise image matrix
    G=h.*F;
end

%Applies gaussian low pass filter to frequency domain image
function [G]= gaussianF(F,cutoff)
    [a,b]=size(F);
    d0=cutoff;
    dist=zeros(a,b);
    h=zeros(a,b);
    
    %Create weight distribution according to filter positions and apply Gaussian function
    for i=1:a
        for j=1:b
            dist(i,j)=  sqrt((i-(a/2))^2 + (j-(b/2))^2);
            h(i,j)= exp (-((dist(i,j)^2)/(2*(d0^2))));
        end
    end
    
    %Save spectral image of filter to check ringing
    [L,R]=compute_dft(h);
    ficheiro1=['Ringing_Gaussian_' num2str(cutoff) '.png'];
    imwrite(L,ficheiro1);
    %Get smoothed image matrix by multiplying filter by noise image matrix
    G=h.*F;
end
%----------------------------------------------------------------------------------------------