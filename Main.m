function Main
addpath('funciones') 
%% Importa la lista de materiales

[Materiales,~,mat] = xlsread('Materiales.xlsx');

%% Gui
Interfaz = figure('MenuBar','none','ToolBar','none');
Interfaz.Name='Predicción de aislamiento acústico. Luongo, Haimovich, Almaraz, Montemarano.';
Interfaz.NumberTitle='off';
Interfaz.Resize='on';
Interfaz.OuterPosition = [150, 100, 1000, 700];
Interfaz.Visible = 'On';
movegui(Interfaz,'center');

% Paneles

 handles.panelOpciones = uipanel('Title','Opciones',...
        'units','normalized',...
        'Position',[0.06 0.65 0.3 0.3],...
        'Fontname','arial','Fontsize',10);
    handles.panelCalculos = uipanel('Title','Métodos de cálculo',...
        'units','normalized',...
        'Position', [0.38 0.65 0.16 0.3],...
        'Fontname', 'arial','Fontsize',10);
    handles.panelAcciones = uipanel('Title','Acciones',...
        'units','normalized',...
        'Position',[0.56 0.65 0.16 0.3],...
        'Fontname','arial','Fontsize',10);
    
% Logo
    handles.panelLogo = uipanel('units','Normalized','Position',[0.74, 0.65, 0.20 0.29]);
    handles.imgaxx = axes(handles.panelLogo,'units','normalized','Position',[0.04, 0.04, 0.92, 0.92]);
    [img,~] = imread('funciones/logo.jpg');
    image(handles.imgaxx,img);
    axis off;

% Textos

handle.tex1 = uicontrol('Parent',handles.panelOpciones,'Style',...
    'text','String','Material:','units','normalized','Position',...
    [0.05 0.8 0.3 0.1],'Fontname', 'arial','Fontsize',11,'HorizontalAlignment', 'left');

handle.tex2 = uicontrol('Parent',handles.panelOpciones,'Style',...
    'text','String','Largo:','units','normalized','Position',...
    [0.05 0.55 0.3 0.1],'Fontname', 'arial','Fontsize',11,'HorizontalAlignment', 'left');

handle.tex3 = uicontrol('Parent',handles.panelOpciones,'Style',...
    'text','String','Alto:','units','normalized','Position',...
    [0.05 0.325 0.3 0.1],'Fontname', 'arial','Fontsize',11,'HorizontalAlignment', 'left');

handle.tex4 = uicontrol('Parent',handles.panelOpciones,'Style',...
    'text','String','Espesor:','units','normalized','Position',...
    [0.05 0.1 0.3 0.1],'Fontname', 'arial','Fontsize',11,'HorizontalAlignment', 'left');

handle.tex5 = uicontrol('Parent',handles.panelOpciones,'Style',...
    'text','String','[Metros]','units','normalized','Position',...
    [0.5 0.55 0.3 0.1],'Fontname', 'arial','Fontsize',11,'HorizontalAlignment', 'left');

handle.tex6 = uicontrol('Parent',handles.panelOpciones,'Style',...
    'text','String','[Metros]','units','normalized','Position',...
    [0.5 0.325 0.3 0.1],'Fontname', 'arial','Fontsize',11,'HorizontalAlignment', 'left');

handle.tex7 = uicontrol('Parent',handles.panelOpciones,'Style',...
    'text','String','[Centímetros]','units','normalized','Position',...
    [0.5 0.1 0.35 0.1],'Fontname', 'arial','Fontsize',11,'HorizontalAlignment', 'left');

%handle.tex11 = uicontrol('Parent',handles.panelOpciones,'Style',...
   % 'text','String','Fc =','units','normalized','Position',...
    %[0.05 0 0.2 0.2],'Fontname', 'arial','Fontsize',10,'HorizontalAlignment', 'left');


% Botones push

handle.button1 = uicontrol('Parent',handles.panelAcciones,'Style','pushbutton','units','normalized',...
    'String','Procesar','Position',[0.1 0.7 0.8 0.2],...
    'Fontname', 'arial','Fontsize',11);

handle.button2 = uicontrol('Parent',handles.panelAcciones,'Style','pushbutton','units','normalized',...
    'String','Exportar','Position',[0.1 0.4 0.8 0.2],...
    'Fontname', 'arial','Fontsize',11,'Enable','off');

handle.button3 = uicontrol('Parent',handles.panelAcciones,'Style','pushbutton','units','normalized',...
    'String','Reiniciar','Position',[0.1 0.1 0.8 0.2],...
    'Fontname', 'arial','Fontsize',11,'Callback',@Reiniciar);


handle.button1.Callback = @Iniciar;
handle.button2.Callback = @Exportar;

% Menus desplegables

handle.pop1 = uicontrol('Parent',handles.panelOpciones,'Style','popupmenu','units','normalized',...
    'Position',[0.3 0.8 0.6 0.125],'String',{'Acero','Aluminio','Bronce',...
    'Cobre','Contrachapado','Hierro',...
    'Hormigon','Hormigon ladrillo','Ladrillo','Madera','Neopreno',...
    'Plomo','Vidrio','PYL'},'Fontname', 'arial','Fontsize',11);
%handle.pop2 = uicontrol(Interfaz,'Style','popupmenu','Position',[290,500,90,25],'String',{'Octava', 'Tercio de Octava'},'Fontsize',12);

% checkbox para tipo de calculo

handle.check1 = uicontrol('Parent',handles.panelCalculos,'Style','checkbox','units','normalized',...
    'String','Davy','Position',[0.15 0.8 0.7 0.1],'Fontname', 'arial','Fontsize',11);

handle.check2 = uicontrol('Parent',handles.panelCalculos,'Style','checkbox','units','normalized',...
    'String','Pared simple','Position',[0.15 0.575 0.7 0.1],'Fontname', 'arial','Fontsize',11);

handle.check3 = uicontrol('Parent',handles.panelCalculos,'Style','checkbox','units','normalized',...
    'String','Sharp','Position',[0.15 0.35 0.7 0.1],'Fontname', 'arial','Fontsize',11);

handle.check4 = uicontrol('Parent',handles.panelCalculos,'Style','checkbox','units','normalized',...
    'String','ISO 12354-1','Position',[0.15 0.125 0.7 0.1],'Fontname', 'arial','Fontsize',11);

% valores editables

handle.val1 = uicontrol('Parent',handles.panelOpciones,'Style','edit','units','normalized',...
    'Position',[0.3 0.535 0.15 0.15],'Fontname', 'arial','Fontsize',10,'HorizontalAlignment', 'right');

handle.val2 = uicontrol('Parent',handles.panelOpciones,'Style','edit','units','normalized',...
    'Position',[0.3 0.31 0.15 0.15],'Fontname', 'arial','Fontsize',10,'HorizontalAlignment', 'right');

handle.val3 = uicontrol('Parent',handles.panelOpciones,'Style','edit','units','normalized',...
    'Position',[0.3 0.09 0.15 0.15],'Fontname', 'arial','Fontsize',10,'HorizontalAlignment', 'right');



IRax = axes('Box','on','Position',[0.06 0.08 0.88 0.55],'XGrid','on','YGrid','on');
IRax.XLabel.String = 'Frecuencia [Hz]';
IRax.YLabel.String = 'Transmission Loss [dB]';

set(Interfaz,'Visible','On');

%% Funciones

function Iniciar(~, ~)
    dens=Materiales(handle.pop1.Value,3);
    young = Materiales(handle.pop1.Value,4);
    perd = Materiales(handle.pop1.Value,5);
    pois = Materiales(handle.pop1.Value,6);
    largo = str2double(handle.val1.String);
    alto = str2double(handle.val2.String);
    espesor = str2double(handle.val3.String)/100;
    filtr = 2;
    
    %Gestion de errores

    if largo <= 0
        msgbox('Error en el largo de la pared: ingrese un valor positivo.','Error','warn');
        return
    end
    TF = isnan(largo);
    if TF==1
        msgbox('Error en el largo de la pared: ingrese un valor numérico.','Error','warn');
        return
    end
    if alto <= 0
        msgbox('Error en la altura de la pared: ingrese un valor positivo.','Error','warn');
        return
    end
    TF = isnan(alto);
    if TF==1
        msgbox('Error en la altura de la pared: ingrese un valor numérico.','Error','warn');
        return
    end
    if espesor <= 0
        msgbox('Error en el espesor de la pared: ingrese un valor positivo.','Error','warn');
        return
    end
    TF = isnan(espesor);
    if TF==1
        msgbox('Error en el espesor de la pared: ingrese un valor numérico.','Error','warn');
        return
    end


    % Aca arranca a calcular según los datos de entrada
    % buscara en la funcion procesos y hara los calculos segun cada modelo.

    q = procesos;

    % Segun el modelo que se haya seleccionado se cambian los valores

    if handle.check2.Value==1
        [filtro,rMasa,fc] = q.masa(filtr,young,espesor,pois,dens,largo,alto,perd);
        semilogx(filtro,rMasa,'DisplayName','Ley de Masa');...
        grid on,xlabel('Frecuencia [Hz]'),ylabel('Transmission Loss [dB]'),...
        xlim([20 20000]);ylim([0 120]); xticks([31.5 63 125 250 500 1000 2000 4000 8000 16000]);
        dcm = datacursormode;
        dcm.Enable = 'on';
        dcm.DisplayStyle = 'window';
        dcm.UpdateFcn = @displayCoordinates;        
    hold on
    end
    
    if handle.check1.Value==1
        [filtro,rDavy,fc] = q.davy(filtr,young,espesor,pois,dens,largo,alto,perd);
        semilogx(filtro,rDavy,'DisplayName','Davy');...
        grid on,xlabel('Frecuencia [Hz]'),ylabel('Transmission Loss [dB]'),...
        xlim([20 20000]);ylim([0 120]); xticks([31.5 63 125 250 500 1000 2000 4000 8000 16000]);
        dcm = datacursormode;
        dcm.Enable = 'on';
        dcm.DisplayStyle = 'window';
        dcm.UpdateFcn = @displayCoordinates;    
        hold on
    end
        
    if handle.check4.Value==1
        [filtro, Riso, fc] = q.ISO(filtr,young,espesor,pois,dens,largo,alto,perd);
        semilogx(filtro,Riso,'DisplayName','ISO 12354-1');...
        grid on,xlabel('Frecuencia [Hz]'),ylabel('Transmission Loss [dB]'),...
        xlim([20 20000]);ylim([0 120]); xticks([31.5 63 125 250 500 1000 2000 4000 8000 16000]);
        dcm = datacursormode;
        dcm.Enable = 'on';
        dcm.DisplayStyle = 'window';
        dcm.UpdateFcn = @displayCoordinates;
        hold on
    end
    
    if handle.check3.Value==1
        [filtro,rSharp,fc] = q.Sharp(filtr,young,espesor,pois,dens,largo,alto,perd);
        semilogx(filtro,rSharp,'DisplayName','Sharp');...
        grid on,xlabel('Frecuencia [Hz]'),ylabel('Transmission Loss [dB]'),...
        xlim([20 20000]);ylim([0 120]); xticks([31.5 63 125 250 500 1000 2000 4000 8000 16000]);
        dcm = datacursormode;
        dcm.Enable = 'on';
        dcm.DisplayStyle = 'window';
        dcm.UpdateFcn = @displayCoordinates;
        hold on
    end

%Error de en la selección del método.

    if handle.check1.Value==0 && handle.check2.Value==0 && handle.check3.Value==0 && handle.check4.Value==0
        msgbox('Falta ingresar método de cálculo','Error','warn');
    end

    line([fc fc],[1 140],'DisplayName','Frecuencia Crítica','LineStyle','--','Color','k')
    legend show
    hold off

    handle.tex12.String = num2str(fc);
    set(handle.button2,'Enable','on');
end

function Reiniciar(~,~)
    close
    Main   
end

function Exportar(~,~)
    try
        set(handle.button2,'Enable','off');
        set(handle.button2,'String','Exportando...');
        set(handle.button1,'Enable','off');
        set(handle.button1,'String','Espere...');
        set(handle.button3,'Enable','off');
        set(handle.button3,'String','Espere...');
        drawnow;

        [file,path] = uiputfile('*.xlsx');
        filename = fullfile(path,file);

        mat1 = mat(handle.pop1.Value+1,2);    
        dens=Materiales(handle.pop1.Value,3);
        young = Materiales(handle.pop1.Value,4);
        perd = Materiales(handle.pop1.Value,5);
        pois = Materiales(handle.pop1.Value,6);
        largo = str2double(handle.val1.String);
        alto = str2double(handle.val2.String);
        espesor = str2double(handle.val3.String)/100;
        filtr = 2;

        q = procesos;

        % Segun el modelo que se haya seleccionado se cambian los valores

        if handle.check2.Value==1
            [filtro,rMasa,fc] = q.masa(filtr,young,espesor,pois,dens,largo,alto,perd); 
        end

        if handle.check1.Value==1
           [filtro,rDavy,fc] = q.davy(filtr,young,espesor,pois,dens,largo,alto,perd);
        end

        if handle.check4.Value==1
           [filtro, Riso, fc] = q.ISO(filtr,young,espesor,pois,dens,largo,alto,perd);
        end

        if handle.check3.Value==1
           [filtro,rSharp,fc] = q.Sharp(filtr,young,espesor,pois,dens,largo,alto,perd);
        end

        %Aca se escriben los datos:


        %Inicializo los datos de excel con ceros

        xlswrite(filename,zeros(1,31),'Hoja 1','C2');
        xlswrite(filename,zeros(1,31),'Hoja 1','C3');
        xlswrite(filename,zeros(1,31),'Hoja 1','C4');
        xlswrite(filename,zeros(1,31),'Hoja 1','C5');
        xlswrite(filename,zeros(1,31),'Hoja 1','C6');

        xlswrite(filename,{'Material'},'Hoja 1','B8');
        xlswrite(filename,{'Largo'},'Hoja 1','C8');
        xlswrite(filename,{'Alto'},'Hoja 1','D8');
        xlswrite(filename,{'Espesor'},'Hoja 1','E8');
        xlswrite(filename,{'F. Corte'},'Hoja 1','F8');

        xlswrite(filename,{'Frecuencias'},'Hoja 1','B2');    
        xlswrite(filename,filtro,'Hoja 1','C2');

        xlswrite(filename,mat1,'Hoja 1','B9');
        xlswrite(filename,largo,'Hoja 1','C9');
        xlswrite(filename,alto,'Hoja 1','D9');
        xlswrite(filename,espesor,'Hoja 1','E9');
        xlswrite(filename,fc,'Hoja 1','F9');

        xlswrite(filename,{'Pared Simple'},'Hoja 1','B3');
        xlswrite(filename,{'Sharp'},'Hoja 1','B4');
        xlswrite(filename,{'Davy'},'Hoja 1','B5');
        xlswrite(filename,{'ISO 12354-1:2001'},'Hoja 1','B6');

        if handle.check2.Value==1
            xlswrite(filename,rMasa,'Hoja 1','C3');
        end

        if handle.check3.Value==1
            xlswrite(filename,rSharp,'Hoja 1','C4');
        end

        if handle.check1.Value==1
            xlswrite(filename,rDavy,'Hoja 1','C5');
        end

        if handle.check4.Value==1
            xlswrite(filename,Riso,'Hoja 1','C6');
        end
        set(handle.button2,'Enable','on');
        set(handle.button2,'String','Exportar');
        set(handle.button1,'Enable','on');
        set(handle.button1,'String','Procesar');
        set(handle.button3,'Enable','on');
        set(handle.button3,'String','Reiniciar');
        msgbox('El archivo se ha exportado correctamente')
    catch 
        set(handle.button2,'Enable','on');
        set(handle.button2,'String','Exportar');
        set(handle.button1,'Enable','on');
        set(handle.button1,'String','Procesar');
        set(handle.button3,'Enable','on');
        set(handle.button3,'String','Reiniciar');
        msgbox('Algo salió mal. Considere cerrar las planillas abiertas.','Error','warn');
    end
end

%% Funciones para calculos

function [q] = procesos 
q.masa = @MASA; %Llamar funcion MASA
q.davy = @DAVY; %Llamar funcion DAVY
q.ISO = @ISO; %Llamar funcion ISO
q.Sharp = @SHARP; %Llamar funcion Sharp
end

% LEY DE MASA

function [filtro,rMasa,fc]= MASA(filtr,young,espe,pois,dens,~,~,perd)
    tercio=[20 25 31.5 40 50 63 80 100 125 160 200 250 315 400 500 630 800 1000 1250 1600 2000 2500 3150 4000 5000 6300 8000 10000 12500 16000 20000];
    octava=[31.5 63 125 250 500 1000 2000 4000 8000 16000 20000];
    c=343;
    ro=1.18;
    ms=dens*espe;
    B=((young/(1-pois^2)))*(espe^3)/12;
    fc=((c^2)/(2*pi))*sqrt(ms/B);
    fd=(young/(2*pi*dens))*sqrt(ms/B);
    R1 = zeros(1,31);
    if filtr==1
        filtro= octava;
        for i=1:length(octava) 
           if octava(i)<=fc || octava(i)>fd
               R1(i)=20*log10(ms*octava(i))-47;
           end
           if octava(i)>fc  && octava(i)<fd
                perdtot= perd+(ms/(485*sqrt(octava(i))));
               R1(i)=20*log10((2*pi*ms*octava(i))/(2*ro*c))-10*log10(pi/(4*perdtot))+10*log10((2*pi*octava(i))/(2*pi*fc))+10*log10(1-((2*pi*fc)/(2*pi*octava(i))))-5;
           end
        end
    end
    if filtr==2
        filtro= tercio;
        for i=1:length(tercio)
            if tercio(i)<=fc || tercio(i)>fd
               R1(i)=20*log10(ms*tercio(i))-47;
            end
            if tercio(i)>fc && tercio(i)<fd
                perdtot= perd+(ms/(485*sqrt(tercio(i))));
                R1(i)=20*log10(ms*tercio(i))-10*log10(pi/(4*perdtot))-10*log10(fc/((tercio(i)-fc)))-47;
            end
        end
    end
    rMasa=R1;
end

% MÉTODO DE DAVY

function [filtro,rDavy,fc]= DAVY(filtr,young,espe,pois,dens,largo,alto,perd)
    %po = 1.18;
    c0 = 343 ;
    averages = 3; %Promedio definido por davy
    m = dens * espe;
    R = zeros(1,31);
    if filtr==1
        filtro = [31.5 63 125 250 500 1000 2000 4000 8000 16000 20000] ;
        %dB = 0.707 ;
        octave = 1;
    end
    if filtr==2
        filtro=[20,25,31.5,40,50,63,80,100,125,160,200,250,315,400,500,630,800,1000,1250,1600,2000,2500,3150,4000,5000,6000,8000,10000,12500,16000,20000];
        %dB = 0.236 ;
        octave = 3;
    end
    B = (young/(1-pois^2)) * ((espe^3)/12) ; % Rigidez a la flexión
    fc = (c0^2/(2*pi))*(sqrt(m/B));
    for i=1:length(filtro)
        f = filtro(i) ;
        Ntot= perd + (m/(485*sqrt(f)));
        ratio = f/fc;
        limit = 2^(1/(2*octave));
        if (ratio < 1 / limit) || (ratio > limit)
            TLost = Single_leaf_Davy(f,dens,young,pois,espe,Ntot,alto,largo);
        else
            Avsingle_leaf = 0;
            for j = 1:averages
                factor = 2 ^ ((2*j-1-averages)/(2*averages*octave));
                aux=10^(-Single_leaf_Davy(f*factor,dens,young,pois,espe,Ntot,alto,largo)/10);
                Avsingle_leaf = Avsingle_leaf + aux;
            end
            TLost = -10*log10(Avsingle_leaf/averages);
        end
        R(i)= TLost ;
        rDavy= R;
    end
end

% MÉTODO ISO

function [filtro, Riso, fc]=ISO(filtr,young,espe,pois,dens,largo,alto,perd)
    tercio=[20 25 31.5 40 50 63 80 100 125 160 200 250 315 400 500 630 800 1000 1250 1600 2000 2500 3150 4000 5000 6300 8000 10000 12500 16000 20000];
    octava=[31.5 63 125 250 500 1000 2000 4000 8000 16000 20000];
    c=343;
    ro=1.18;
    ms=dens*espe;
    B=((young/(1-pois^2)))*(espe^3)/12;
    fc=((c^2)/(2*pi))*sqrt(ms/B);
    %fd=(young/(2*pi*dens))*sqrt(ms/B);
    f11=((c^2)/(4*fc))*((1/largo^2)+(1/alto^2));
    Riso = zeros(1,31);
    if filtr==2
        filtro = tercio;
        for i=1:length(tercio)
            ko=2*pi*(tercio(i)/c);
            alfa=-0.964-(0.5+(alto/(pi*largo)))*log(alto/largo)+((5*alto)/(2*pi*largo))-(1/(4*pi*largo*alto*ko^2));
            pf=0.5*(log(ko*sqrt(largo*alto))-alfa);
            landa=sqrt(tercio(i)/fc);
            delta1=((1-landa^2)*log((1+landa)/(1-landa))+2*landa)/(4*(pi^2)*(1-landa^2)^1.5);
            delta2=(8*(c^2)*(1-2*landa^2))/((fc^2)*(pi^4)*largo*alto*landa*sqrt(1-landa^2));
            perdtot= perd+(ms/(485*sqrt(tercio(i))));
            p1=1/sqrt(1-(fc/tercio(i)));
            p2=4*largo*alto*((tercio(i))/c)^2;
            p3=sqrt((2*pi*tercio(i)*(largo+alto))/(16*c));
            if f11<fc/2 || f11==fc/2
                if tercio(i)>fc || tercio(i)==fc	
                    poiss=p1;
                else
                    if tercio(i)>fc/2
                    delta2=0;
                    end
                    poiss=((2*(largo+alto)*c*delta1)/(largo*alto*fc))+delta2;
                end
                if  f11>tercio(i) && f11<fc/2 && poiss>p2
                    poiss=p2;
                end
                if poiss>2
                    poiss=2;
                end
            end
            if f11>fc/2
            poiss=p3;
                if tercio(i)<fc && p2<p3
                    poiss=p2;
                end
                if tercio(i)>fc && p1<p3
                    poiss=p1;
                end
                if poiss>2
                    poiss=2;
                end
            end
            if tercio(i)>fc
                tau=(((2*ro*c)/(2*pi*tercio(i)*ms))^2)*((pi*fc*poiss^2)/(2*tercio(i)*perdtot));
                Riso(i)=-10*log10(tau);
            end

            if abs(tercio(i)-fc)<5
                tau=(((2*ro*c)/(2*pi*tercio(i)*ms))^2)*((pi*poiss^2)/(2*perdtot));
                Riso(i)=-10*log10(tau);
            end
            if tercio(i)<fc
                tau=(((2*ro*c)/(2*pi*tercio(i)*ms))^2)*(2*pf+(((largo+alto)^2)/((largo^2)+(alto^2)))*sqrt(fc/tercio(i))*((poiss^2)/perdtot));
                Riso(i)=-10*log10(tau);
            end	
        end
    end
    if filtr==1
        filtro = octava;
        for i=1:length(octava)
            ko=2*pi*(octava(i)/c);
            alfa=-0.964-(0.5+(alto/(pi*largo)))*log(alto/largo)+((5*alto)/(2*pi*largo))-(1/(4*pi*largo*alto*ko^2));
            pf=0.5*(log(ko*sqrt(largo*alto))-alfa);
            landa=sqrt(octava(i)/fc);
            delta1=((1-landa^2)*log((1+landa)/(1-landa))+2*landa)/(4*(pi^2)*(1-landa^2)^1.5);
            delta2=(8*(c^2)*(1-2*landa^2))/((fc^2)*(pi^4)*largo*alto*landa*sqrt(1-landa^2));
            perdtot= perd+(ms/(485*sqrt(octava(i))));
            p1=1/sqrt(1-(fc/octava(i)));
            p2=4*largo*alto*((octava(i))/c)^2;
            p3=sqrt((2*pi*octava(i)*(largo+alto))/(16*c));
            if f11<fc/2 || f11==fc/2
                if octava(i)>fc || octava(i)==fc	
                    poiss=p1;
                else
                    if octava(i)>fc/2
                        delta2=0;
                    end
                    poiss=((2*(largo+alto)*c*delta1)/(largo*alto*fc))+delta2;
                end
                if f11>octava(i) && f11<fc/2 && poiss>p2
                    poiss=p2;
                end
            end
            if f11>fc/2
                poiss=p3;
                if octava(i)<fc && p2<p3
                    poiss=p2;
                end
                if octava(i)>fc && p1<p3
                    poiss=p1;
                end
            end
            if octava(i)>fc
                tau=(((2*ro*c)/(2*pi*octava(i)*ms))^2)*((pi*fc*poiss^2)/(2*octava(i)*perdtot));
                Riso(i)=-10*log10(tau);
            end
            if octava(i)==fc
                tau=(((2*ro*c)/(2*pi*octava(i)*ms))^2)*((pi*poiss^2)/(2*perdtot));
                Riso(i)=-10*log10(tau);
            end
            if octava(i)<fc
                tau=(((2*ro*c)/(2*pi*octava(i)*ms))^2)*(2*pf+(((largo+alto)^2)/((largo^2)+(alto^2)))*sqrt(fc/octava(i))*((poiss^2)/perdtot));
                Riso(i)=-10*log10(tau);
            end	
        end
    end
end

% MÉTODO SHARP

function [filtro,rSHARP,fc] = SHARP(filtr,young,espe,pois,dens,~,~,perd)

    tercio=[20 25 31.5 40 50 63 80 100 125 160 200 250 315 400 500 630 800 1000 1250 1600 2000 2500 3150 4000 5000 6300 8000 10000 12500 16000 20000];
    octava=[31.5 63 125 250 500 1000 2000 4000 8000 16000 20000];
    c=343;
    ro=1.18;
    ms=dens*espe;
    B=((young*espe^3)/(12*(1-pois^2)));  %Calculo de coeficiente B
    fc=((c^2)/(2*pi))*sqrt(ms/B);       %Calculo de frecuencia critica
    %fd=(young/(2*pi*dens))*sqrt(ms/B);  %Calculo de frecuencia de densidad
    %f11=((c^2/(4*fc))*((1/largo^2)+(1/alto^2))); %Calculo de modo 1,1
    R2 = zeros(1,31);
    R21 = zeros(1,31);
    R22 = zeros(1,31);

if filtr==1
       filtro = octava;
       for i=1:length(octava) 
           
           if octava(i)<(0.5*fc) 
               R2(i)= 10*log10(1+(((pi*ms*octava(i))/(ro*c))^2))-5.5;               
           end
           
           if octava(i)>=fc
               ntotal=(perd)+(ms/(485*sqrt(octava(i)))); %Calculo de ntotal
               R21(i) = 10*log10(1+(((pi*ms*octava(i))/(ro*c))^2))+10*log10((2*ntotal*octava(i))/(pi*fc));
               R22(i) = (10*log10(1+((pi*ms*octava(i))/(ro*c))^2))-(5.5);
               R2(i)= min(R21(i),R22(i)); %Toma el minimo entre R21 y R22
           end
           
           if (0.5*fc)<=octava(i) && octava(i)<fc   
               ntotal=(perd)+(ms/(485*sqrt(octava(i)))); %Calculo de ntotal
               Rx = 10*log10(1+((pi*ms*octava(i))/(ro*c))^2) + 10*log10((2*ntotal*octava(i))/(pi*fc));
               Ry = 10*log10(1+((pi*ms*octava(i))/(ro*c))^2) - 5.5;
               R2(i)=(((octava(i)-0.5*fc)/(fc-0.5*fc))*(Rx-Ry))+Ry; %Interpolación lineal           
           end
           
       end
end


if filtr==2
        filtro = tercio;
        for i=1:length(tercio)
            
           if tercio(i)<(0.5*fc) 
               R2(i)= 10*log10(1+(((pi*ms*tercio(i))/(ro*c))^2))-5.5;              
           end
           
           if tercio(i)>=fc
               ntotal=(perd)+(ms/(485*sqrt(tercio(i)))); %Calculo de ntotal
               R21(i) = 10*log10(1+(((pi*ms*tercio(i))/(ro*c))^2))+10*log10((2*ntotal*tercio(i))/(pi*fc));
               R22(i) = (10*log10(1+((pi*ms*tercio(i))/(ro*c))^2))-(5.5);
               R2(i)= min(R21(i),R22(i)); %Toma el minimo entre R21 y R22
           end
           
           if (0.5*fc)<=tercio(i) && tercio(i)<fc   
               ntotal=(perd)+(ms/(485*sqrt(tercio(i)))); %Calculo de ntotal
               Rx=10*log10(1+((pi*ms*tercio(i))/(ro*c))^2) + 10*log10((2*ntotal*tercio(i))/(pi*fc));
               Ry=10*log10(1+((pi*ms*tercio(i))/(ro*c))^2) - 5;5;
               R2(i)=(((tercio(i)-0.5*fc)/(fc-0.5*fc))*(Rx-Ry))+Ry; %Interpolación lineal           
           end
            

            
        end
        
end
rSHARP=R2;
%rSHARP

end

% Shear

function [out] = shear(frequency, density, Young, Poisson, thickness)

omega = 2 * pi * frequency;
chi = (1 + Poisson) / (0.87 + 1.12 * Poisson);
chi = chi * chi;
X = thickness * thickness / 12;
QP = Young / (1 - Poisson * Poisson);
C = -omega * omega;
B = C * (1 + 2 * chi / (1 - Poisson)) * X;
A = X * QP / density;
kbcor2 = (-B + sqrt(B * B - 4 * A * C)) / (2 * A);
kb2 = sqrt(-C / A);

G = Young / (2 * (1 + Poisson));
kT2 = -C * density * chi / G;
kL2 = -C * density / QP;
kS2 = kT2 + kL2;
ASI = 1 + X * (kbcor2 * kT2 / kL2 - kT2);
ASI = ASI * ASI;
BSI = 1 - X * kT2 + kbcor2 * kS2 / (kb2 * kb2);
CSI = sqrt(1 - X * kT2 + kS2 * kS2 / (4 * kb2 * kb2));
out = ASI / (BSI * CSI);
end

% Single Leaf Davy

function [single_leaf] = Single_leaf_Davy(frequency, density, Young, Poisson, thickness,lossfactor, length, width)

po = 1.18 ; %Densidad del aire [Kg/m3]
c0 = 343 ; %Velocidad sonido [m/s]
cos21Max = 0.9; %Ángulo limite definido en el trabajo de Davy
surface_density = density * thickness;
critical_frequency = sqrt(12 * density * (1 - Poisson ^ 2) / Young) * c0 ^ 2 / (2 * thickness * pi);
normal = po * c0 / (pi * frequency * surface_density);
normal2 = normal * normal;
e = 2 * length * width / (length + width);
cos2l = c0 / (2 * pi * frequency * e);

if cos2l > cos21Max
    cos2l = cos21Max;
end

tau1 = normal2 * log((normal2 + 1) / (normal2 + cos2l)); %Con logaritmo en base e (ln)
ratio = frequency / critical_frequency;
r = 1 - 1 / ratio;

if r < 0
    r = 0;
end

G = sqrt(r);
rad = Sigma(G, frequency, length, width);
rad2 = rad * rad;
netatotal = lossfactor + rad * normal;
z = 2 / netatotal;
y = atan(z) - atan(z * (1 - ratio));
tau2 = normal2 * rad2 * y / (netatotal * 2 * ratio);
tau2 = tau2 * shear(frequency, density, Young, Poisson, thickness);

if frequency < critical_frequency
    tau = tau1 + tau2;
    
else
    tau = tau2;
end

single_leaf = -10 * log10(tau);
end

% Sigma

function [rad] = Sigma(G, freq, width, length)

c0 = 343 ; %Velocidad sonido [m/s]
w = 1.3;
beta = 0.234;
n = 2;

S = length * width;
U = 2 * (length + width);
twoa = 4 * S / U;
k = 2 * pi * freq / c0;
f = w * sqrt(pi / (k * twoa));

if f > 1
    f = 1;
end

h = 1 / (sqrt(k * twoa / pi) * 2 / 3 - beta);
q = 2 * pi / (k * k * S);
qn = q ^ n;

if G < f
    alpha = h / f - 1;
    xn = (h - alpha * G) ^ n;
else

    xn = G ^ n;
end

rad = (xn + qn)^(-1 / n);
end



end