%%
function Isombras=LHCR(I)



%% LCHR ( Lowest Central Homogeneous Region )

    IM=I;
    Igris=IM;
    [row,col] = size(IM);
	imTH = graythresh(IM);
    % bordes
    
	hE =edge(IM,'canny'); 
  
    % ponemos negro los bordes, blanco el resto
	hE = 1-hE;
    %eliminamos bordes de la primera y ultima fila
	hE(1,:) = 1;
	hE(row,:) = 1;
    figure
    imshow(hE)
    %pintamos bordes en la imagen en grises
	IM = uint8(hE) .* IM;	
    %figure
    %imshow(IM)
    
	RIM = zeros(row,col);
	% hacemos Lowest Central Homogeneous Region
    for c = 1:col
		r = row;
        while (r > 0 && IM(r,c) ~= 0 )
			RIM(r,c) = 1;
			r = r-1;		
        end
    end	 
     %figure
    %imshow(RIM)
    RIM = uint8(RIM);
    road=IM.*RIM;
    v=double(road(find(road>0)));%hallamos los pixeles con valor diferente de cero que serian la carretera
    
    figure
    imshow(IM.*RIM)
    RIM = cat(3,RIM,RIM,RIM);
    
    mu=mean(v)
    ro=std(v)
    umbral=mu-3*ro;
    if(umbral<25)
        umbral=25
    end
    Isombras=Igris<umbral;
    figure
    hist(v,256);
