%% Tutorial 6 – Zeit‑Frequenz‑Analyse
% Dieses optionale Tutorial führt dich in die Zeit‑Frequenz‑Analyse von
% EEG‑Signalen ein. Du lernst, wie du sowohl die zeitliche als auch die
% frequenzspezifische Dynamik von EEG‑Daten analysieren kannst.
%
% Inhalte:
% 1. Motivation: Warum Zeit‑Frequenz?
% 2. Fourier‑Transformation und Power‑Spektrum
% 3. Zeit‑Frequenz‑Analyse: STFT von Hand
% 4. Zeit‑Frequenz‑Analyse mit EEGLAB
% 5. Hilbert‑Transformation für Frequenzband‑Power

%% 0. Einführung
% Bisher hast du gelernt, wie du ERPs (Event‑Related Potentials) berechnest,
% indem du über Trials mittelst. ERPs zeigen gut, was im Mittel über Trials
% passiert, aber sie blenden zeitlich variierende Oszillationen aus. Beispielsweise
% könnte die Alpha‑Power (8–12 Hz) nach einem Stimulus kurzzeitig abnehmen
% (Alpha‑Desynchronisation), oder die Theta‑Power (4–8 Hz) könnte ansteigen.
%
% Die Zeit‑Frequenz‑Analyse erlaubt es dir, sowohl die zeitliche als auch die
% frequenzspezifische Dynamik zu betrachten. Du siehst also nicht nur, wann
% etwas passiert, sondern auch, in welchen Frequenzbändern es passiert.
%
% Diese Tutorials sind so gestaltet, dass du nicht alles auswendig lernen musst.
% Vielmehr geht es darum, ein grundlegendes Verständnis dafür zu entwickeln,
% wie Zeit‑Frequenz‑Analysen funktionieren. Du wirst später im Blockkurs viele
% Gelegenheiten haben, das Gelernte anzuwenden.

%% 1. Motivation: Warum Zeit‑Frequenz?
% ERPs zeigen dir die gemittelte elektrische Aktivität über die Zeit. Das ist
% sehr nützlich, um z.B. die N170 oder P300 Komponente zu identifizieren. Aber
% ERPs zeigen dir nicht, wie sich die Power in verschiedenen Frequenzbändern
% über die Zeit verändert.
%
% Beispiel: Stelle dir vor, du präsentierst einen visuellen Stimulus. Nach dem
% Stimulus könnte die Alpha‑Power (8–12 Hz) kurzzeitig abnehmen (Desynchronisation),
% während gleichzeitig die Gamma‑Power (30–100 Hz) ansteigt. Diese Informationen
% gehen in einem normalen ERP verloren, weil du über alle Frequenzen mittelst.
%
% Die Zeit‑Frequenz‑Analyse zeigt dir diese Dynamik: Du siehst eine "Landkarte"
% der Gehirnaktivität, die sowohl die Zeit (x‑Achse) als auch die Frequenz
% (y‑Achse) zeigt. Die Farben zeigen dir die Power (Leistung) in jedem
% Zeit‑Frequenz‑Bereich.

%% 2. Fourier‑Transformation und Power‑Spektrum
% Bevor wir zur Zeit‑Frequenz‑Analyse kommen, schauen wir uns nochmal die
% Fourier‑Transformation an, die du bereits aus Tutorial 2 kennst.

%% 2.1 FFT von Hand
% Du kannst die FFT (Fast Fourier Transform) direkt in MATLAB verwenden:

% Beispiel: FFT für einen Kanal, erste 1000 Datenpunkte (4 Sekunden bei 250 Hz)
% channel = 60;
% fft_res = abs(fft(EEG.data(channel, 1:1000)));
% fft_res = fft_res(1:length(fft_res)/2);  % Nur erste Hälfte (Symmetrie)

% Die Funktion `fft` berechnet die Fourier‑Transformation. `abs` gibt dir die
% Amplitude (ohne Phaseninformation). Die zweite Zeile nimmt nur die erste
% Hälfte des Ergebnisses, weil die FFT symmetrisch ist.
%
% WICHTIGER HINWEIS: Die FFT gibt dir ein Spektrum für das gesamte Zeitfenster,
% aber keine Information darüber, wann welche Frequenzen auftreten. Wenn du
% wissen möchtest, wie sich die Frequenzen über die Zeit ändern, brauchst du
% eine Zeit‑Frequenz‑Analyse.

%% 2.2 Power‑Spektrum mit spectopo
% EEGLAB bietet die Funktion `spectopo`, die ein Power‑Spektrum (Leistungsspektrum)
% berechnet. Das ist praktischer als die FFT von Hand, weil es automatisch die
% richtige Skalierung und Darstellung macht.

% Beispiel: Power‑Spektrum für einen Kanal
% channel = 60;
% [spec, freq] = spectopo(EEG.data(channel, 1:1000), 0, EEG.srate);

% Die Funktion `spectopo` nimmt als Eingabe:
% - die Daten (hier: erste 1000 Datenpunkte von Kanal 60)
% - die Anzahl der Frames (0 bedeutet: alle Datenpunkte)
% - die Samplingrate (Abtastrate) in Hz
%
% Die Ausgabe ist:
% - `spec`: das Power‑Spektrum (Leistungsspektrum) in dB
% - `freq`: die Frequenzen, für die das Spektrum berechnet wurde
%
% `spectopo` verwendet intern ein Welch‑Spektrum: Die Daten werden in mehrere
% Segmente unterteilt, für jedes Segment wird eine FFT berechnet, und die
% Ergebnisse werden gemittelt. Das gibt ein glatteres, weniger verrauschtes
% Spektrum als eine einfache FFT.
%
% WICHTIGER HINWEIS: `spectopo` gibt das Spektrum in dB (Dezibel) zurück, nicht
% in absoluten Werten. dB ist eine logarithmische Skala, die grosse
% Unterschiede besser darstellt. Ein Unterschied von 10 dB entspricht einer
% 10‑fachen Änderung der Power.

%% 2.3 Power‑Spektrum für alle Kanäle
% Du kannst `spectopo` auch für alle Kanäle gleichzeitig verwenden:

% [spec, freq] = spectopo(EEG.data, 0, EEG.srate);

% Jetzt ist `spec` eine Matrix mit Dimensionen [Kanäle x Frequenzen]. Du kannst
% dir das Spektrum für einen bestimmten Kanal anschauen:

% figure;
% plot(freq, spec(60, :))
% xlabel('Frequenz (Hz)')
% ylabel('Power (dB)')
% title('Power‑Spektrum für Kanal 60')

% WICHTIGER HINWEIS: Die Dimensionen von `spec` sind [Kanäle, Frequenzen]. Das
% erste Argument ist der Kanal‑Index, das zweite die Frequenz. `spec(60, :)`
% gibt dir das Spektrum für Kanal 60 für alle Frequenzen.

EXKURS Welch‑Spektrum: Das Welch‑Spektrum ist eine Methode zur Schätzung des
Power‑Spektrums, die die Daten in überlappende Segmente unterteilt und für
jedes Segment eine FFT berechnet. Die Ergebnisse werden dann gemittelt. Das
reduziert das Rauschen im Spektrum, aber verschlechtert die Frequenzauflösung.
Die Frequenzauflösung ist 1/T, wobei T die Länge eines Segments in Sekunden
ist. Wenn du Segmente von 1 Sekunde verwendest, ist die Frequenzauflösung 1 Hz.
Wenn du Segmente von 2 Sekunden verwendest, ist die Frequenzauflösung 0.5 Hz
(besser), aber du hast weniger Segmente zum Mitteln (mehr Rauschen).

%% 3. Zeit‑Frequenz‑Analyse: STFT von Hand
% Die STFT (Short‑Time Fourier Transform) berechnet Fourier‑Spektren in
% gleitenden Zeitfenstern. Jedes Fenster liefert ein Spektrum, und zusammen
% ergeben sie eine Zeit‑Frequenz‑Darstellung.

%% 3.1 STFT mit spectopo von Hand
% Du kannst die STFT "von Hand" machen, indem du `spectopo` für verschiedene
% Zeitfenster aufrufst:

% Beispiel: STFT für die ersten 20 Sekunden mit 1‑Sekunden‑Fenstern
% channel = 60;
% winSize1s = 250;  % 250 Zeitpunkte = 1 Sekunde bei 250 Hz
% spec_tf = [];
% freq_tf = [];
%
% for i = 1:20
%     start = i * winSize1s;     % Start bei Sekunde i
%     stop  = start + winSize1s; % Ende 1 Sekunde später
%     [spec_tf(:, i), freq_tf] = spectopo(EEG.data(channel, start:stop), 0, ...
%         EEG.srate, 'plot', 'off', 'winsize', winSize1s);
% end

% Hier iterierst du über 20 Sekunden und berechnest für jede Sekunde ein
% Power‑Spektrum. Das Ergebnis `spec_tf` ist eine Matrix mit Dimensionen
% [Frequenzen x Zeitfenster]. Jede Spalte ist ein Spektrum für ein Zeitfenster.
%
% WICHTIGER HINWEIS: Die Frequenzauflösung hängt von der Fensterlänge ab. Mit
% 1‑Sekunden‑Fenstern ist die Frequenzauflösung 1 Hz. Mit 2‑Sekunden‑Fenstern
% wäre die Frequenzauflösung 0.5 Hz (besser), aber die Zeitauflösung wäre
% schlechter (du siehst weniger Details in der Zeit).

%% 3.2 Visualisierung der Zeit‑Frequenz‑Darstellung
% Du kannst die Zeit‑Frequenz‑Darstellung mit `imagesc` visualisieren:

% Beispiel: Nur Frequenzen von 2–30 Hz anzeigen
% freq1 = find(freq_tf == 2);   % Index für 2 Hz
% freq2 = find(freq_tf == 30); % Index für 30 Hz
%
% figure;
% imagesc(spec_tf(freq1:freq2, :), [-30 30])
% colormap('turbo')
% colorbar
% xlabel('Zeit [s]')
% ylabel('Frequenzen [Hz]')
% title('TFR: Segmente von 1 Sekunde')
% set(gca, 'YDir', 'normal')
% set(gca, 'FontSize', 25)

% Die Funktion `imagesc` zeigt eine Matrix als farbiges Bild. Die Farben
% zeigen die Power: Rot könnte hohe Power bedeuten, Blau niedrige Power. Die
% Werte `[-30 30]` begrenzen den Farbbereich (in dB).
%
% WICHTIGER HINWEIS: `set(gca, 'YDir', 'normal')` stellt sicher, dass die
% y‑Achse von unten nach oben geht (niedrige Frequenzen unten, hohe oben).
% Ohne diese Einstellung könnte die y‑Achse invertiert sein.

%% 3.3 Zeit‑Frequenz‑Trade‑off
% Es gibt einen wichtigen Trade‑off zwischen Zeit‑ und Frequenzauflösung:
%
% - **Längere Fenster**: gute Frequenzauflösung, aber schlechte Zeitauflösung
%   (du siehst nicht genau, wann etwas passiert)
% - **Kürzere Fenster**: gute Zeitauflösung, aber schlechte Frequenzauflösung
%   (du kannst nicht genau zwischen nahen Frequenzen unterscheiden)
%
% Beispiel: Vergleich zwischen 1‑Sekunden‑ und 2‑Sekunden‑Fenstern
% Mit 2‑Sekunden‑Fenstern hast du eine bessere Frequenzauflösung (0.5 Hz statt
% 1 Hz), aber du siehst weniger Details in der Zeit (nur alle 2 Sekunden ein
% Wert statt alle Sekunde).

%% 4. Zeit‑Frequenz‑Analyse mit EEGLAB
% EEGLAB bietet die Funktion `pop_newtimef`, die Zeit‑Frequenz‑Analysen
% automatisch durchführt. Das ist viel praktischer als die STFT von Hand.

%% 4.1 Vorbereitung: Epochen erstellen
% Für die Zeit‑Frequenz‑Analyse brauchst du normalerweise epoched Daten:

% Beispiel: Epochen von -400 ms bis 2600 ms um Events herum
% EEGC_all = pop_epoch(EEG, {4, 5, 6, 13, 14, 15, 17, 18, 19}, [-0.4, 2.6]);

% Hier erstellst du Epochen von -400 ms bis 2600 ms relativ zu den Events 4–19.
% Das gibt dir ein Zeitfenster von 3 Sekunden pro Epoche.

%% 4.2 STFT mit pop_newtimef
% Die Funktion `pop_newtimef` führt eine Zeit‑Frequenz‑Analyse durch:

% Beispiel: STFT für Kanal 60
% channel = 60;
% nCycles0 = 0;  % 0 bedeutet: STFT (keine Wavelets)
%
% [ersp, ~, ~, times, freqs] = pop_newtimef(EEGC_all, 1, channel, ...
%     [-400, 2600], nCycles0, 'freqs', [3 30], ...
%     'plotphasesign', 'off', 'plotitc', 'off');

% Die Funktion `pop_newtimef` nimmt als Eingabe:
% - die EEG‑Struktur mit Epochen
% - den Typ der Darstellung (1 = Standard)
% - den Kanal‑Index
% - das Zeitfenster in ms (hier: -400 bis 2600 ms)
% - die Anzahl der Zyklen (0 = STFT, >0 = Wavelets)
% - den Frequenzbereich (hier: 3–30 Hz)
% - weitere Optionen (z.B. ob Phasen oder ITC geplottet werden sollen)
%
% Die Ausgabe ist:
% - `ersp`: Event‑Related Spectral Perturbation (Matrix: Frequenzen x Zeitpunkte)
% - `times`: Zeitpunkte in ms
% - `freqs`: Frequenzen in Hz
%
% WICHTIGER HINWEIS: `ersp` zeigt die Änderung der Power relativ zu einer
% Baseline. Positive Werte bedeuten eine Zunahme der Power, negative Werte
% eine Abnahme. Die Baseline wird automatisch aus dem Zeitfenster vor dem
% Stimulus berechnet (z.B. -400 bis 0 ms).

%% 4.3 Wavelet‑Analyse mit pop_newtimef
% Du kannst auch eine Wavelet‑Analyse durchführen, indem du die Anzahl der
% Zyklen auf einen Wert >0 setzt:

% Beispiel: Wavelet‑Analyse mit 3 Zyklen
% nCycles5 = 3;  % Wavelets mit 3 Zyklen
%
% [erspWave, ~, ~, timesWave, freqsWave] = pop_newtimef(EEGC_all, 1, channel, ...
%     [-400, 2600], nCycles5, 'freqs', [3 30], ...
%     'plotphasesign', 'off', 'plotitc', 'off');

% Bei Wavelets ist die Zeit‑Frequenz‑Auflösung frequenzabhängig:
% - **Hohe Frequenzen** (z.B. 20–30 Hz): gute Zeitauflösung, aber schlechte
%   Frequenzauflösung (du siehst nicht genau, welche Frequenz es ist)
% - **Niedrige Frequenzen** (z.B. 3–5 Hz): gute Frequenzauflösung, aber
%   schlechte Zeitauflösung (du siehst nicht genau, wann etwas passiert)
%
% Das ist anders als bei der STFT, wo die Auflösung für alle Frequenzen gleich
% ist. Wavelets sind oft besser für die Analyse von Oszillationen, weil sie
% der Natur von Oszillationen besser entsprechen (niedrige Frequenzen ändern
% sich langsam, hohe Frequenzen schnell).

EXKURS Wavelets vs. STFT: Wavelets verwenden frequenzabhängige Fenster: Für
niedrige Frequenzen sind die Fenster länger (bessere Frequenzauflösung), für
hohe Frequenzen kürzer (bessere Zeitauflösung). Das entspricht besser der Natur
von Oszillationen: Alpha (8–12 Hz) ändert sich langsam, Gamma (30–100 Hz)
schnell. Die Anzahl der Zyklen bestimmt, wie lang das Fenster ist: Mit 3
Zyklen bei 3 Hz ist das Fenster 1 Sekunde lang, mit 3 Zyklen bei 30 Hz nur 0.1
Sekunden. STFT verwendet für alle Frequenzen die gleiche Fensterlänge, was
einfacher ist, aber nicht optimal für alle Frequenzen.

%% 5. Hilbert‑Transformation für Frequenzband‑Power
% Eine andere Methode zur Analyse von Frequenzband‑Power ist die
% Hilbert‑Transformation. Du filterst die Daten in einem bestimmten
% Frequenzband und verwendest dann die Hilbert‑Transformation, um die
% Einhüllende (envelope) zu extrahieren, die die Power repräsentiert.

%% 5.1 Daten filtern
% Zuerst filterst du die Daten in einem bestimmten Frequenzband:

% Beispiel: Alpha‑Band (8–13 Hz) filtern
% EEG_short = pop_select(EEG, 'time', [0 10]);  % Erste 10 Sekunden
% EEG_short_filt = pop_eegfiltnew(EEG_short, 8, 13);  % Bandpassfilter 8–13 Hz

% Hier schneidest du die ersten 10 Sekunden aus und filterst dann im
% Alpha‑Band (8–13 Hz). Das Ergebnis ist ein Signal, das hauptsächlich
% Alpha‑Oszillationen enthält.

%% 5.2 Hilbert‑Transformation
% Die Hilbert‑Transformation extrahiert die Einhüllende des gefilterten
% Signals, die die Power im Frequenzband repräsentiert:

% channel = 60;
% alphapow = abs(hilbert(EEG_short_filt.data(channel, :)));

% Die Funktion `hilbert` berechnet die analytische Darstellung des Signals
% (komplexe Zahlen). `abs` gibt dir den Betrag, der die Einhüllende (envelope)
% ist. Diese Einhüllende zeigt dir, wie sich die Alpha‑Power über die Zeit
% ändert.
%
% WICHTIGER HINWEIS: Die Hilbert‑Transformation funktioniert nur gut, wenn das
% Signal hauptsächlich aus einer Frequenzkomponente besteht. Deshalb filterst
% du zuerst im gewünschten Frequenzband. Wenn du die Hilbert‑Transformation
% auf ungefilterte Daten anwendest, bekommst du keine sinnvolle Power‑Schätzung.

%% 5.3 Visualisierung
% Du kannst die gefilterten Daten und die Hilbert‑Transformierte Power
% visualisieren:

% figure;
% plot(EEG_short_filt.times, EEG_short_filt.data(channel, :), 'LineWidth', 2)
% hold on
% plot(EEG_short_filt.times, alphapow, 'LineWidth', 2)
% yline(0)
% legend('Daten im Alpha‑Frequenzband (8–13 Hz)', ...
%     'Hilbert‑Transformierte Alpha‑Power')
% ylabel('Amplitude [\muV]')
% xlabel('Zeit [ms]')
% set(gca, 'FontSize', 25)

% Die blaue Linie zeigt das gefilterte Signal (Alpha‑Oszillationen), die rote
% Linie zeigt die Einhüllende (Alpha‑Power). Du siehst, wie die Power über die
% Zeit variiert: Manchmal ist sie hoch (starke Alpha‑Oszillationen), manchmal
% niedrig (schwache Alpha‑Oszillationen).

EXKURS Analytische Signale und Hilbert‑Transformation: Die Hilbert‑Transformation
erzeugt ein "analytisches Signal" aus einem reellen Signal. Ein analytisches
Signal ist eine komplexe Zahl, deren Realteil das ursprüngliche Signal ist
und deren Imaginärteil die Hilbert‑Transformierte. Der Betrag (abs) dieses
komplexen Signals ist die Einhüllende, die die momentane Amplitude (und damit
die Power) zeigt. Die Phase zeigt die momentane Phase der Oszillation. Für
Frequenzband‑Power interessiert uns hauptsächlich die Einhüllende (der Betrag).

%% Zusammenfassung
% In diesem Tutorial hast du gelernt:
%
% 1. **Warum Zeit‑Frequenz‑Analyse**: Sie zeigt dir, wie sich die Power in
%    verschiedenen Frequenzbändern über die Zeit ändert, was in ERPs verloren geht.
%
% 2. **Power‑Spektrum**: Wie du mit `spectopo` ein Power‑Spektrum berechnest,
%    das dir zeigt, welche Frequenzen im Signal vorhanden sind.
%
% 3. **STFT von Hand**: Wie du die STFT "von Hand" machst, indem du `spectopo`
%    für verschiedene Zeitfenster aufrufst, und wie du die Ergebnisse mit
%    `imagesc` visualisierst.
%
% 4. **Zeit‑Frequenz‑Analyse mit EEGLAB**: Wie du `pop_newtimef` verwendest,
%    um automatisch Zeit‑Frequenz‑Analysen durchzuführen, sowohl mit STFT als
%    auch mit Wavelets.
%
% 5. **Hilbert‑Transformation**: Wie du die Hilbert‑Transformation verwendest,
%    um die Power in einem bestimmten Frequenzband zu extrahieren.
%
% Diese Methoden wirst du später im Blockkurs häufig verwenden, wenn du
% Oszillationen analysierst (z.B. Alpha‑Desynchronisation, Theta‑Power‑Anstieg).
% Es lohnt sich, sich mit ihnen vertraut zu machen.
