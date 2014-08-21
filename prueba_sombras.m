%%clc
clear all
close all
%%
ruta='C:\Users\Roger\Desktop\Datasets_carDetection\data-CMUVD\videos\set00\imgs\';
ruta1='C:\Users\Roger\Desktop\exposiciones_vision_posgrado\deteccion_simetria\varias\';
umbral_bordes=20;
largo_minimo=11;
normalizar=true;
se = strel('line',8, 0); % linea recta de 8 pixeles 
se1 = strel('square',3);%cuadrado 3x3
se2=strel('line',8, 90); %
se3=strel('line',3, 90); %

I=imread(strcat(ruta,'I00000.jpg'));%86,315
I=I(1:900,:,:);%recorto para quitar la parte del carro
%I=imread('img_000.jpg');
imshow(I)
title('original')
I=imresize(I,[240 320]);
    if(length(size(I))>2)%si esta en color la pasamos a gris
        Igris=rgb2gray(I);
    else
        Igris=I;
    end
figure
imshow(Igris)
title('grises')
figure
imhist(Igris);
title('hist grises')

%%
%%normalizacion
%Igris = histeq(Igris);%mirar otras tecnicas  
if(normalizar)
%Igris = double(Igris)./double(max(Igris(:)));
%Igris=uint8(Igris*255);
ratio=double(max(Igris(:))-min(Igris(:)));
norm=-10;

Igris=double(Igris+norm)./ratio;
Igris=uint8(Igris*255);
figure
imshow(Igris)
title('gris normalizada')
figure
imhist(Igris);
title('hist grises normalizada')
end
%%

Isombras=LHCR(uint8(Igris));
figure
imshow(Isombras)
title('Isombras')
%Isombras = imdilate(Isombras,se1);
%Isombras = imclose(Isombras,se2);
%Isombras=imopen(Isombras,se2);
figure
imshow(Isombras)
title('Isombras morfo')


Ihor=hor_edge(Igris,2,40);%40 para sobel 15 para shifted
figure
imshow(Ihor);
title('bordes binarizada')
% Ihor = imclose(Ihor,se);
%Ihor=imopen(Ihor,se);
%Ihor=imdilate(Ihor,se1);
figure
imshow(Ihor);
title('bordes morfo')
Isegmentada=(Ihor&Isombras);
figure
imshow(Isegmentada);
title('and entre sombras y bordes')
figure
RIM=uint8(Isegmentada);
RIM = cat(3,1-RIM,RIM*254+1,1-RIM);
imshow(I.*RIM)

closeBW = imclose(Isegmentada,se);
openBW=imopen(Isegmentada,se);
figure, imshow(closeBW),title('closed')
lines = cv.HoughLinesP(closeBW,'Rho',10,'Threshold',5,'MinLineLength',5,'MaxLineGap',20,'Theta',pi/2);
%openBW=closeBW;
figure, imshow(openBW),title('opened')
figure, imshow(I),title('original con hough')
hold on
for i=1:numel(lines)
    if(lines{i}(1)==lines{i}(3))
        break
    end
    line([lines{i}(1),lines{i}(3)],[lines{i}(2),lines{i}(4)],'linewidth',2,'Color','g');
end


RIM=uint8(openBW);
RIM = cat(3,1-RIM,RIM*254+1,1-RIM);
figure
imshow(I.*RIM)


[fil,col]=size(openBW);


cnt=0;
NL=0;
%%
%%se recorre la imagen por filas de izq a derecha para ir creando lineas
arreglo=[];
arreglo1=[];
for i=1:fil%i=fil:-1:1
    for j=1:col
        if(openBW(i,j)==1)%pixel=1
            if(NL==0)%nueva linea
                NL=1;
                cnt=cnt+1;
                arreglo(cnt).izq=[i,j]; 
                arreglo(cnt).der=[i,j];
                
            else%hace parte de una linea en creacion
                arreglo(cnt).der=[i,j];         
                
            end      
        else%pixel=0
            if(NL==1)
               NL=0; 
            end      
            
        end
        
    end
    
end



%%filtra lineas x tamaño
%
if(~isempty(arreglo))
    %arreglo=filtrar_lineas(arreglo,largo_minimo);
     arreglo(1).idx=1;
else
    disp('array de lineas vacio')
end









%%agrupa lienas de acuerdo a su posicion
dist_y=8;

% for i=2:length(arreglo)
%     if(arreglo(i-1).der(1)-arreglo(i).der(1)<=dist_y)
%         if   (((arreglo(i).izq(2)<=arreglo(i-1).izq(2))&&(arreglo(i).der(2)<=arreglo(i-1).der(2))&&(arreglo(i).der(2)>=arreglo(i-1).izq(2)))...%revisa si hay interseccion en X
%               ||((arreglo(i).izq(2)>=arreglo(i-1).izq(2))&&(arreglo(i).der(2)>=arreglo(i-1).der(2))&&(arreglo(i).izq(2)<=arreglo(i-1).der(2)))...
%               ||((arreglo(i).izq(2)<=arreglo(i-1).izq(2))&&(arreglo(i).der(2)>=arreglo(i-1).der(2)))...
%               ||((arreglo(i).izq(2)>=arreglo(i-1).izq(2))&&(arreglo(i).der(2)<=arreglo(i-1).der(2))))
%             arreglo(i).idx=arreglo(i-1).idx;
%         else
%             arreglo(i).idx=arreglo(i-1).idx+1;          
%             
%         end
%     else
%         arreglo(i).idx=arreglo(i-1).idx+1;
%         
%     end
%     
% end
vecinos=30;%numero de lineas q va a revisar por vecindad
idx_actual=1;

for i=2:length(arreglo)
    for j=i-1:-1:i-vecinos
        if(j<1)
            idx_actual=idx_actual+1;
            arreglo(i).idx=idx_actual;
            break;
        end
        
        if(interseccion(arreglo(i),arreglo(j),dist_y))
            arreglo(i).idx=arreglo(j).idx;
            disp(strcat('interseccion entre la linea ',int2str(i),' y la linea  ',int2str(j)));
            break;
            
%         else
%            disp('no hubo interseccion'); 
        end
        
        if(j==i-vecinos)
           idx_actual=idx_actual+1;
           arreglo(i).idx=idx_actual;
        end
        
    end
    
end






%%
%%combina lineas

if(~isempty(arreglo))
   
    num_lineas=idx_actual;%arreglo(length(arreglo)).idx;%num de lineas se ve en el idex del ultimo 

    for i=1:num_lineas
        pos=find([arreglo.('idx')]==i);%indices de las lineas i
        %arreglo([arreglo.idx]==i)
        minimox=1000;%minimo inicial--revisar
        maximox=0;
        maximoy=0;
        for j=1:length(pos)
            if(arreglo(pos(j)).izq(2)<minimox)
                minimox=arreglo(pos(j)).izq(2);
            end
            if(arreglo(pos(j)).der(2)>maximox)
                maximox=arreglo(pos(j)).der(2);
            end
            if(arreglo(pos(j)).der(1)>maximoy)
                maximoy=arreglo(pos(j)).der(1);
            end

        end
        arreglo1(i).izq(2)=minimox;%eje x
        arreglo1(i).der(2)=maximox;
        arreglo1(i).izq(1)=maximoy;%arreglo(pos(1)).izq(1);%eje y
        arreglo1(i).der(1)=maximoy;%arreglo1(i).izq(1);

    end
end



%%
%%grafica los rectangulos sin agrupar
hold on
if(~isempty(arreglo))
    for i=1:length(arreglo)
        plot(arreglo(i).izq(2),arreglo(i).izq(1),'rx');
        plot(arreglo(i).der(2),arreglo(i).der(1),'bx');
        w=arreglo(i).der(2)-arreglo(i).izq(2);
        if(w<1)
            w=1
        end
        arrayrects{i}=[arreglo(i).izq(2),arreglo(i).izq(1)-w,w,w];
        rectangle('Position',[arreglo(i).izq(2),arreglo(i).izq(1)-w,w,w],'edgecolor','b','linewidth',2);

    end
    figure
imshow(I)
title('rectangulos azules agrupados')
hold on

rects = cv.groupRectangles(arrayrects,1,'EPS', 0.5);

for i = 1:numel(rects)
    if(rects{i}(3)>largo_minimo)
    rectangle('Position',  rects{i}, ...
              'EdgeColor', 'g','linewidth',2);
    end
end
    
else
    disp('array de lineas vacio despues de filtrado')
end

%%
figure
imshow(I)

hold on
if(~isempty(arreglo1))
    for i=1:length(arreglo1)
        plot(arreglo1(i).izq(2),arreglo1(i).izq(1),'rx');
        plot(arreglo1(i).der(2),arreglo1(i).der(1),'bx');
        w=arreglo1(i).der(2)-arreglo1(i).izq(2);
        if(w<1)
            w=1
        end
        %arrayrects{i}=[arreglo1(i).izq(2),arreglo1(i).izq(1)-w,w,w];
        rectangle('Position',[arreglo1(i).izq(2),arreglo1(i).izq(1)-w,w,w],'edgecolor','r','linewidth',2);

    end
% figure
% imshow(I)
% hold on
% 
% rects = cv.groupRectangles(arrayrects,0,'EPS', 0.1);
% for i = 1:numel(rects)
%     rectangle('Position',  rects{i}, ...
%               'EdgeColor', 'g');
% end
else
    disp('array de lineas vacio despues de filtrado')
end



detector = cv.CascadeClassifier('cars3.xml');
im =I;% imread('myface.jpg');
% Preprocess
gr = cv.cvtColor(im, 'RGB2GRAY');
gr = cv.equalizeHist(gr);
% Detect
boxes = detector.detect(gr, 'ScaleFactor',  1.3, ...
                            'MinNeighbors', 2, ...
                            'MinSize',      [20, 20]);
% Draw results
figure
imshow(im);
title('haar');
for i = 1:numel(boxes)
    rectangle('Position',  boxes{i}, ...
              'EdgeColor', 'g');
end