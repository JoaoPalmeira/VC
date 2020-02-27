%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%>>>>> Cria o histograma com a distribuição dos tamanhos dos objetos <<<<<<
%>>>>>>>>>>>>>>>> usando o raio e a área como medidas <<<<<<<<<<<<<<<<<<<<<
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

function [s] = metrics(radii)

%>>>>>>>>>>>>>>>>>>>>>> Cria histograma do raio <<<<<<<<<<<<<<<<<<<<<<<<<<<
    
    [s c]=size(radii);
    figure,hist(radii),title('Histograma do raio'),hold on
    ylabel('Contagem'),xlabel('Valor do raio')

%>>>>>>>>>>>>>>>>>>>>>> Cria histograma da área <<<<<<<<<<<<<<<<<<<<<<<<<<<
    area=pi .* radii.^2;
    figure,hist(area),title('Histograma da área'),hold on
    ylabel('Contagem'),xlabel('Valor da area')
    
end