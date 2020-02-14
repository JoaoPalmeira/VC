%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%>>> Este script lê argumentos do script main_image_recognition e depois <<
%>>>>>>>>>>>>>>>>>>>>>>>>>>> executa a função <<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

%>>>>>>>>>>>>>>>>>>>> Lê as imagens que serão usadas <<<<<<<<<<<<<<<<<<<<<<
titulo = 'Tutorial 2';
linhas_necessarias = 1;

pergunta = {'Que imagem pretende carregar?'};
resposta_imagem = questdlg(pergunta,titulo,'coins','coins2','coins3','coins');

switch(resposta_imagem)
    case 'coins'
        imagem = imread('Imagens/coins.jpg');
    case 'coins2'
        imagem = imread('Imagens/coins2.jpg');
        imagem = imresize(imagem,0.17);
    case 'coins3'
        imagem = imread('Imagens/coins3.jpg');
        imagem = imresize(imagem,0.20);
    otherwise
        warning('Ficheiro inexistente')
        return
end

gray_img = rgb2gray(imagem);

f = waitbar(0,'Espere um pouco...');
pause(.5)

waitbar(.5,f,'Carregando a sua imagem');
pause(1)

waitbar(1,f,'Processando a sua imagem em tons de cinza');
pause(1)

waitbar(1.7,f,'Acabando...');
pause(1)

close(f)

%>>> Cria uma máscara na tentativa de eliminar as sombras presentes na <<<<
%>>>>>>>>>>>>>>>>>>>>>>>>> imagem coins2 <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

if(strcmp(resposta_imagem,'coins2'))
    I = rgb2hsv(imagem);
    I1 = I(:,:,2);
    thresh = I1 > 0.40;
    thresh = bwareaopen(thresh,100); 
    mask_img = thresh.*I1;
    mask_img = edge(mask_img,'canny',graythresh(mask_img));
    mask_img = imfill(mask_img,'hole');
end


%>>>>>>>>>>>>> Lê os argumentos para main_image_recognition.m <<<<<<<<<<<<<

%>>>>>>>>>>>>>>>>>> Tipo de ruido e parametros do ruido <<<<<<<<<<<<<<<<<<<
pergunta_ruido = {'Que tipo de ruido pretende introduzir?'};
resposta_ruido = questdlg(pergunta_ruido,titulo,'salt-and-pepper','gaussian','salt-and-pepper');
        
if(strcmp(resposta_ruido,'gaussian'))
    ruido = 'gaussian';
    pergunta = {'Qual a variação pretendida?(0-0.62)'};
    resposta = inputdlg(pergunta,titulo,linhas_necessarias);
    parametro_ruido=str2double(resposta{1});
elseif( strcmp(resposta_ruido,'salt-and-pepper'))
    ruido='saltandpepper';
    pergunta = {'Qual a ocorrencia pretendida?(0-1)'};
    resposta = inputdlg(pergunta,titulo,linhas_necessarias);
    parametro_ruido=str2double(resposta{1});
    if(parametro_ruido<0 || parametro_ruido>1)
        warning('Valor incorreto!')
        return
    end             
end

if(strcmp(resposta_imagem,'coins2'))
    main_image_recognition(resposta_imagem,gray_img,ruido,parametro_ruido,mask_img,imagem);
else
    main_image_recognition(resposta_imagem,gray_img,ruido,parametro_ruido,imagem);
end