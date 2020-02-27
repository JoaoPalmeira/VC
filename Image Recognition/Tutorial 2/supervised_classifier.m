%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%>>>>>>>> Aplica o SVM multiclasse para treinar um classificador <<<<<<<<<< 
%>>>>>>>>>>>>>>>>>>>>> para detecção de moedas <<<<<<<<<<<<<<<<<<<<<<<<<<<<
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

function [classificadorCategoria] = supervised_classifier()

rootFolder = fullfile(fileparts(which(mfilename)),'Imagens');
categories = {'1cent','2cent','5cent','10cent','20cent','50cent','1euro','2euro'};

dadosImagem = imageDatastore(fullfile(rootFolder,categories),'IncludeSubfolders',true,'FileExtensions','.jpg','LabelSource','foldernames');

%>>>>>>>>>>>>>>>>>>>> Obtem dados de treinar a imagem <<<<<<<<<<<<<<<<<<<<<
 
trainingSet=dadosImagem;
 
%>>>>>>>>>>>> Obtem as características relevantes das imagens <<<<<<<<<<<<<
	
    bag = bagOfFeatures(trainingSet);

	imagem = readimage(dadosImagem, 1);
	featureVector = encode(bag, imagem);

%>>>>>>>>>>>>>>>>>>> Histograma de Visual word occurrences <<<<<<<<<<<<<<<< 
	
    figure
	bar(featureVector)
	title('Visual word occurrences')
	xlabel('Visual word index')
	ylabel('Frequency of occurrence')

%>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Treina o SVM <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	
    classificadorCategoria = trainImageCategoryClassifier(trainingSet, bag);

end

