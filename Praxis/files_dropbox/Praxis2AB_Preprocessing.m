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
pathToData='data/raw_data'; 

% Pfad zu EEGlab
addpath('eeglab2021.1')
%Danach wird matlab eeglab öffnen können, jedoch noch nicht alle Funktionen
%wie Filter etc verwenden können.

% EEGlab öffnen und schliessen (damit werden alle wichtigen Funktionen zum
% Pfad hinzugefügt)
eeglab;
close;

% Ausserdem: Vollen Pfad der "Clean_Rawdata" toolbox hinzufügen.
CRDpath='eeglab2021.1/plugins/clean_rawdata2.6';
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

% Events?: 
% Springe zu Seite 20

% Artefakt genauer betrachten:
%Erste Sekunde von Kanal 10 von Hand  Plotten:
%TODO: Korrekte werte für minPnt und MaxPnt einsetzen

channel=10;
minPnt= 1 ; %first sample
maxPnt= 251 ; %sample at 1000 ms

figure;
subplot(2,1,1)
plot(EEG.data(channel,minPnt:maxPnt));
xlabel('Sample');
%TODO: Verbessere lesbarkeit in zweitem Plot indem die korrekte Zeit auf 
% die X-achse geplotted wird
subplot(2,1,2)
plot( EEG.times(minPnt:maxPnt) ,EEG.data(channel,minPnt:maxPnt));
xlabel('Time (ms)');



%Topographie betrachten:
plotSample=1000;

figure;
topoplot(EEG.data(:,plotSample),EEG.chanlocs,'electrodes','on');
title('Raw data');colorbar;
% Bei sauberen EEG Daten sollten Positive udn negative Werte in etwa im
% Gleichgewicht sein (Alle generatoren haben + und - pol)

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
% Schauen wir das Ergebnis an - Dimensionen der Daten sind nun 57 X 30001 
% So viel wollten wir garnicht, wir wollen erstmal nur wissen welches die
% verrauschten Elektroden sind

% ... diese Information ist etwas versteckt
CRD_goodChannels = EEG_CRD.etc.clean_channel_mask;
badChannels = find(not(CRD_goodChannels)); %find() funktion ist sehr wichtig!

%TODO: "eeg_interp" Funktion benutzen!
% Interpoliere Verrauschte ELektroden, benutze die 'spherical' Methode
EEG = eeg_interp(EEG, badChannels, 'spherical');

%Jetzt können wir Daten rereferenzierem - 
% -- Warum wäre das vor diesem Schritt eine schelchte Idee gewesen?

%Mittelwertsrefernz anwenden
EEG.data=reref(EEG.data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Filtern

%Original EEG daten abspeichern für später
EEG_orig=EEG;

% High-pass Filter (1 Hz):
%TODO: EEG Daten mit der Funktion "pop_eegfiltnew" filtern
EEG = pop_eegfiltnew(EEG, 1, []);


% Signal vor und nach Filter plotten:
selectChan=10;
minPnt=901;maxPnt=1100; %Wir wählen Datenpunkte aus die im Bereich des Topoplots (der noch offen sein sollte) liegen

figure;
plot(EEG_orig.times(minPnt:maxPnt), EEG_orig.data(selectChan,minPnt:maxPnt));
hold on;
plot(EEG.times(minPnt:maxPnt), EEG.data(selectChan,minPnt:maxPnt));
legend({'raw', 'highpass filtered'});

% plot topograpy of of same timpoint again
figure;
topoplot(EEG.data(:,plotSample),EEG.chanlocs,'electrodes','on');colorbar;
title('Highpass Filtered data');


% Low-pass Filter (40 Hz) auf die "EEG" Daten
%TODO: Verwende "pop_eegfiltnew"

EEGfilt = pop_eegfiltnew(EEG,[] ,40 );

%Selber Plot nochmal, alle Versionen vergleichen:
figure;
plot(EEG_orig.times(minPnt:maxPnt), EEG_orig.data(selectChan,minPnt:maxPnt));
hold on;
plot(EEG.times(minPnt:maxPnt), EEG.data(selectChan,minPnt:maxPnt));
plot(EEGfilt.times(minPnt:maxPnt), EEGfilt.data(selectChan,minPnt:maxPnt),'k');


legend({'raw', 'highpass filtered', 'Low and high pass'});

%TODO: die neu tief(&hoch)-pass gefilterten daten hinzufügen (idealerweise in schwarz)
%TODO:  Legende ergänzen
%Hinweis: wir müssen "hold on" nur einmal aktivieren um auch mehrere linien
%zum selben plot hinzuzufügen

%Von jetzt an nur noch die hoch-& tief-pass gefiltereren Daten verwenden
%EEG=EEGfilt;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% ICA

% ICA durchführen:
% Um es zu beschleunigen erlauben wir nur 100 Schritte / Iterationen
EEG=pop_runica(EEG,'maxsteps',100);


% EEG Struktur öffnen, enthält nun neue Felder: 
% EEG.icawinv, EEG.icaact, ...


% ICA Ergebnisse visualisieren
%TODO, Komponenten 1 bis 30 visualisieren lassen, mittels "pop_selectcomps"
pop_selectcomps(EEG,1:30)


% Zeitverlauf der ICA komponenten wird je nach softwareversion gelöscht,
% wir können sie wiederherstellen:
EEG.icaact = (EEG.icaweights*EEG.icasphere) * EEG.data;

%Zeitverlauf visualisieren  (Komponenten 1,2 und 3, jeweils die ersten 5000 Datenpunkte)

figure;
%subplots sollen 3 zeilen und 1 spalte haben
subplot(4,1,1)
plot(EEG.icaact(1,1:5000))
subplot(4,1,2)
plot(EEG.icaact(2,1:5000))
subplot(4,1,3)
plot(EEG.icaact(3,1:5000))
subplot(4,1,4)
plot(EEG.icaact(4,1:5000))

%Von hand die Koponenten rausnehmen die wir von Auge identifiziert haben:
badComps_manual=[1,3,4];

%TODO: funktion "pop_subcomp" korrekt verwenden
EEG_ica_V1 =pop_subcomp(EEG,badComps_manual);

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
addpath(genpath(['eeglab2021.1' filesep 'plugins/ICLabel']))

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