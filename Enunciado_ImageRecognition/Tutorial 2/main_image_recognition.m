function [] = main_image_recognition(varargin)
    %>>>>>>>>>>>>>>> Verifica o numero de parametros <<<<<<<<<<<<<<<<<<<<<<
    if(nargin == 5)
		%>>>>>>>>>>>>>>>>>>>>>>> Parametros fixos <<<<<<<<<<<<<<<<<<<<<<<<<
        nomeImagem = varargin{1};
		gray_img = varargin{2};
		tipoRuido = varargin{3};
		ruido_param = varargin{4};
        rgb_img = varargin{5};
        
    elseif(nargin == 6)
        %>>>>>>>>>>>>>>>>>>>>>>> Parametros fixos <<<<<<<<<<<<<<<<<<<<<<<<<
        nomeImagem = varargin{1};
		gray_img = varargin{2};
		tipoRuido = varargin{3};
		ruido_param = varargin{4};
        mask_img = double(varargin{5});
        rgb_img = varargin{6};
    else
        warning('Numero errado de argumentos')
        return
    end
    
	%>>>>>>>>> Adiciona ruido á imagem de acordo com os parametros <<<<<<<<
    imagemRuido = add_noise_function(gray_img,tipoRuido,ruido_param);
    
    %>>>>>>>>>>>>>>> Tipo de pre-processamento a aplicar <<<<<<<<<<<<<<<<<<
    figure,imshow(imagemRuido),title('Imagem com Ruido');

    %>>>>>>>>>>>>>>>>>>>> Normalização da imagem <<<<<<<<<<<<<<<<<<<<<<<<<<
    imagemRuido = im2double(imagemRuido);

    %>>>>>>>>>>>>>> Filtra as imagens de acordo com o ruido <<<<<<<<<<<<<<<
    if(strcmp(tipoRuido,'gaussian'))
    	smooth_img = filter_spatial(imagemRuido,'gaussian');
    elseif(strcmp(tipoRuido,'saltandpepper'))
    	smooth_img = filter_spatial(imagemRuido,'median');
        smooth_img = filter_spatial(smooth_img,'median');
    end
    
    %>>>>>>>>>>>>>>>>>> Histograma da imagem <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
     figure,imhist(smooth_img),title('Histograma da Imagem');
    
    %>>>>>>>>>>>>>>> Histograma de alto contraste da imagem <<<<<<<<<<<<<<<
      equalized_img=histeq(smooth_img);
      figure,imshow(equalized_img),title('Imagem Equalizada');
    
    %>>>>>>>>>>>>>>>>> Ajustar mais uma vez o contraste <<<<<<<<<<<<<<<<<<<
      imadjust(equalized_img);
      figure,imshow(equalized_img),title('Pre-Processamento final da imagem');
      
    %>>>>>>>>>>>>>>>>> Histograma da imagem equalizada <<<<<<<<<<<<<<<<<<<<
     figure,imhist(equalized_img),title('Histograma da imagem equalizada');
    
    %>>>>>>>>>>>>>>>>> Aplica edge detection dependendo de <<<<<<<<<<<<<<<<
    %>>>>>>>>>>>>>>>>>> qual imagem está sendo processada <<<<<<<<<<<<<<<<<
    
     if(strcmp(nomeImagem,'coins2'))
         equalized_img=histeq(mask_img);
         edge_img = edge(equalized_img,'sobel','both');
         figure,imshow(edge_img),title('Edge Detection');
     elseif(strcmp(nomeImagem,'coins'))
         edge_img = edge(equalized_img,'canny',[0.25 0.50]);
         figure,imshow(edge_img),title('Edge Detection');
     elseif(strcmp(nomeImagem,'coins3'))
         edge_img = edge(smooth_img,'canny',[0.25 0.50]);
         figure,imshow(edge_img),title('Edge Detection');
     end
     
   
   %>>>>>>>>>>>>>>>>>>> Aplica a segmentação à imagem <<<<<<<<<<<<<<<<<<<<<
    if(strcmp(nomeImagem,'coins'))
        [centers,radius] = HoughTransform(edge_img,50,100,0.95,0.1);
        num_moedas = coin_counter(radius);
        figure,imshow(equalized_img);
        h = viscircles(centers,radius,'EdgeColor','b');
        title(['Número de moedas = ',num2str(num_moedas)]);
        
        figure,imshow(gray_img);
        [cent,radi] = HoughTransform(edge(gray_img,'canny',[0.25 0.50]),50,100,0.95,0.1);
        h = viscircles(cent,radi,'EdgeColor','b');
        title('Imagem original segmentada');
        
        s = metrics(radius);
    elseif(strcmp(nomeImagem,'coins2'))
        [centers,radius] = HoughTransform(edge_img,30,80,0.87,0.07);
        num_moedas = coin_counter(radius);
        figure,imshow(smooth_img);
        title(['Número de moedas = ',num2str(num_moedas)]);
        h = viscircles(centers,radius,'EdgeColor','b');
        
        figure,imshow(gray_img);
        [cent,radi] = HoughTransform(edge(gray_img,'sobel','both'),30,80,0.87,0.07);
        h = viscircles(cent,radi,'EdgeColor','b');
        title('Imagem original segmentada');
        
        s = metrics(radius);
    elseif(strcmp(nomeImagem,'coins3'))
        [centers,radius] = HoughTransform(edge_img,40,65,0.89,0.11);
        num_moedas = coin_counter(radius);
        title(['Número de moedas = ',num2str(num_moedas)]);
        figure,imshow(equalized_img);
        h = viscircles(centers,radius,'EdgeColor','b');
        
        figure,imshow(gray_img);
        [cent,radi] = HoughTransform(edge(gray_img,'canny',[0.25 0.50]),40,65,0.89,0.11);
        h = viscircles(cent,radi,'EdgeColor','b');
        title('Imagem original segmentada');
        
        s = metrics(radius);
    end
    
    %>>>>>>>>>>>>>>>>>>>> Classificação da imagem <<<<<<<<<<<<<<<<<<<<<<<<<
    model=supervised_classifier();
    
    total = 0;
    Moedas = [];
    Tipo_de_moeda = [];
    
    %>>>>>>>>>>>>> Classificação das moedas na imagem <<<<<<<<<<<<<<<<<<<<<
    for i=1:s
    	V=centers(i,:);
        x = V(1);
        y = V(2);
    	r=radius(i)+15;
    	ux=x-r;
    	uy=y-r;
    	lx=x+r;
    	ly=y+r;
    	image=imcrop(rgb_img,[ux uy lx-ux ly-uy]);
        figure,imshow(image),title('imagem recortada');
    	[labelIdx, scores] = predict(model, image);

        var = model.Labels(labelIdx);
                
        Tipo_de_moeda = vertcat(Tipo_de_moeda,string(var));
        
        str = sprintf("Moeda %d",i);
        Moedas = vertcat(Moedas,str);
        
        switch(char(var))
            case '1cent'
                total = total + 0.01;
            case '2cent'
                total = total + 0.02;
            case '5cent'
                total = total + 0.05;
            case '10cent'
                total = total + 0.10;
            case '20cent'
                total = total + 0.20;
            case '50cent'
                total = total + 0.50;
            case '1euro'
                total = total + 1;
            case '2euro'
                total = total + 2;
        end
    end
    
   %>>>>>>>> Apresentação dos tipos de moedas presentes na imagem <<<<<<<<<
    T = table(Tipo_de_moeda,'RowNames',cellstr(Moedas));
    disp(T);
    
   %>>>>>>>>>>>>>>>>>>>>>>>>>>> Total de dinheiro <<<<<<<<<<<<<<<<<<<<<<<<<
    fprintf('O total de dinheiro é:%6.2f euros \n', total');
    
   %>>>>>>>>>>>>>>>>>>>>>>>>>>>>> SNR da imagem <<<<<<<<<<<<<<<<<<<<<<<<<<<
    fprintf('O SNR da imagem com ruído apresentado foi %6.2f \n',signal_to_noise(gray_img,smooth_img,imagemRuido)');
   
 
end

%-----------------------Add noise-----------------------------------
%Function responsible for adding noise to an image

function [ noise ] = add_noise_function(gray_img,noise_type,noise_param)
    if(strcmp(noise_type,'gaussian'))
        noise = imnoise(gray_img,'gaussian',0,noise_param);
    else
        noise = imnoise(gray_img,'salt & pepper',noise_param);
    end
end


%>>>>>>>>>>>>>>>>>>>>>>>>>> Dominio Espacial <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%>>>>>>>> Função responsável pela suavização no domínio espacial <<<<<<<<<<

function [smooth_img] = filter_spatial(varargin)
   
    noise_image=varargin{1};
    filter=varargin{2};

    if(strcmp(filter,'gaussian'))
        f = fspecial('gaussian',5,2);
        smooth_img=imfilter(noise_image,f);
    else
        smooth_img=medfilt2(noise_image,[3 3]);
    
    end
end
