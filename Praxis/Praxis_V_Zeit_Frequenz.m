%% Umsetzung und Auswertung von neurophysiologischen Experimenten FS25
%
% Praxis V
% Frequenz-Analysen und Zeit-Frequenz-Analysen

%% SETUP
% Dieser code bewirkt, dass MATLAB immer in den richtigen Ordner springt
editorFile = matlab.desktop.editor.getActiveFilename;
cd(fileparts(editorFile))
restoredefaultpath

% Alle Variablen löschen, die noch im Workspace vorhanden sind
clear

% Das Command Window leeren
clc

%% Pfade vorbereiten

% Pfad zu den Daten
pathToData = 'data/preprocessed_data'; 

% Pfad zu EEGlab
addpath('eeglab2021.1')
% Danach wird MATLAB EEGLab öffnen können, jedoch noch nicht alle Funktionen
% wie Filter etc verwenden können.

% EEGLab öffnen und schliessen (damit werden alle wichtigen Funktionen für 
% und zum Pfad hinzugefügt)
eeglab
close;

%% Lade alle Daten für Subject 002
pathToData = 'data/preprocessed_data';
load([pathToData  '/gip_sub-002.mat']);

%% Fourier Transformation

% Erstmal machen wir das von Hand, etwas mühsam:
channel = 60; % Wir schauen uns das Ganze erstmal für eine Elektrode an
fft_res = abs(fft(EEG.data(channel,1:1000))); 
fft_res = fft_res(1:length(fft_res)/2);
% Wir wählen abs(fft) für die Amplitude
% FFT liefert auch Phaseninformation - diese interessiert uns aber meist nicht

figure;
plot(fft_res)
% Schwierig zu erkennen, welche Frequenzen hier am stärksten ausgeprägt sind

% Mit Vorkenntnissen aus dem Blockkurs können wir berechnen, um welche 
% Frequenzen es sich handelt:

% Wir haben eine Abtastrate von 250 Hz
% Länge Segment = 4 s
% Kleinste schätzbare Frequenz = ??? Hz %%%%% 0.25 (1/T [s])
% Frequenzauflösung = ??? Hz %%%%% 0.25 (1/T [s])
% Grösste schätzbare Frequenz = ??? Hz %%%%% 125 (Abtastrate/2)

frequenzen = XXX:XXX:XXX; %%%%% 0.25:0.25:125
figure;
plot(frequenzen,fft_res); %%%%% xline(125)

%% EEGLab kann das auch, besser, und gleichzeitg für alle Kanäle!

% Was möchte die Funktion von uns haben?
help spectopo

% Sind unsere EEG-Daten im 2D-Format (nchans, time_points)?
size(EEG.data)

% Frequenzanalyse mit spectopo
[spec,freq] = spectopo(EEG.data(channel,1:1000), 0, EEG.srate);
% Nur für eine Elektrode (60)
% Alle Zeitpunkte
% Abtastrate = 250 Hz

% Trick wurde angewandt! Welch-Spektrum
% Daten wurden in 4 Segmente von 1 Sekunde unterteilt, FFT über diese 
% 4 Segmente gemacht und gemittelt - deswegen schöneres, glatteres Resultat,
% (wegen Mittelwert), aber schlechtere Frequenzauflösung (1 / T[s])

% FT gleichzeitig für alle Kanäle, über die gesamten Daten (frames = 0)
figure;
[spec,freq] = spectopo(EEG.data, 0, EEG.srate); 
% spec = durchschnittliche Power über Epochen
% freq = Frequenzen, die in Spektra gezeigt werden können

% Dimensionen von spec jetzt 70*126
size(spec)
% Was ist passiert? %%%%% Verlust der Zeitinformation
% 126 Frequency bins
% Freq 0 = Mittelwert des Signals über die Zeit (Baseline)

% Visualisierung für Elektrode 60 für alle Frequenzen
figure;
plot(freq,spec(60,:))

%% Zeit-Frequenz-Analyse
% Erstmal: von Hand STFT selber machen 

% Segmente von 1 Sekunde
winSize250 = 250; % 250 Zeitpunkte, die 4 ms auseinander liegen = 1 Sekunde
% Berechnung Frequenzauflösung: 1/T [s]

% STFT von Hand für die ersten 20 Sekunden
for i = 1:20
    start = (i-1)*winSize250+1;
    stop = i*winSize250;
    [spec_tf(:,i),freq_tf(i,:)] = spectopo(EEG.data(channel,start:stop), 0, EEG.srate,'plot','off','winsize', winSize250);
end

% Ergebnis ansehen (diesmal nur von 2-30 Hz):
freq1 = find(freq_tf(1,:) == 2) % Frequenz mit 2 Hz
freq2 = find(freq_tf(1,:) == 30) % Frequenz mit 30 Hz

% Visualisierung Zeit-Frequenz-Analyse für die ersten 20 Sekunden
figure;
imagesc(spec_tf(freq1:freq2,:), [-30 30]);
colormap('turbo')
colorbar;
xlabel('Zeit [s]')
ylabel('Frequenzen [Hz]')
title('TFR: Segmente von 1 Sekunde')
set(gca,'YDir','normal')
set(gca, 'FontSize', 25)

%%  Vergleich
% Wieder die ersten 20 Sekunden
% ABER: Segmente von 2 Sekunden

% Segmente von 2 Sekunden
winSize500 = 500; % 500 Zeitpunkte, die 4 ms auseinander liegen = 2 Sekunden
% Berechnung Frequenzauflösung: 1/T [s]

% STFT von Hand für die ersten 20 Sekunden
for i = 1:10
    start = (i-1)*winSize500+1;
    stop = i*winSize500;
    [spec_tf2(:,i),freq_tf2(i,:)] = spectopo(EEG.data(channel,start:stop), 0, EEG.srate,'plot','off','winsize', winSize500);
end

% Ergebnis ansehen:
freq1B = find(freq_tf2(1,:) == 2)
freq2B = find(freq_tf2(1,:) == 30)
plotFreqB = freq_tf2(1,freq1B:freq2B); % Frequenzachse (y-Achse) von 2 bis 30 Hz

% ABER: Wie viele Frequenz-Bins?
size(plotFreqB, 2)
% Berechnung Frequenzauflösung: 1/T [s]
% 57 Frequenz-Bins, weil plotFreqB von 2 bis 30 Hz geht in Schritten von 0.5 Hz
zeitB = 1:2:20; % Zeitachse von 1 bis 20 Sekunden (2 Sek-Schritte!)

% Plotten (mit korrigierter x- und y-Achse)
figure;
imagesc(zeitB, plotFreqB, spec_tf2(freq1B:freq2B,:), [-30 30]);
colorbar;
colormap('turbo')
colorbar;
xlabel('Zeit [s]')
ylabel('Frequenzen [Hz]')
title('TFR: Segmente von 2 Sekunden')
set(gca,'YDir','normal')
set(gca, 'FontSize', 25)

% Mit längeren Segmenten:
%   Frequenzauflösung ist besser geworden!
%   ABER Zeitauflösung schlechter!
%   Und: Für alle Frequenzen, die wir geschätzt haben ist die 
%   Auflösung genau dieselbe!

%% Man kann Zeit-Frequenz-Analysen von Hand programmieren, einfacher geht 
%  es aber auch hier mit vorprogammierten Funktionen aus EEGLab. 

%% Neue Fragestellung:
%  Wie verändert sich das Frequenzspektrum nach Präsentation eines Stimulus?

% Zuerst: Daten segmentieren!
EEGC_all = pop_epoch(EEG, {4,5,6,13,14,15,17,18,19}, [-0.4, 2.6]); 

% Anzahl an Zyklen für Wavelet-Analyse
nCycles = 0; % 0 heisst: keine Zyklen -> stattdessen STFT

% Was möchte die Funktion von uns haben?
doc pop_newtimef

% Visualisierung der STFT
figure;
[ersp,~,~,times,freqs] = pop_newtimef(EEGC_all, 1, channel, [-400, 2600], nCycles, 'freqs', [3 30],'plotphasesign','off','plotitc','off');
% Inputs
% EEGC_all               : EEG-Datensatz
% 1                      : Analyse der ersten Epoche
% channel                : Elektrode 60
% [-400, 2600]           : Analyse-Zeitfenster (ms); 400 ms vor Stimulus bis 2600 ms nach Stimulus
% nCycles                : Parameter, der die Anzahl der Zyklen für die Wavelet-Transformation bestimmt, was das Gleichgewicht zwischen Zeit- und Frequenzauflösung beeinflusst.
% 'freqs', [3 30]        : Parameterpaar, das den interessierenden Frequenzbereich von 3 Hz bis 30 Hz festlegt.
% 'plotphasesign','off'  : Option, um die Darstellung der Phasensignaldaten zu deaktivieren.
% 'plotitc','off'        : Option, um die Darstellung der Inter-Trial-Kohärenz (ITC)-Daten zu deaktivieren.

% Outputs
% ersp  : Matrix, die die Event-Related Spectral Perturbation (ERSP)-Werte enthält, welche aus den EEG-Daten berechnet wurden.
% ~     : Platzhalter für eine Ausgabe (zum Beispiel ITC-Daten), die nicht gespeichert wird.
% ~     : Platzhalter für eine weitere Ausgabe (z. B. zusätzliche statistische oder Phasendaten), die nicht gespeichert wird.
% times : Vektor mit Zeitpunkten (in Millisekunden), die den berechneten ERSP-Daten entsprechen.
% freqs : Vektor mit den Frequenzbändern (in Hertz), die in der Zeit-Frequenz-Analyse verwendet werden.


% Plot nicht schliessen
% Wie ist Zeitauflösung, wie ist Frequenzauflösung?
% WAS SIND DIE BEIDEN INTEGRIERTEN PLOTS?

%% Vergleiche Ergebnis der EEGLab STFT mit Wavelet-Analyse 

nCycles = 5; % Wavelets mit 5 Zyklen
figure;
[erspWave,~,~,timesWave,freqsWave] = pop_newtimef(EEGC_all,1,channel,[-400, 2600],nCycles, 'freqs',[3 30],'plotphasesign','off','plotitc','off');
% Man sieht: 
% Zeit teilweise abgeschnitten (wavelets müssen ganz reinpassen - whiteboard/VISUALIESIERUNG) 
% Zeit insgesamt 3s
% 5 zyklen
% 0.33 (3Hz) langsamstse Wavelet
% erster Werte bei -400 + 750 = 350ms

% OBEN (hohe frequenzen), power wechselt schnell, gute Zeitauflösung, 
% aber die langen "Streifen" zeigen, dass man nicht wirklich
% unterscheiden kann zwischen den hohen Frequenzen (zb. 20/30).

% UNTEN (tiefe Frequenzen), Power wechselt langsam, schlechte 
% Zeitauflösung

%% Zum Schluss: Hilbert-Transformation

% Für dieses Beispiel nehmen wir die Alpha-Oszillation über die
% ersten 10 Sekunden

EEG_short = pop_select( EEG,'time',[0, 10] );

% zum alpha band filtern (8-13 Hz)

% TODO: Funktions-argumente ausfüllen)
EEG_short_filt = pop_eegfiltnew(EEG_short,8,13);

% Plot: Daten vor und nach filtern 
figure;
plot(EEG_short.times,EEG_short.data(channel,:));
hold on;
plot(EEG_short_filt.times,EEG_short_filt.data(channel,:));

%--------------
% Alpha power extrahieren mit Hilbert Transformation

alphapow = abs(hilbert(EEG_short_filt.data(channel,:)));
%--------------

% Ergebnis visualisieren:

figure;
plot(EEG_short_filt.times,EEG_short_filt.data(channel,:));
% TODO
hold on;
plot(EEG_short_filt.times,alphapow)
