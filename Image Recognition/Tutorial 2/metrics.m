%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%>>>>> Cria o histograma com a distribui��o dos tamanhos dos objetos <<<<<<
%>>>>>>>>>>>>>>>> usando o raio e a �rea como medidas <<<<<<<<<<<<<<<<<<<<<
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

function [s] = metrics(radii)

%>>>>>>>>>>>>>>>>>>>>>> Cria histograma do raio <<<<<<<<<<<<<<<<<<<<<<<<<<<
    
    [s c]=size(radii);
    figure,hist(radii),title('Histograma do raio'),hold on
    ylabel('Contagem'),xlabel('Valor do raio')

%>>>>>>>>>>>>>>>>>>>>>> Cria histograma da �rea <<<<<<<<<<<<<<<<<<<<<<<<<<<
    area=pi .* radii.^2;
    figure,hist(area),title('Histograma da �rea'),hold on
    ylabel('Contagem'),xlabel('Valor da area')
    
end