clear all
close all
Direccion=pwd+"\7 h record\";
% Primer segmento
Cantidad_Archivos=106
string
Datos__Prototipo_DI=zeros(1,Cantidad_Archivos*240128);
Detecion_RR_Prototipo_DI=zeros(1,Cantidad_Archivos*240128);
Datos__Prototipo_aVF=zeros(1,Cantidad_Archivos*240128);
Detecion_RR_Prototipo_aVF=zeros(1,Cantidad_Archivos*240128);
Datos__Prototipo_V2=zeros(1,Cantidad_Archivos*240128);
Detecion_RR_Prototipo_V2=zeros(1,Cantidad_Archivos*240128);
Index_Datos=0;
for Index=1 : 106
    % especifico el archivo a leer
    if Index<10
        Archivos=fopen(Direccion+'Registro000'+string(Index)+'.ecga','rb');
    elseif Index<100
        Archivos=fopen(Direccion+'Registro00'+string(Index)+'.ecga','rb');
    elseif Index<1000
        Archivos=fopen(Direccion+'Registro0'+string(Index)+'.ecga','rb');
    end
    % Leo los datos del archivo
    while ~feof(Archivos)
        [Datos,cnt]=fread(Archivos,inf,'uint8');
    end
    fclose(Archivos);
    
    for i=0:length(Datos)/15-1
        Index_Datos=Index_Datos+1;
        Datos__Prototipo_DI(Index_Datos)= (Datos(15*i+1)*65536+Datos(15*i+2)*256+Datos(15*i+3))-8388608;
        Detecion_RR_Prototipo_DI(Index_Datos)=(Datos(15*i+4)*256+Datos(15*i+5));
        
        Datos__Prototipo_aVF(Index_Datos)=(Datos(15*i+6)*65536+Datos(15*i+7)*256+Datos(15*i+8))-8388608;
        Detecion_RR_Prototipo_aVF(Index_Datos)=(Datos(15*i+9)*256+Datos(15*i+10));
        
        Datos__Prototipo_V2(Index_Datos) = (Datos(15*i+11)*65536+Datos(15*i+12)*256+Datos(15*i+13))-8388608;
        Detecion_RR_Prototipo_V2(Index_Datos)=(Datos(15*i+14)*256+Datos(15*i+15));
        
    end
    
end
% Ajustar la ganancia
Datos__Prototipo_DI=((Datos__Prototipo_DI)/2^24)*4800;
Datos__Prototipo_aVF=((Datos__Prototipo_aVF )/2^24)*4800;
Datos__Prototipo_V2=((Datos__Prototipo_V2 )/2^24)*4800;

fm=1000;
Inicio=1;
figure()
title('Registro Completo')
t=0.001:0.001:length(Datos__Prototipo_DI)/1000;
plot (t/3600,Datos__Prototipo_DI,"Color",[0 0.4470 0.7410], 'LineWidth',2.5,'DisplayName','Lead  DI')
hold on;
plot (t/3600,Datos__Prototipo_aVF,"Color",[0.8500 0.4750 0.0980], 'LineWidth',2.5,'DisplayName','Lead  aVF')
plot (t/3600,Datos__Prototipo_V2,"Color",[0.4660 0.6740 0.1880], 'LineWidth',2.5,'DisplayName','Lead  V2')

set(gca, 'FontSize', 18, 'FontWeight', 'bold')
legend('LineWidth',1)
ylabel('Voltage(mV)')
xlabel('Time(s)')
xlim([0 7.021])


figure()
title('Fragmento de Registro')
plot (t/3600,Datos__Prototipo_DI,"Color",[0 0.4470 0.7410], 'LineWidth',2.5,'DisplayName','Lead  DI')
hold on;
plot (t/3600,Datos__Prototipo_aVF,"Color",[0.8500 0.3250 0.0980], 'LineWidth',2.5,'DisplayName','Lead  aVF')
plot (t/3600,Datos__Prototipo_V2,"Color",[0.4660 0.6740 0.1880], 'LineWidth',2.5,'DisplayName','Lead  V2')
set(gca, 'FontSize', 18, 'FontWeight', 'bold')
legend('LineWidth',1)
ylabel('Voltage(mV)')
xlabel('Time(h)')

Index_DI=find(Detecion_RR_Prototipo_DI>100);
Index_aVF=find(Detecion_RR_Prototipo_aVF>100);
Index_V2=find(Detecion_RR_Prototipo_V2>100);

plot (t(Index_DI-48)/3600,Datos__Prototipo_DI(Index_DI-48),"o", 'LineWidth',2.5,'DisplayName','QRS Detection DI')
plot (t(Index_aVF-48)/3600,Datos__Prototipo_aVF(Index_aVF-48),"square", 'LineWidth',2.5,'DisplayName','QRS detection aVF')
plot (t(Index_V2-48)/3600,Datos__Prototipo_V2(Index_V2-48),"^", 'LineWidth',2.5,'DisplayName','QRS detection V2')

set(gca, 'FontSize', 18, 'FontWeight', 'bold')
legend('LineWidth',1)
ylabel('Voltage(mV)')
xlabel('Time(h)')
alldatacursors = findall(gcf,'type','hggroup')
set(alldatacursors,'FontSize',18)

xlim([5250/3600 5260/3600])







figure()
title('Duracion del RR')
% plot (t(Index_DI-48)/3600,Detecion_RR_Prototipo_DI(Index_DI),"o", 'LineWidth',2.5,'DisplayName','QRS Detection DI')
% hold on;
% plot (t(Index_aVF-48)/3600,Detecion_RR_Prototipo_aVF(Index_aVF),"square", 'LineWidth',2.5,'DisplayName','QRS detection aVF')
% plot (t(Index_V2-48)/3600,Detecion_RR_Prototipo_V2(Index_V2),"^", 'LineWidth',2.5,'DisplayName','QRS detection V2')
plot (t(Index_V2-48)/3600,Detecion_RR_Prototipo_V2(Index_V2),"*r", 'LineWidth',2.5,'DisplayName','QRS detection V2')

set(gca, 'FontSize', 18, 'FontWeight', 'bold')
legend('LineWidth',1)
ylabel('Time(ms)')
xlabel('Time(h)')
alldatacursors = findall(gcf,'type','hggroup')
set(alldatacursors,'FontSize',18)

xlim([0 7.021])
