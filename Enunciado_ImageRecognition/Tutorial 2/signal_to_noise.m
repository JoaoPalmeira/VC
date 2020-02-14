
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%> Calcula o sinal da para a taxa de ruido obtido da variação das imagens <
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

function [ s2n,srn2 ] = signal_to_noise(gray_img,imagemSuavizada,imagemRuido)
    sinal = var(double(gray_img(:)));
    smooth  = var(imagemSuavizada(:)); 
    ruido = var(imagemRuido(:));
    s2n = 10*log10( sinal^2 / smooth^2 );
    srn2 = 10*log10( sinal^2 / ruido^2 );
end

