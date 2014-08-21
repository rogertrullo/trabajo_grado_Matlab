function valor=interseccion(L1,L2,dist_y)%L1 es i, L2 es i-1

    if(L1.der(1)-L2.der(1)<=dist_y)
            if   (((L1.izq(2)<=L2.izq(2))&&(L1.der(2)<=L2.der(2))&&(L1.der(2)>=L2.izq(2)))...%revisa si hay interseccion en X
                  ||((L1.izq(2)>=L2.izq(2))&&(L1.der(2)>=L2.der(2))&&(L1.izq(2)<=L2.der(2)))...
                  ||((L1.izq(2)<=L2.izq(2))&&(L1.der(2)>=L2.der(2)))...
                  ||((L1.izq(2)>=L2.izq(2))&&(L1.der(2)<=L2.der(2))))
                
                valor=true;
            else
                
                valor=false;

            end
    else
            
            valor=false;

    end



end