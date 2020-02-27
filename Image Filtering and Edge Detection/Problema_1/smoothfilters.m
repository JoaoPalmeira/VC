%This script reads arguments of function main_smoothfilters and then
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

%reads arguments for main_smoothfilters.m

%Responsável por input: type of noise e noise parameters
tipo_ruido = questdlg('Que tipo de ruído quer introduzir?','Tutorial','SNP','Gaussian', 'SNP');
ruido=lower(strtrim(tipo_ruido));
        
if(strcmp(ruido,'gaussian'))
    prompt = {'Que variância deseja introduzir?'};
    answer = inputdlg(prompt,dlg_title,num_lines);
    noise_param=str2double(answer{1});
elseif(strcmp(ruido,'snp') || strcmp(ruido,'salt and pepper') || strcmp(ruido,'saltandpepper'))
    if(strcmp(ruido,'salt and pepper'))
        ruido='saltandpepper';
    end
    prompt = {'Qual é a ocorrência? (Digite um número entre 0 e 1)'};
    answer = inputdlg(prompt,dlg_title,num_lines);
    noise_param=str2double(answer{1});
    if(noise_param<0 && noise_param>1)
        warning('Valor de ocorrênci inapropriado')
        return
    end
else
    warning('Ruído inexistente')
    return              
end
        
        
%Responsável por input: filtering domain,type of smoothing and
%filter parameters

dominio = questdlg('Que domínio de filtragem pretende?','Tutorial','Spatial','Frequency', 'Spatial');
domain=lower(strtrim(dominio));
switch domain
    case 'spatial'
        prompt = {'Que filtro pretende? (average, gaussian ou median)'};
        answer = inputdlg(prompt,dlg_title,num_lines);
        filter=lower(strtrim(answer{1}));
        switch filter
            case 'average'
                prompt = {'Qual é o tamanho do filtro?'};
                answer = inputdlg(prompt,dlg_title,num_lines);
                filter_size=str2double(answer{1});
                main_smoothfilters(result,img_gray,ruido,noise_param,domain,filter,filter_size);
            case 'gaussian'
                prompt = {'Qual é a variância?'};
                answer = inputdlg(prompt,dlg_title,num_lines);
                filter_param=str2double(answer{1});
                prompt = {'Qual é o tamanho do filtro?'};
                answer = inputdlg(prompt,dlg_title,num_lines);
                filter_size=str2double(answer{1});
                main_smoothfilters(result,img_gray,ruido,noise_param,domain,filter,filter_size,filter_param);
            case 'median'
                prompt = {'Qual é o tamanho do filtro?'};
                answer = inputdlg(prompt,dlg_title,num_lines);
                filter_size=str2double(answer{1});
                main_smoothfilters(result,img_gray,ruido,noise_param,domain,filter,filter_size);
            otherwise
                warning('Filtro inexistente')
                return
        end
    case 'frequency'
        prompt = {'Que filtro pretende? (gaussian ou butterworth)'};
        answer = inputdlg(prompt,dlg_title,num_lines);
        filter=lower(strtrim(answer{1}));
        switch filter
            case 'gaussian'
                prompt = {'Qual é a frequência de corte do filtro?'};
                answer = inputdlg(prompt,dlg_title,num_lines);
                filter_cutoff=str2double(answer{1});
                main_smoothfilters(result,img_gray,ruido,noise_param,domain,filter,filter_cutoff);
            case 'butterworth'
                prompt = {'Que ordem pretende?'};
                answer = inputdlg(prompt,dlg_title,num_lines);
                filter_param=str2double(answer{1});
                prompt = {'Qual é a frequência de corte do filtro?'};
                answer = inputdlg(prompt,dlg_title,num_lines);
                filter_cutoff=str2double(answer{1});
                main_smoothfilters(result,img_gray,ruido,noise_param,domain,filter,filter_cutoff,filter_param);    
            otherwise
                warning('Filtro inexistente')
                return
        end
    otherwise
        warning('Domínio inexistente')
        return
end
