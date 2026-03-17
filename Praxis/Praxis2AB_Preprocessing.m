%% Vorbereitung


% Dieser code bewirkt, dass Matlab immer in den richtigen Ordner springt
editorFile = matlab.desktop.editor.getActiveFilename;
cd(fileparts(editorFile))

restoredefaultpath

% Alle Variablen die evtl., noch im Workspace bestehen löschen
clear
% Das "Command Window" leeren
clc


%% Pfade vorbereiten

% Pfad zu den Daten, diesmal die Rohdaten!
pathToData='data/raw'; 

% Pfad zu EEGlab
addpath('eeglab2025.1')
%Danach wird matlab eeglab öffnen können, jedoch noch nicht alle Funktionen
%wie Filter etc verwenden können.

% EEGlab öffnen und schliessen (damit werden alle wichtigen Funktionen zum
% Pfad hinzugefügt)
eeglab;
close;

% Ausserdem: Vollen Pfad der "Clean_Rawdata" toolbox hinzufügen.
CRDpath='eeglab2025.1/plugins/clean_rawdata';
addpath(genpath(CRDpath));

%% Daten Laden

load( [pathToData  '/sub-002.mat'] ); %Checke Variable in Workspace: EEG

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Die ersten zwei Minuten der Daten ausschneiden (Um die nachfolgende Schritte schneller zu machen)
EEG = pop_select( EEG,'time',[1, 121] );


%% Visualisieren

% Plot der EEG daten mit Events/Markers/Triggers
eegplot(EEG.data,'events',EEG.event)
% Beim durchscrollen können wir Rauschen im Kanal 67 sehen
% Ausserdem treten grosse Artefakte auf
% Obwohl Daten "raw" heissen, muessen sie schon zumindest minimal
% vorverarbeitet sein, warum? Was wurde angewandt?

% Events?: 
% Springe zu Seite 20

% Artefakt genauer betrachten:
%Erste Sekunde von Kanal 10 von Hand  Plotten:
%TODO: Korrekte werte für minPnt und MaxPnt einsetzen

channel=10;
minPnt= 1; %first sample
maxPnt= 250; %sample at 1000 ms

figure;
subplot(2,1,1)
plot(EEG.data(channel,minPnt:maxPnt));
xlabel('Sample');
%TODO: Verbessere Lesbarkeit in zweitem Plot, indem die korrekte Zeit auf 
% die X-achse geplotted wird
subplot(2,1,2)
%...
plot(EEG.times(minPnt:maxPnt),EEG.data(channel,minPnt:maxPnt));
xlabel('Time');

%Topographie betrachten:
plotSample=180;

figure;
topoplot(EEG.data(:,plotSample),EEG.chanlocs,'electrodes','on');
title('Raw data');colorbar;


%Andere, zufällige Topographie betrachten (kein Augenartefakt):
plotSample=1000;

figure;
topoplot(EEG.data(:,plotSample),EEG.chanlocs,'electrodes','on');
title('Raw data');colorbar;
% Auffallend hier: Bei sauberen EEG Daten sollten positive und negative 
% Werte in etwa im Gleichgewicht sein (Alle generatoren haben + und - pol)

% Wir behalten also diese Abbildung also für später offen!


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Erkennung schlechter Elektroden & Interpolation

% ... wenn es hier Hilfskanäle gäbe (wie EMG / ECG) 
% müssten wir sie jetzt vorübergehend aus den Daten nehmen - warum?

params.FlatlineCriterion=5; %Sekunden
params.LineNoiseCriterion = 4; %Standardabweichungen
params.ChannelCriterion =0.8; %Korrelation

params.BurstCriterion = 'off';
params.WindowCriterion ='off';

% double check, haben wir die funktion korrekt zum Pfad hinzugefügt?
which clean_artifacts
EEG_CRD=clean_artifacts(EEG,params);
%Wichtig (immer): wir MUESSEN das Ergebnis in eine Variable abspeichern

% Schauen wir das Ergebnis an - Dimensionen der Daten sind nun 57 X 30001 
% So viel wollten wir garnicht, wir wollen erstmal nur wissen welches die
% verrauschten Elektroden sind

% ... diese Information ist etwas versteckt
CRD_goodChannels = EEG_CRD.etc.clean_channel_mask;
badChannels = find(not(CRD_goodChannels)); %find() funktion ist sehr wichtig!
%find([0 0 0 1 0 1])

%TODO: "eeg_interp" Funktion benutzen!
% Interpoliere Verrauschte Elektroden, benutze die 'spherical' Methode.
% Wir wollen keine bestimmte time range (t_range) setzen (d.h. wir lassen
% "t_range" weg)
help eeg_interp

EEG= eeg_interp(EEG,badChannels, 'spherical');
%Jetzt können wir Daten rereferenzierem - 
% -- Warum wäre das vor diesem Schritt eine schelchte Idee gewesen?

%Mittelwertsrefernz anwenden
EEG.data=reref(EEG.data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Filtern

%Original EEG daten abspeichern für später
EEG_orig=EEG;

% High-pass Filter (1 Hz):
EEG = pop_eegfiltnew(EEG, 1, []);

% Signal vor und nach Filter plotten:
selectChan=10;
minPnt=901;maxPnt=1100; %Wir wählen Datenpunkte aus die im Bereich des Topoplots (der noch offen sein sollte) liegen

figure;
plot(EEG_orig.times(minPnt:maxPnt), EEG_orig.data(selectChan,minPnt:maxPnt));
hold on;
plot(EEG.times(minPnt:maxPnt), EEG.data(selectChan,minPnt:maxPnt));
legend({'raw', 'highpass filtered'});

% plot topograpy of of same timepoint again
figure;
topoplot(EEG.data(:,plotSample),EEG.chanlocs,'electrodes','on');colorbar;
title('Highpass Filtered data');


% Low-pass Filter (40 Hz) auf die "EEG" Daten
%TODO: Verwende "pop_eegfiltnew", speichere das ergebnis in "EEG_filt"
EEG_filt=pop_eegfiltnew(EEG,[],40);

%Selber Plot nochmal, alle Versionen vergleichen:
figure;
plot(EEG_orig.times(minPnt:maxPnt), EEG_orig.data(selectChan,minPnt:maxPnt));
hold on;
plot(EEG.times(minPnt:maxPnt), EEG.data(selectChan,minPnt:maxPnt));
plot(EEG_filt.times(minPnt:maxPnt),EEG_filt.data(selectChan,minPnt:maxPnt),'color','black');
legend({'raw', 'highpass filtered',' high and lowpass filtered'});
%TODO: die neu tief-pass gefilterten daten hinzufügen (idealerweise in schwarz)
%TODO:  Legende ergänzen
%Hinweis: wir müssen "hold on" nur einmal aktivieren um auch mehrere Linien
%zum selben Plot hinzuzufügen

%Von jetzt an nur noch die hoch-& tief-pass gefiltereren Daten verwenden
EEG=EEG_filt;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% ICA

% ICA durchführen:
% Um es zu beschleunigen erlauben wir nur 100 Schritte / Iterationen
EEG=pop_runica(EEG,'maxsteps',100);

% EEG Struktur öffnen, enthält nun neue Felder: 
% EEG.icawinv, EEG.icaact, ...

% Dimension winv = 70*56
%Was bedeuten diese dimensionen? Erinnerung, ICA kann nur so viele
%komponenten finden wie es "Mikrophone" gab.
%(Siehe Folien zu winv)

%Tipp:
rank(EEG.data)
% Rang einer Matrix = Anzahl linear unabhängiger Zeilen.
% Warum gibt es 56 unabhängige komponenten bei 70 Elektroden?

% ICA Ergebnisse visualisieren
% TODO, Komponenten 1 bis 30 visualisieren lassen, mittels "pop_selectcomps"
help pop_selectcomps
pop_selectcomps(EEG,[1:30])

% Zeitverlauf der ICA komponenten wird je nach softwareversion gelöscht,
% wir können sie wiederherstellen:
EEG.icaact = (EEG.icaweights*EEG.icasphere) * EEG.data;


%Zeitverlauf visualisieren  (Komponenten 1,2 und 3, jeweils die ersten 5000 Datenpunkte)

figure;
%subplots sollen 3 zeilen und 1 spalte haben
subplot(4,1,1) % x  TODO durch korrekte zahlen ersetzen
plot(EEG.icaact(1,1:5000))
%TODO: In den weiteren zwei zeilen, jeweils aktivierung der 2. und der 3.
%komponente plotten.
subplot(4,1,2) % x  TODO durch korrekte zahlen ersetzen
plot(EEG.icaact(2,1:5000))
subplot(4,1,3) % x  TODO durch korrekte zahlen ersetzen
plot(EEG.icaact(3,1:5000))
subplot(4,1,4) % x  TODO durch korrekte zahlen ersetzen
plot(EEG.icaact(4,1:5000))

%Von hand die Koponenten rausnehmen die wir von Auge identifiziert haben:
badComps_manual=[1,3,4];

%TODO: funktion "pop_subcomp" korrekt verwenden
help pop_subcomp
EEG_ica_V1=pop_subcomp(EEG,badComps_manual);

%Signal vor und nach dem entfernen der Komponenten betrachten
FrontalElec=2;
minPnt=2000; maxPnt=5000;

figure;
plot(EEG.data(FrontalElec,minPnt:maxPnt),'b');ylim([-60 110]); 
hold on;
plot(EEG_ica_V1.data(FrontalElec,minPnt:maxPnt),'r');ylim([-60 110]);
legend('Before ICA', 'After ICA')


%% Anstatt das alles von Hand zu machen - ICLabel verwenden!

%gesamtes IClabel paket zum pfad hinzufügen, sodass wir alle Funktionen
%verwenden können:
addpath(genpath(['eeglab2025.1' filesep 'plugins/ICLabel']))

%IClabel klassifizieren lassen:
EEG_ICL = iclabel(EEG); 


% Ergebnis als visualisierung:
pop_viewprops(EEG_ICL,0,[1:30]);

% Diese info steckt auch in der EEG_ICL struktur
% - EEG_ICL.etc.ic_classification.ICLabel.classes
% - EEG_ICL.etc.ic_classification.ICLabel.classifications.
% Mal erste beide zeilen ansehen


%Wir wollen nur die Komponenten behalten die mit hoher Wahrscheinlichkeit artefakte sind (80%):
markBad=EEG_ICL.etc.ic_classification.ICLabel.classifications(:,2:6)>0.8;
badComps_ICL=find(any(markBad,2)); %look at any() function

EEG_ica_V2=pop_subcomp(EEG,badComps_ICL);


% Visualisieren der finalen, gesäuberten Daten:
eegplot(EEG_orig.data ,'data2', EEG_ica_V2.data)



% Classifier kann nur wenige Artefakte sicher identifizieren..
% Um gute ICA Lösung zu erhalten brauchen wir bestimmte Anzahl an
% Datenpunkten (20* Anzahl Kanäle^2)

minDatalengthICA=20*EEG.nbchan^2;
length(EEG.data)

%% Freiwillige Hausaufgabe: 


%Im Code oberhalb haben wir diese Code-Zeile benutzt um zu sehen, welche
% der Komponenten (Zeilen in markBad) als eine von 5 Artefakt Kategorien
% (Spalten in markBad) 
badComps_ICL=find(any(markBad,2));

%schauen wir uns nochmals die Dimensionen an:
size(markBad)

%und einen Blick auf die gesamte Matrix
markBad

%Was hat die any() Funktion für uns gemacht?
%Was hat die find() Funktion für uns gemacht?
% Probiere es nacheinander aus und beschreibe was du siehst.