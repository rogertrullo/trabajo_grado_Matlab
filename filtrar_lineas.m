function array_lineas=filtrar_lineas(arreglo,longitud_minima)

array_lineas=[];
for i=1:length(arreglo)
    if(arreglo(i).der(2)-arreglo(i).izq(2)>longitud_minima)
        array_lineas=[array_lineas;arreglo(i)];
        
        
    end
    
end

end