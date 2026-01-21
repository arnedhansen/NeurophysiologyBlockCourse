%% Vorbereitung

% Dieser code bewirkt, dass Matlab immer in den richtigen Ordner springt
editorFile = matlab.desktop.editor.getActiveFilename;
cd(fileparts(editorFile))

restoredefaultpath

% Alle Variablen die evtl., noch im Workspace bestehen löschen
clear
% Das "Command Window" leeren
clc


%% Check: Signal processing / Bioinformatics toolbox installiert?

which hilbert 
which gethmmalignment

%Oder voller Überblick, inklusiver Version
ver 
%% Pfade setzen

% Pfad zu den Daten
pathToData='data/preprocessed_data' 

% Pfad zu EEGlab
addpath('eeglab2021.1')
%Danach wird matlab eeglab öffnen können, jedoch noch nicht alle Funktionen
%wie Filter etc verwenden können.

% EEGlab öffnen und schliessen (damit werden alle wichtigen Funktionen zum
% Pfad hinzugefügt)
eeglab;
close;

%% EEG daten laden
load( [pathToData  '/gip_sub-002.mat'] );

% Mit EEG Datenstrukutr vertraut machen

% eeglab Funktion um die Positionen der Elektroden zu visualisieren
pop_chanedit(EEG)

%% Zeitverlauf der EEGd-Daten visualisieren


%Erstens : EEGLab Fuktion verwenden um gesamtes Signal zu betrachten
% -----------------------------------------------------------------------
eegplot(EEG.data)


%Zweitens: Einzelne Kanäle visualisieren (ohne EEGLab)
% -----------------------------------------------------------------------

% -------------
% Zuerst: Wiederholung Indizierung am Beispiel der EEG Daten
size(EEG.data) % Matrix mit zwei Dimensionen 

%Aufgabe: Auf Datenpunkt 100 von Kanal 30 zugreifen:
EEG.data(30,100)
% -------------


% Jetzt:  die ersten 500 Datenpunkte von Kanal 1 und Kanal 50 plotten
nChannelA = 1;
nChannelB = 50;

minPnt = 1;
maxPnt = 500; %Wieviel Zeit vergeht von minPoint zu MaxPoint?

%Die folgene Abbildung soll zuerst das EEG Signal von channelA, von
%minPnt bis maxPnt plotten, und danach noch das EEG Signal von 
% Auf der x-Achse soll die Zeit in ms aufgetragen werden, auf der y-Achse
% die Ausprägung des EEG Signals

%leere Abbildung öffnen:
figure;
%Daten von channelA plotten:
plot(EEG.times( minPnt:maxPnt ) , EEG.data( nChannelA , minPnt:maxPnt ),'color','r')
hold on % erlaubt das plotten mehrerer Signale in einer Abbildung
%Daten von channelB plotten:
plot(EEG.times( minPnt:maxPnt ),EEG.data( nChannelB , minPnt:maxPnt),'color','y')
legend('Kanal A','Kanal B')

%Titel & Achsenbeschriftungen hinzufügen:
title(['Timecourse of two EEG channels']);
xlabel('time [ms]')
ylabel('signal [uV]')




% Dieser Befehl schliesst alle Figuren die geöffnet waren
close all

%% Topographien plotten & Rerefernzierung

% Wir wählen einen arbiträren Datenpunkt (500).
% Nach wievielen ms wurde dieser Datenpunkt aufgenommen? 

% (Datenpunkt 1 korrespondiert zu Millisekunde 0, und wir haben eine
% Abtastrate von 250 samples/sek)

timePnt = 500;

% Wir wollen die funktion "topoplot" benutzen, also sehen wir uns an wie
% diese verwendet werden soll:
help topoplot

% Zwei Elektroden zu denen wir rereferenzieren werden
chlLeftEar = 13;
chlRightForehead = 8;

%Abbildung öffnen:
figure; % wir werden subplots verwenden - siehe whiteboard!

% Erster Plot, Daten mit bestehender Referenz plotten
subplot(2,2,1)
topoplot(EEG.data(:,timePnt),EEG.chanlocs)
colorbar;
title('Data referenced to Nose')


% Zweiter Plot, Daten zu Elektrode bei linkem Ohr rereferenzieren
leftEarData=reref(EEG.data,chlLeftEar);

subplot(2,2,2)
topoplot(leftEarData(:,timePnt),EEG.chanlocs)
colorbar
title('Data rereferenced near left ear')



% Dritter Plot, Daten zu Elektrode bei Stirn rereferenzieren
rightForeheadRefData = reref(EEG.data,chlRightForehead);

subplot(2,2,3)
topoplot(rightForeheadRefData(:, timePnt), EEG.chanlocs);
colorbar
title('Data rereferenced to right forehead')

% Vierter Plot, Daten zu Mittelwertsreferenz rereferenzieren
averageRefData=reref(EEG.data);

subplot(2,2,4)
topoplot(averageRefData(:,timePnt),EEG.chanlocs)
colorbar
title('Data rereferenced to average')


%% Uebung: Titel der Plots verbessern, sodass sie beim 3. und 4. plot auch 
% die Nummer der Elektrode ausgeben die in der variable chlLeftEar bzw 
% chlRightForehead anzeigen, also zum Beispiel:
% "Data rereferenced near left ear, electrode number: 13"
% "Hardcoding" ist nicht erlaubt :)