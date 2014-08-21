function Ihor=hor_edge(I,metodo,umbral)
%metodo:1-sobel
%       2-shift

[fil col]=size(I);

switch metodo
    case 1
        Ishift=[I(1,:);I];
        Ishift=Ishift(1:fil,:);
        Ivert=(I-Ishift);
        figure
        imshow(Ivert)
        title('bordes shifted')
        
    case 2
        C=double(I);
        for i=1:size(C,1)-2
            for j=1:size(C,2)-2
                %Sobel mask for x-direction:
                Gx=((2*C(i+2,j+1)+C(i+2,j)+C(i+2,j+2))-(2*C(i,j+1)+C(i,j)+C(i,j+2)));
                %Sobel mask for y-direction:
                %Gy=((2*C(i+1,j+2)+C(i,j+2)+C(i+2,j+2))-(2*C(i+1,j)+C(i,j)+C(i+2,j)));
                %The gradient of the image
                %B(i,j)=abs(Gx)+abs(Gy);
                %Igris(i,j)=sqrt(Gx.^2+Gy.^2);
                Ivert(i,j)=uint8(abs(Gx));
                %Ihor(i,j)=uint8(abs(Gy));
      
            end
        end
        Ivert=[Ivert zeros(size(Ivert,1),2)];
        Ivert=[Ivert;zeros(2,size(Ivert,2))];
        figure
        imshow(Ivert)
        title('bordes sobel')
end
Ihor=Ivert>umbral;

% Ishift=[I(1,:);I];
% Ishift=Ishift(1:fil,:);
% Ihor=(I-Ishift);
% 
% 
% 
% C=double(I);
% for i=1:size(C,1)-2
%     for j=1:size(C,2)-2
%         %Sobel mask for x-direction:
%         Gx=((2*C(i+2,j+1)+C(i+2,j)+C(i+2,j+2))-(2*C(i,j+1)+C(i,j)+C(i,j+2)));
%         %Sobel mask for y-direction:
%         Gy=((2*C(i+1,j+2)+C(i,j+2)+C(i+2,j+2))-(2*C(i+1,j)+C(i,j)+C(i+2,j)));
%       
%         %The gradient of the image
%         %B(i,j)=abs(Gx)+abs(Gy);
%         %Igris(i,j)=sqrt(Gx.^2+Gy.^2);
%         Ivert(i,j)=uint8(abs(Gx));
%         Ihor(i,j)=uint8(abs(Gy));
%       
%     end
% end
% 
% Ivert=[zeros(size(Ivert,1),2) Ivert];
% Ivert=[zeros(2,size(Ivert,2));Ivert];
% figure
% imshow(Ivert)
% figure
% imshow(Ivert>umbral)
% Ihor=Ivert>umbral;
% %Ihor=Ihor>umbral;

end