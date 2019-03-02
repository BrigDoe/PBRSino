%% SCRIPT PBRS 
close all; 
clear all;
clc; 
fclose('all'); 
delete(instrfindall);
filename = 'datos_pbrs_ox_val.xlsx';
delete(filename);
%%delete filename

%% creacion de objeto serial
s = serial('COM16');
s.Terminator = 'CR/LF';
s.Baudrate=9600;
plotTitle='PBRS Oxigeno Disuelto';
xLabel='Tiempo (s)';
yLabel='Oxigeno (mg/L)';
y2Label='Activacion';
plotGrid = 'on';                
delay = 0.01;

%Define Function Variables
time = 0;
temperatura = 0;
valor_entrada_arduino = 0;
count = 0;


%Set up Plot
figure
plotGraph(1) = plot(time,temperatura);
title(plotTitle,'FontSize',25);
xlabel(xLabel,'FontSize',15);
ylabel(yLabel,'FontSize',15);
grid(plotGrid);

% %Set up Plot 
% figure
% plotGraph(2) = plot(time,valor_entrada_arduino);
% title('Activacion Relay Arduino','FontSize',25);
% xlabel(xLabel,'FontSize',15);
% ylabel('Activacion','FontSize',15);
% grid(plotGrid);

fopen(s);

currentMillis = tic;
period=1*1000;
offset=1*1000;
period=period+offset;
delay = 0.1;
tic
startMillis=floor(toc*1000);
randNumber = (4).*rand(1) -2 ; 

      if (randNumber<0)
        valor_entrada_arduino=0;
        fprintf(s,'B0');
        %% APAGA EL RELAY
      else 
        valor_entrada_arduino=1;
        fprintf(s,'B1');
        %% ENCIENDE EL RELAY
      end



while ishandle(plotGraph)     
   currentMillis=floor(toc*1000);
   base = currentMillis- startMillis;
   react = period + offset;
   base/1000
   react/1000
   
   
   if ((currentMillis - startMillis) >= (period+offset))
      period=((10).*rand(1)+1)*1000;  
      randNumber = (4).*rand(1) -2 ; 
      if (randNumber<0)
        valor_entrada_arduino=0;
        fprintf(s,'B0');
        %% APAGA EL RELAY
      else 
        valor_entrada_arduino=1;
        fprintf(s,'B1');
        %% ENCIENDE EL RELAY
      end
      startMillis = currentMillis; 
   end         
        valor_entrada_arduino
        str = fscanf(s);
        TEMP = strsplit(str,',');
        temp=str2double(TEMP(1));        
        count = count + 1;    
        time(count) = toc;
        centigrados(count) = temp;
        valor_arduino(count)=valor_entrada_arduino;
        set(plotGraph(1),'XData',time,'YData',centigrados); 
       % set(plotGraph(2),'XData',time,'YData',valor_arduino); 
        axis([time(count)-10 time(count) 0 40]);
        temp
        pause(delay)  
end

T=table(centigrados,time);
col_header={'Oxigeno disuelto','Tiempo', 'Valor Arduino'};
xlswrite(filename,col_header,'Sheet1', 'B1');
xlswrite(filename,[centigrados.' time.' valor_arduino.'],'Sheet1', 'B2');

%writetable(T,filename,'Sheet',1,'Range','D1');

toc
fprintf(s,'D1');

fclose(s)



