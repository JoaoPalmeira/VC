%This script reads arguments of function main_CannyDetector and then
%executes the function

% Change the current folder to the folder of this m-file.
if(~isdeployed)
  cd(fileparts(which(mfilename)));
end

clear;
%Reads image that will be used
dlg_title = 'Tutorial';
num_lines = 1;

str = {'Por favor selecione a imagem:'};
S = {'Lena';'Baboon';'Castle'};

res = listdlg ('PromptString',str,'ListSize', [150 150],'ListString', S, 'SelectionMode','single');

switch(res)
    case 1
        result='lena';
        img=imread('images/lena.jpg');
    case 2
        result='baboon';
        img=imread('images/baboon.png');
    case 3
        result='castle';
        img=imread('images/castle.png');
end

img_gray=rgb2gray(img);

f = waitbar(0,'Espere um pouco...');
pause(.5)

waitbar(.5,f,'Carregando a sua imagem');
pause(1)

waitbar(1,f,'Processando a sua imagem em tons de cinza');
pause(1)

waitbar(1.7,f,'Acabando...');
pause(1)

close(f)
%Applies histogram equalization for high contrast image
img_gray=histeq(img_gray);
imwrite(img_gray,[result '_equalized.png']);

%Adds gaussian noise
prompt = {'Qual é a variância para o ruído gaussiano?'};
answer = inputdlg(prompt,dlg_title,num_lines);
noise_param=str2double(answer{1});
noisy= imnoise(img_gray,'gaussian',0,noise_param);

prompt = {'Qual é o tamanho do filtro para o gaussian smoothing?'};
answer = inputdlg(prompt,dlg_title,num_lines);
filter_size=str2double(answer{1});
    
prompt = {'Qual é a variância para o gaussian smoothing?'};
answer = inputdlg(prompt,dlg_title,num_lines);
variance=str2double(answer{1});

[img_mag,img_nmax,img_hyst]=main_CannyDetector(noisy,filter_size,variance);

%Create file paths0
filename1=[result '_edge_canny_' num2str(filter_size) '_' num2str(variance) '.png'];
filename2=[result '_edge_canny_nonmax_' num2str(filter_size) '_' num2str(variance) '.png'];
filename3=[result '_edge_canny_hysteresis_' num2str(filter_size) '_' num2str(variance) '.png'];
%Write on files
imwrite(img_mag,filename1);
imwrite(img_nmax,filename2);
imwrite(img_hyst,filename3);

