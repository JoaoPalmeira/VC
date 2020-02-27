
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%>>>>Aplica a tranformada de Hough para executar a estração do circulo<<<<<
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

function [centers,radius] = HoughTransform(img,r1,r2,s,et)

[centers,radius] = imfindcircles(img,[r1 r2],'Sensitivity',s,'EdgeThreshold',et);

end

