%% Blockkurs Umsetzung und Auswertung neurophysiologischer Experimente
%  Praxis 1C: Data Inspection

%% Vorbereitung

% Dieser code bewirkt, dass Matlab immer in den richtigen Ordner springt
editorFile = matlab.desktop.editor.getActiveFilename;
cd(fileparts(editorFile))
restoredefaultpath

% Löschung aller Variablen die evtl. noch im Workspace bestehen
clear

% Das "Command Window" leeren
clc

%% Check: Signal processing / Bioinformatics toolbox installiert?

which hilbert 
which gethmmalignment

% Oder voller Überblick, inklusive Version
ver

%% Pfade setzen

% Pfad zu den Daten
pathToData = 'data/preprocessed_data' 

% Pfad zu EEGlab
addpath('eeglab2021.1')
% Danach wird MATLAB EEGLab öffnen können, jedoch noch nicht alle
% Funktionen (z.B. Filter) verwenden können

% EEGlab öffnen und schliessen
eeglab;
close;
% Damit werden alle wichtigen Funktionen zum Pfad hinzugefügt

%% EEG-Daten laden
load( [pathToData  '/gip_sub-002.mat'] );

% --> Mit EEG Datenstruktur vertraut machen

% EEGLab-Funktion um die Positionen der Elektroden zu visualisieren
pop_chanedit(EEG)

%% Zeitverlauf der EEG-Daten visualisieren

% Erstens : EEGLab Funktion verwenden um gesamtes Signal zu betrachten
% -----------------------------------------------------------------------
eegplot(EEG.data)

% Zweitens: Einzelne Kanäle visualisieren (ohne EEGLab)
% -----------------------------------------------------------------------

% -------------
% Zuerst: Wiederholung Indizierung am Beispiel der EEG Daten
size(EEG.data) % Matrix mit zwei Dimensionen 

% Aufgabe: Auf Datenpunkt 100 von Kanal 30 zugreifen:
EEG.data(30,100)
% -------------

% Jetzt:  die ersten 500 Datenpunkte von Kanal 1 und Kanal 50 plotten
nChannelA = 1;
nChannelB = 50;

minPnt = 1;
maxPnt = 500; % Wie viel Zeit vergeht von minPnt zu maxPnt?

% Die folgende Abbildung soll zuerst das EEG Signal von channelA, von
% minPnt bis maxPnt plotten, und danach noch das EEG Signal von 
% Auf der x-Achse soll die Zeit in ms aufgetragen werden, auf der y-Achse
% die Ausprägung des EEG Signals

% leere Abbildung öffnen:
figure;
% Daten von channelA plotten:
plot(EEG.times( minPnt:maxPnt ) , EEG.data( nChannelA , minPnt:maxPnt ),'color','r')
hold on % erlaubt das plotten mehrerer Signale in einer Abbildung
% Daten von channelB plotten:
plot(EEG.times( minPnt:maxPnt ),EEG.data( nChannelB , minPnt:maxPnt),'color','y')
legend('Kanal A','Kanal B')

% Titel & Achsenbeschriftungen hinzufügen:
title(['Timecourse of two EEG channels']);
xlabel('time [ms]')
ylabel('signal [uV]')

% Dieser Befehl schliesst alle Figuren die geöffnet waren
close all

%% Topographien plotten & Rereferenzierung

% Wir wählen einen arbiträren Datenpunkt (500).
% Nach wie vielen ms wurde dieser Datenpunkt aufgenommen? 

% (Datenpunkt 1 korrespondiert zu Millisekunde 0, und wir haben eine
% Abtastrate von 250 samples/sek)
timePnt = 500;

% Wir wollen die Funktion "topoplot" benutzen, also sehen wir uns an wie
% diese verwendet werden soll:
help topoplot

% Zwei Elektroden zu denen wir rereferenzieren werden
chlLeftEar = 13;
chlRightForehead = 8;

% Abbildung öffnen:
figure; % wir werden subplots verwenden - siehe whiteboard!

% Erster Plot, Daten mit bestehender Referenz plotten
subplot(2,2,1)
topoplot(EEG.data(:,timePnt),EEG.chanlocs)
colorbar;
title('Data referenced to Nose')


% Zweiter Plot, Daten zu Elektrode bei linkem Ohr rereferenzieren
leftEarData=reref(EEG.data,chlLeftEar);
% Reminder: Mittelwertsreferenz reref(EEG.data)

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


%% Übung: Titel der Plots verbessern, sodass sie beim 3. und 4. Plot auch 
% die Nummer der Elektrode ausgeben die in der Variable chlLeftEar bzw 
% chlRightForehead anzeigen, also zum Beispiel:
% "Data rereferenced near left ear, electrode number: 13"
% "Hardcoding" ist nicht erlaubt :)

%% FREIWILLIGE Hausaufgabe
%
% Die folgenden Aufgaben dienen dazu, die in dieser Praxis gelernten
% Konzepte eigenständig zu vertiefen. Viel Erfolg!

% -----------------------------------------------------------------------
% Aufgabe 1: Einen anderen Datensatz laden und inspizieren
% -----------------------------------------------------------------------
% a) Lade einen anderen Datensatz aus dem Ordner 'data/preprocessed_data'.
%    Tipp: Schau nach, welche Dateien dort verfügbar sind (z.B. mit "dir").
%
% b) Wie viele Kanäle und wie viele Datenpunkte hat dieser Datensatz?
%    Nutze die Funktion "size" auf EEG.data und EEG.chanlocs.
%
% c) Wie hoch ist die Abtastrate (Sampling Rate)? Schaue in EEG.srate.

% Dein Code hier:


% -----------------------------------------------------------------------
% Aufgabe 2: Zeitverlauf mehrerer Kanäle vergleichen
% -----------------------------------------------------------------------
% a) Wähle drei beliebige Kanäle aus und plotte deren Zeitverläufe
%    für die Datenpunkte 1 bis 1000 in einer einzigen Abbildung.
%    Verwende unterschiedliche Farben für jeden Kanal.
%
% b) Füge eine Legende hinzu, die die Kanalnamen anzeigt.
%    Tipp: Die Kanalnamen findest du in EEG.chanlocs(kanal).labels
%
% c) Beschrifte die Achsen sinnvoll (x-Achse: Zeit in ms, y-Achse: uV).

% Dein Code hier:


% -----------------------------------------------------------------------
% Aufgabe 3: Topographien zu verschiedenen Zeitpunkten
% -----------------------------------------------------------------------
% a) Erstelle eine Abbildung mit 4 Subplots (2x2), die jeweils eine
%    Topographie zu einem anderen Zeitpunkt zeigen:
%    - Datenpunkt 100
%    - Datenpunkt 500
%    - Datenpunkt 1000
%    - Datenpunkt 2000
%
% b) Jeder Subplot soll einen Titel haben, der den Zeitpunkt in
%    Millisekunden angibt (nicht den Datenpunkt!).
%    Tipp: Nutze EEG.times, um den Datenpunkt in ms umzurechnen.
%
% c) Verwende die Mittelwertsreferenz für alle vier Topographien.

% Dein Code hier:


% -----------------------------------------------------------------------
% Aufgabe 4: Einfluss der Rereferenzierung auf den Zeitverlauf
% -----------------------------------------------------------------------
% a) Wähle einen Kanal aus und plotte dessen Zeitverlauf (Datenpunkte
%    1 bis 500) in vier verschiedenen Referenzierungen:
%    - Original (Nasenreferenz)
%    - Linkes Ohr (Elektrode 13)
%    - Rechte Stirn (Elektrode 8)
%    - Mittelwertsreferenz
%
% b) Nutze subplots (4x1), damit die Signale gut vergleichbar sind.
%
% c) Was fällt dir auf? Welche Unterschiede siehst du zwischen den
%    verschiedenen Referenzierungen?

% Dein Code hier:

