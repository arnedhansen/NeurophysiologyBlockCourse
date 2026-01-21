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
load([pathToData  '/gip_sub-002.mat']);

%% Fourier Transformation

% Erstmal machen wir das von Hand, etwas mühsam:
channel = 60; % Wir schauen uns das Ganze erstmal für eine Elektrode an
fft_res = abs(fft(EEG.data(channel,1:1000))); % 1000 Zeitpunkte = 4 Sekunden
fft_res = fft_res(1:length(fft_res)/2); %%%%%
% Wir wählen abs(fft) für die Amplitude
% FFT liefert auch Phaseninformation - diese interessiert uns aber meist nicht

figure;
plot(fft_res)
% Schwierig zu erkennen, welche Frequenzen hier am stärksten ausgeprägt sind

% Mit Vorkenntnissen aus dem Blockkurs können wir berechnen, um welche
% Frequenzen es sich handelt:

% Wir haben eine Abtastrate von 250 Hz und 4 Sekunden Daten
% Kleinste schätzbare Frequenz = 0.25 Hz %%%%%
% Frequenzauflösung = 0.25 Hz %%%%%
% Grösste schätzbare Frequenz = 125 Hz %%%%%

frequenzen = 0.25:0.25:125; %%%%%
figure;
plot(frequenzen,fft_res);
xline(125)
% Warum gehen die Amplituden bei 40 Hz auf 0?

%% EEGLab kann das auch, einfach, und gleichzeitg für alle Kanäle!

% Was möchte die Funktion von uns haben?
clc
help spectopo

% Sind unsere EEG-Daten im 2D-Format (nchans, time_points)?
size(EEG.data)

% Frequenzanalyse mit spectopo
[spec,freq] = spectopo(EEG.data(channel, 1:1000), 0, EEG.srate);
% Nur für eine Elektrode (60)
% Alle Zeitpunkte der übergebenen Daten
% Abtastrate = 250 Hz
% Unterschiedliche Darstellung:
%   Log-Skalierung %%%%%%
%   Andere Frequenzauflösung! Siehe freq
length(frequenzen) % Frequenzen von 0.25 Hz bis 125 Hz in Schritten von 0.25 Hz
length(freq)

% Warum sieht das sauberer aus? Trick wurde angewandt! Welch-Spektrum
% Daten wurden in 4 Segmente von 1 Sekunde unterteilt, FFT über diese
% 4 Segmente gemacht und gemittelt - deswegen schöneres, glatteres Resultat,
% (wegen Mittelwert), aber schlechtere Frequenzauflösung (1 / T[s])

% FT gleichzeitig für alle Kanäle, über die gesamten Daten (frames = 0)
figure;
[spec,freq] = spectopo(EEG.data, 0, EEG.srate);
% spec = durchschnittliche Power über Epochen
% freq = Frequenzen, die in Spektra gezeigt werden können

% Dimensionen von freq immer noch gleich! Gleiche Frequenzen
% Dimensionen von spec jetzt 70*126
size(EEG.data) % 70 x 747750
size(spec)     % 70 x 126
% Was ist passiert? %%%%%
% 126 Frequency bins
% Freq 0 = Mittelwert des Signals über die Zeit (Baseline)

% Visualisierung für Elektrode 60 für alle Frequenzen
figure;
plot(freq,spec(60,:))

%% Zeit-Frequenz-Analyse
%  Problem der Frequenz-Analyse: Verlust der Zeitinformation

% Erstmal: von Hand STFT selber machen
% Segmente von 1 Sekunde
winSize1s = 250; % 250 Zeitpunkte, die 4 ms auseinander liegen = 1 Sekunde
% Berechnung Frequenzauflösung: 1/T [s]

% STFT von Hand für die ersten 20 Sekunden
clc
for i = 1:20
    start = i * winSize1s;     % Wir starten bei Sekunde 1, nicht bei 0 -> 250 Zeitpunkte * 4ms
    stop  = start + winSize1s; % Wir enden 1 Window Size später (1s)
    [spec_tf(:,i),freq_tf] = spectopo(EEG.data(channel,start:stop), 0, EEG.srate,'plot','off','winsize', winSize1s);
    disp(['Fenster Nr. ' num2str(i) ' = Zeitpunkt ' num2str(start), ' bis Zeitpunkt ', num2str(stop)])
end

% Ergebnis ansehen (diesmal nur von 2-30 Hz):
freq1 = find(freq_tf == 2) % Frequenz mit 2 Hz
freq2 = find(freq_tf == 30) % Frequenz mit 30 Hz

% Visualisierung Zeit-Frequenz-Analyse für die ersten 20 Sekunden
figure;
imagesc(spec_tf(freq1:freq2, :), [-30 30]);
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

% AUFGABE: Segmente von 2 Sekunden
winSize2s = 500; % 500 Zeitpunkte, die 4 ms auseinander liegen = 2 Sekunden %%%%%
% Berechnung Frequenzauflösung: 1/T [s]

% STFT von Hand für die ersten 20 Sekunden
spec_tf2 = [];
freq_tf2 = [];
for i = 1:10 %%%%% 1:10
    start = i * winSize2s;     % Wir starten bei Sekunde 2, nicht bei 0  %%%%%
    stop  = start + winSize2s; % Wir enden 1 Window Size später (2s)
    [spec_tf2(:,i),freq_tf2] = spectopo(EEG.data(channel,start:stop), 0, EEG.srate,'plot','off','winsize', winSize2s);
end

% Ergebnis ansehen:
freq1B = find(freq_tf2 == 2)
freq2B = find(freq_tf2 == 30)
plotFreqB = freq_tf2(freq1B:freq2B); % Frequenzachse (y-Achse) von 2 bis 30 Hz

% ABER: Wie viele Frequenz-Bins?
length(plotFreqB)
% Berechnung Frequenzauflösung: 1/T [s]
% 57 Frequenz-Bins, weil plotFreqB von 2 bis 30 Hz geht in Schritten von 0.5 Hz
zeitB = 2:2:20; % Zeitachse von 2 bis 20 Sekunden (2 Sek-Schritte!)

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

% Zuerst: Daten segmentieren! Um die Stimuli herum 3s
EEGC_all = pop_epoch(EEG, {4,5,6,13,14,15,17,18,19}, [-0.4, 2.6]);

% Anzahl an Zyklen für Wavelet-Analyse
nCycles0 = 0; % 0 heisst: keine Zyklen -> stattdessen STFT

% Was möchte die Funktion von uns haben?
doc pop_newtimef

% Visualisierung der STFT
figure;
[ersp,~,~,times,freqs] = pop_newtimef(EEGC_all, 1, channel, [-400, 2600], nCycles0, 'freqs', [3 30],'plotphasesign','off','plotitc','off');
% Inputs
%   EEGC_all               : EEG-Datensatz
%   1                      : Standard-Darstellung ('typeplot')
%   channel                : Elektrode 60
%   [-400, 2600]           : Analyse-Zeitfenster (ms); 400 ms vor Stimulus bis 2600 ms nach Stimulus
%   nCycles                : Anzahl der Zyklen für die Wavelet-Transformation
%   'freqs', [3 30]        : Frequenzbereich von 3 Hz bis 30 Hz
%   'plotphasesign', 'off' : Darstellung der Phasensignaldaten deaktivieren
%   'plotitc', 'off'       : Darstellung der Inter-Trial-Kohärenz (ITC)-Daten deaktivieren

% Outputs
%   ersp  : Matrix, die die Event-Related Spectral Perturbation (ERSP)-Werte enthält
%   ~     : Platzhalter für eine Ausgabe (z.B. ITC-Daten), die nicht gespeichert wird
%   times : Zeitpunkte (ms)
%   freqs : Frequenzbänder (Hz)

% Plot nicht schliessen!
% Wie ist die Frequenzauflösung?
freqs %%%%%

% Überlappende Windows!
times(1:20) % Schritte von 10ms (wird automatisch definiert)

%% Vergleiche Ergebnis der EEGLab STFT mit Wavelet-Analyse

% Anzahl an Zyklen für Wavelet-Analyse
nCycles5 = 3; % Wavelets mit 5 Zyklen

% Visualisierung der Wavelet-Analyse
figure;
[erspWave,~,~,timesWave,freqsWave] = pop_newtimef(EEGC_all, 1, channel, [-400, 2600], nCycles5, 'freqs', [3 30],'plotphasesign','off','plotitc','off');
% Man sieht:
%   Zeit teilweise abgeschnitten (Wavelets müssen ganz reinpassen!)
%   Datenlänge insgesamt 3s
%   5 Zyklen
%   niedrigste FOI = 3 Hz -> d.h. 3 Zyklen pro Sekunde -> 1 Zyklus = 1/3 s
%   darum Länge des langsamstes Wavelets = 0.33 s * 5 Zyklen = 1.67 s
%       -> zeigen auf Slide!

% -> zeigen mit weniger Zyklen

% OBEN (hohe frequenzen: Bsp. 20 - 30 Hz), Power wechselt schnell, gute
% Zeitauflösung, aber die langen "Streifen" zeigen, dass man nicht wirklich
% unterscheiden kann zwischen den hohen Frequenzen

% UNTEN (tiefe Frequenzen: Bsp. 3 - 5 Hz), Power wechselt langsam, schlechte
% Zeitauflösung

%% Zum Schluss: Hilbert-Transformation

% Für dieses Beispiel nehmen wir die Alpha-Oszillation über die ersten 10 Sekunden
EEG_short = pop_select(EEG, 'time', [0 10]);

% Alphaband filtern (8-13 Hz)
EEG_short_filt = pop_eegfiltnew(EEG_short, 8, 13);

% Visualisierung der Daten vor und nach dem Filtern für die erste Sekunde
figure;
plot(EEG_short.times(1:250),EEG_short.data(channel,1:250), 'LineWidth', 2);
hold on;
plot(EEG_short_filt.times(1:250),EEG_short_filt.data(channel,1:250), 'LineWidth', 2);
yline(0)
legend('Rohdaten', 'Daten im Alpha-Frequenzband (8 - 13 Hz)')
ylabel('Amplitude [\muV^2]')
xlabel('Zeit [ms]')
set(gca, 'FontSize', 25)

% Alpha Power extrahieren mit Hilbert-Transformation
alphapow = abs(hilbert(EEG_short_filt.data(channel,:)));

% Visualisierung Alpha-Frequenzband und Hilber-Transformierte Alpha-Power
figure;
plot(EEG_short_filt.times,EEG_short_filt.data(channel,:), 'LineWidth', 2);
hold on;
plot(EEG_short_filt.times,alphapow, 'LineWidth', 2)
yline(0)
legend('Daten im Alpha-Frequenzband (8 - 13 Hz)', 'Hilbert-Tranformierte Alpha-Power')
ylabel('Amplitude [\muV^2]')
xlabel('Zeit [ms]')
set(gca, 'FontSize', 25)
