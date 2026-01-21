%% Tutorial 7 – Signale, Filter und Zeit‑Frequenz‑Analyse (Grundlagen)
% Dieses optionale Tutorial vertieft die Grundlagen der digitalen
% Signalverarbeitung für EEG‑Signale. Du lernst hier Konzepte, die für das
% Verständnis von EEG‑Analysen wichtig sind.
%
% Inhalte:
% 1. Signale in der Zeitdomäne
% 2. Aliasing verstehen
% 3. Signale in der Frequenzdomäne
% 4. Filtern von Signalen
% 5. Kurze Einführung Zeit‑Frequenz‑Analyse

%% 0. Einführung
% In diesem Tutorial vertiefst du dein Verständnis für digitale Signale und
% ihre Verarbeitung. Du hast bereits in Tutorial 2 die Grundlagen gelernt
% (Sinuswellen, Frequenz, Amplitude, Phase). Hier geht es um praktische
% Aspekte, die beim Arbeiten mit echten EEG‑Daten wichtig sind:
% - Wie werden Signale abgetastet (sampling)?
% - Was passiert, wenn die Samplingrate zu niedrig ist (Aliasing)?
% - Wie analysiert man Signale in der Frequenzdomäne?
% - Wie filtert man Signale, um bestimmte Frequenzbereiche zu isolieren?
% - Wie analysiert man Signale gleichzeitig in Zeit und Frequenz?
%
% Diese Tutorials sind so gestaltet, dass du nicht alles auswendig lernen musst.
% Vielmehr geht es darum, ein grundlegendes Verständnis dafür zu entwickeln,
% wie digitale Signale funktionieren. Du wirst später im Blockkurs viele
% Gelegenheiten haben, das Gelernte anzuwenden.

%% 1. Signale in der Zeitdomäne
% In der Zeitdomäne (time domain) betrachten wir, wie sich ein Signal über die
% Zeit verändert. Beim EEG ist das z.B. die Spannungsänderung in µV über die
% Zeit in Millisekunden.

%% 1.1 Was ist ein Signal? Beispiele aus EEG
% Ein Signal ist eine Funktion, die eine physikalische Grösse über die Zeit
% beschreibt. Beim EEG ist das die elektrische Spannung, die an den Elektroden
% gemessen wird.

% Beispiel: Einfaches Sinussignal
fs  = 250;          % Samplingrate (Abtastrate) in Hz
t   = 0:1/fs:2;     % Zeitvektor: 2 Sekunden in Schritten von 1/fs
sig = sin(2*pi*10*t);  % 10‑Hz‑Sinuswelle

figure;
plot(t, sig);
xlabel('Zeit (s)');
ylabel('Amplitude');
title('10‑Hz‑Sinussignal in der Zeitdomäne');
grid on;

% Dieses Signal zeigt eine Sinuswelle mit einer Frequenz von 10 Hz. In 2
% Sekunden siehst du 20 vollständige Zyklen (2 Sekunden × 10 Hz = 20 Zyklen).
%
% Beispiele für Signale in der EEG‑Analyse:
% - **Rohes EEG**: Die gemessene Spannung an einem Kanal über mehrere Sekunden
% - **ERPs**: Gemittelte Signale über viele Trials (Event‑Related Potentials)
% - **Frequenzband‑Power**: Zeitverläufe spezifischer Frequenzbänder (z.B.
%   Alpha‑Power über die Zeit)

%% 1.2 Diskrete vs. kontinuierliche Signale
% Es gibt einen wichtigen Unterschied zwischen kontinuierlichen und diskreten
% Signalen:
%
% **Kontinuierlich**: Das Signal ist zu jedem Zeitpunkt definiert (theoretisch
% unendlich fein). In der Realität gibt es keine wirklich kontinuierlichen
% Signale, aber man kann sie sich als glatte Kurven vorstellen.
%
% **Diskret**: Das Signal ist nur zu bestimmten Zeitpunkten definiert. Beim EEG
% wird z.B. alle 4 ms ein Wert gemessen (bei einer Samplingrate von 250 Hz).
% Zwischen diesen Zeitpunkten wissen wir nicht, was das Signal macht – wir
% müssen es aus den gemessenen Werten schätzen.

% Beispiel: Vergleich kontinuierlich vs. diskret
t_continuous = 0:0.001:1;  % Sehr feine Abtastung (1000 Hz)
t_discrete   = 0:1/250:1;   % Diskretisierung bei 250 Hz

sig_cont = sin(2*pi*10*t_continuous);
sig_disc = sin(2*pi*10*t_discrete);

figure;
plot(t_continuous, sig_cont, 'b-', 'LineWidth', 1);
hold on;
stem(t_discrete, sig_disc, 'r', 'MarkerSize', 4);
hold off;
xlabel('Zeit (s)');
ylabel('Amplitude');
title('Kontinuierlich (blau) vs. diskret (rot)');
legend('Kontinuierlich', 'Diskret', 'Location', 'best');
grid on;

% Die blaue Linie zeigt das "kontinuierliche" Signal (sehr fein abgetastet),
% die roten Punkte zeigen die diskreten Abtastpunkte bei 250 Hz. Du siehst,
% dass die diskreten Punkte das Signal gut repräsentieren, aber zwischen den
% Punkten wissen wir nicht genau, was passiert.
%
% WICHTIGER HINWEIS: In MATLAB arbeiten wir immer mit diskreten Signalen, auch
% wenn wir sie als kontinuierliche Linien plotten. Die "Kontinuität" kommt
% daher, dass MATLAB die Punkte mit Linien verbindet.

%% 1.3 Samplingrate und Nyquist‑Frequenz
% Die Samplingrate (Abtastrate, `fs`) gibt an, wie viele Messpunkte pro
% Sekunde aufgezeichnet werden. Bei einer Samplingrate von 250 Hz werden also
% 250 Werte pro Sekunde gemessen, d.h. alle 4 ms ein Wert.

fs1 = 100;          % 100 Hz Samplingrate
nyquist1 = fs1/2   % Nyquist‑Frequenz = 50 Hz

fs2 = 500;          % 500 Hz Samplingrate
nyquist2 = fs2/2   % Nyquist‑Frequenz = 250 Hz

% Die **Nyquist‑Frequenz** (Nyquist frequency) ist `fs/2` und ist die maximale
% Frequenz, die ohne Aliasing korrekt dargestellt werden kann. Das bedeutet:
% - Bei einer Samplingrate von 100 Hz kannst du Frequenzen bis zu 50 Hz
%   korrekt darstellen
% - Bei einer Samplingrate von 500 Hz kannst du Frequenzen bis zu 250 Hz
%   korrekt darstellen
%
% WICHTIGER HINWEIS: Die Nyquist‑Frequenz ist die theoretische Obergrenze. In
% der Praxis sollte die höchste Frequenz im Signal deutlich unter der
% Nyquist‑Frequenz liegen, um sicherzugehen, dass keine Aliasing‑Effekte
% auftreten. Deshalb filtert man EEG‑Daten oft mit einem Tiefpassfilter bei
% 40 Hz, auch wenn die Samplingrate 250 Hz ist (Nyquist = 125 Hz).

EXKURS Nyquist‑Shannon‑Abtasttheorem: Das Nyquist‑Shannon‑Abtasttheorem besagt,
dass ein Signal, das Frequenzen bis zu f_max enthält, mit einer Samplingrate
von mindestens 2×f_max abgetastet werden muss, um es ohne Informationsverlust
rekonstruieren zu können. Die Nyquist‑Frequenz (fs/2) ist also die maximale
Frequenz, die korrekt dargestellt werden kann. Wenn das Signal Frequenzen
oberhalb der Nyquist‑Frequenz enthält, kommt es zu Aliasing (siehe nächster
Abschnitt).

%% 2. Aliasing verstehen
% Aliasing (Aliasing) tritt auf, wenn die Samplingrate zu niedrig ist, um die
% im Signal enthaltenen hohen Frequenzen korrekt abzubilden. Hohe Frequenzen
% erscheinen dann als niedrigere Frequenzen.

%% 2.1 Intuition: zu selten abtasten
% Stelle dir vor, du filmst ein sich drehendes Rad mit einer Kamera. Wenn das
% Rad sich sehr schnell dreht und die Kamera zu langsam Bilder macht, kann es
% so aussehen, als würde sich das Rad rückwärts oder gar nicht drehen. Das ist
% Aliasing.
%
% Bei Signalen passiert dasselbe: Wenn eine hohe Frequenz zu selten abgetastet
% wird, erscheint sie als niedrigere Frequenz.

% Beispiel: 30‑Hz‑Signal mit unterschiedlicher Samplingrate
f_sig = 30;   % Signal‑Frequenz 30 Hz

fs_low  = 40;                 % zu niedrige Samplingrate (Nyquist = 20 Hz)
t_low   = 0:1/fs_low:1;
sig_low = sin(2*pi*f_sig*t_low);

fs_high  = 200;               % ausreichend hohe Samplingrate (Nyquist = 100 Hz)
t_high   = 0:1/fs_high:1;
sig_high = sin(2*pi*f_sig*t_high);

figure;
subplot(2,1,1);
stem(t_low, sig_low, 'filled');
hold on;
plot(t_high, sig_high, 'r:', 'LineWidth', 2);
hold off;
xlabel('Zeit (s)');
ylabel('Amplitude');
title('30 Hz bei fs = 40 Hz (Aliasing‑Gefahr)');
legend('gesampelte Punkte', '"wahres" Signal', 'Location', 'best');
grid on;

subplot(2,1,2);
plot(t_high, sig_high);
xlabel('Zeit (s)');
ylabel('Amplitude');
title('30 Hz bei fs = 200 Hz (gut abgetastet)');
grid on;

% Im oberen Plot siehst du, dass bei einer Samplingrate von 40 Hz (Nyquist =
% 20 Hz) das 30‑Hz‑Signal nicht korrekt abgetastet werden kann. Die roten
% Punkte zeigen ein anderes Muster als die blaue Linie (das "wahre" Signal).
% Im unteren Plot siehst du, dass bei 200 Hz Samplingrate das Signal korrekt
% abgetastet wird.
%
% WICHTIGER HINWEIS: Bei einer Samplingrate von 40 Hz kann ein 30‑Hz‑Signal
% nicht korrekt dargestellt werden, weil 30 Hz > 20 Hz (Nyquist). Das Signal
% wird "aliased" und erscheint als niedrigere Frequenz (hier: 10 Hz, weil 30
% Hz - 20 Hz = 10 Hz).

%% 2.2 Aliasing‑Simulation in MATLAB
% Wir simulieren jetzt explizit, wie eine hohe Frequenz bei zu niedriger
% Samplingrate als niedrigere Frequenz erscheint:

fs_alias = 100;  % Samplingrate 100 Hz (Nyquist = 50 Hz)
f_high   = 80;   % Signal mit 80 Hz (höher als Nyquist!)
t_alias  = 0:1/fs_alias:1;
sig_alias = sin(2*pi*f_high*t_alias);

figure;
stem(t_alias, sig_alias, 'filled');
xlabel('Zeit (s)');
ylabel('Amplitude');
title('80 Hz bei fs = 100 Hz (erscheint als 20 Hz wegen Aliasing)');
grid on;

% Wenn du die Punkte anschaust, siehst du ein Muster, das einer 20‑Hz‑Welle
% entspricht, nicht einer 80‑Hz‑Welle! Das liegt daran, dass 80 Hz > 50 Hz
% (Nyquist) ist. Die Frequenz wird "gefaltet" (folded) und erscheint als 80 -
% 100 = -20 Hz, was äquivalent zu 20 Hz ist.
%
% WICHTIGER HINWEIS: Die "gefaltete" Frequenz berechnet sich als: f_aliased =
% |f_signal - n×fs|, wobei n eine ganze Zahl ist, die so gewählt wird, dass
% f_aliased zwischen 0 und fs/2 liegt. Hier: |80 - 100| = 20 Hz.

%% 2.3 Praktische Konsequenzen für EEG‑Aufnahmen
% Bei EEG‑Aufnahmen ist es wichtig, dass die Samplingrate hoch genug ist, um
% alle relevanten Frequenzen korrekt abzutasten. Typische EEG‑Frequenzbänder sind:
% - Delta: 0.5–4 Hz
% - Theta: 4–8 Hz
% - Alpha: 8–13 Hz
% - Beta: 13–30 Hz
% - Gamma: 30–100 Hz (seltener analysiert)
%
% Bei einer Samplingrate von 250 Hz (Nyquist = 125 Hz) können alle diese
% Frequenzen theoretisch korrekt abgetastet werden. Aber: Wenn es Störsignale
% gibt, die höhere Frequenzen enthalten (z.B. Netzbrummen bei 50 Hz oder
% Muskelartefakte bei >100 Hz), können diese durch Aliasing als niedrigere
% Frequenzen erscheinen und die Analyse stören.
%
% Deshalb verwendet man normalerweise:
% 1. **Anti‑Aliasing‑Filter** vor der Digitalisierung (hardware‑seitig)
% 2. **Tiefpassfilter** in der Software (z.B. bei 40 Hz), um hohe Frequenzen
%    zu entfernen, bevor sie aliased werden können

EXKURS Anti‑Aliasing‑Filter: Bevor ein Signal digitalisiert wird, sollte es
durch einen Anti‑Aliasing‑Filter (Tiefpassfilter) geleitet werden, der alle
Frequenzen oberhalb der Nyquist‑Frequenz entfernt. Dieser Filter ist meist
hardware‑seitig im EEG‑System eingebaut. In der Software verwendet man dann
zusätzlich Tiefpassfilter (z.B. bei 40 Hz), um sicherzugehen, dass keine
hohen Frequenzen die Analyse stören.

%% 3. Signale in der Frequenzdomäne
% In der Frequenzdomäne (frequency domain) betrachten wir, welche Frequenzen
% in einem Signal enthalten sind und wie stark sie ausgeprägt sind. Das ist
% sehr nützlich, um z.B. Alpha‑Oszillationen zu identifizieren.

%% 3.1 Sinuswellen und Frequenzen
% Ein Sinussignal besteht aus einer einzigen Frequenz. Wenn du ein
% Frequenzspektrum berechnest, siehst du einen Peak bei dieser Frequenz.

% Beispiel: 10‑Hz‑Sinussignal
fs = 250;
t = 0:1/fs:2;  % 2 Sekunden
sig_10hz = sin(2*pi*10*t);

figure;
subplot(2,1,1);
plot(t, sig_10hz);
xlabel('Zeit (s)');
ylabel('Amplitude');
title('10‑Hz‑Sinussignal in der Zeitdomäne');
grid on;

% Im Zeitbereich siehst du eine Sinuswelle. Im Frequenzbereich (siehe nächster
% Abschnitt) würdest du einen Peak bei 10 Hz sehen.

%% 3.2 Fourier‑Transformation in MATLAB (fft)
% Die Fourier‑Transformation (Fourier Transform) zerlegt ein Signal in seine
% Frequenzkomponenten. In MATLAB verwendest du dafür die Funktion `fft`:

% FFT berechnen
fft_res = fft(sig_10hz);
fft_res = fft_res(1:length(fft_res)/2);  % Nur erste Hälfte (Symmetrie)

% Frequenzachse erstellen
frequenzen = (0:length(fft_res)-1) * fs / length(sig_10hz);

figure;
subplot(2,1,2);
plot(frequenzen, abs(fft_res));
xlabel('Frequenz (Hz)');
ylabel('Amplitude');
title('Frequenzspektrum (FFT)');
xlim([0 50]);  % Nur bis 50 Hz anzeigen
grid on;

% Die Funktion `fft` berechnet die Fast Fourier Transform (FFT). `abs` gibt dir
% die Amplitude (ohne Phaseninformation). Die Frequenzachse wird berechnet als:
% `f = (0:N-1) * fs / N`, wobei N die Anzahl der Datenpunkte ist.
%
% Du siehst einen Peak bei 10 Hz – genau die Frequenz, die im Signal enthalten
% ist!
%
% WICHTIGER HINWEIS: Die Frequenzauflösung der FFT ist `fs / N`, wobei N die
% Anzahl der Datenpunkte ist. Bei 2 Sekunden Daten bei 250 Hz hast du N = 500
% Datenpunkte, also eine Frequenzauflösung von 250/500 = 0.5 Hz. Das bedeutet,
% du kannst Frequenzen in Schritten von 0.5 Hz unterscheiden.

EXKURS Komplexe Zahlen und FFT: Die FFT gibt komplexe Zahlen zurück, die sowohl
Amplitude als auch Phase enthalten. `abs(fft_res)` gibt dir den Betrag
(Amplitude), `angle(fft_res)` würde dir die Phase geben. Für die meisten
Anwendungen interessiert uns hauptsächlich die Amplitude (Power). Die Phase ist
wichtig für Phasen‑Analysen (z.B. Phase‑Kohärenz zwischen Kanälen), die hier
aber nicht behandelt werden.

%% 3.3 Amplituden‑ und Leistungsspektren
% Es gibt zwei Arten von Spektren:
% - **Amplitudenspektrum** (amplitude spectrum): zeigt die Amplitude jeder
%   Frequenzkomponente
% - **Leistungsspektrum** (power spectrum): zeigt die Power (Leistung) jeder
%   Frequenzkomponente (Amplitude²)

% Amplitudenspektrum
amplitude_spektrum = abs(fft_res);

% Leistungsspektrum (Power = Amplitude²)
power_spektrum = abs(fft_res).^2;

figure;
subplot(2,1,1);
plot(frequenzen, amplitude_spektrum);
xlabel('Frequenz (Hz)');
ylabel('Amplitude');
title('Amplitudenspektrum');
xlim([0 50]);
grid on;

subplot(2,1,2);
plot(frequenzen, power_spektrum);
xlabel('Frequenz (Hz)');
ylabel('Power');
title('Leistungsspektrum');
xlim([0 50]);
grid on;

% Das Amplitudenspektrum zeigt die Amplitude jeder Frequenzkomponente. Das
% Leistungsspektrum zeigt die Power (Amplitude²). Die Power ist oft nützlicher,
% weil sie die "Stärke" einer Frequenzkomponente besser repräsentiert.
%
% WICHTIGER HINWEIS: In der EEG‑Analyse verwendet man oft das Leistungsspektrum
% (power spectrum), weil es besser mit der tatsächlichen elektrischen Power
% korreliert. Die Power wird oft in dB (Dezibel) dargestellt, um grosse
% Unterschiede besser sichtbar zu machen.

%% 4. Filtern von Signalen
% Filtern (filtering) entfernt unerwünschte Frequenzanteile aus einem Signal.
% Das ist wichtig, um z.B. langsame Drifts oder hohes Rauschen zu entfernen.

%% 4.1 Warum filtern wir EEG?
% EEG‑Signale enthalten viele verschiedene Frequenzkomponenten:
% - **Niederfrequente Drifts** (< 1 Hz): Langsame Änderungen der Baseline,
%   oft durch Bewegungsartefakte oder Elektroden‑Drift verursacht
% - **Niederfrequente Oszillationen** (1–4 Hz): Delta‑Band, oft bei Schlaf
% - **Alpha/Beta/Gamma** (8–100 Hz): Die eigentlichen interessierenden
%   Oszillationen
% - **Hohes Rauschen** (> 40 Hz): Muskelartefakte, Netzbrummen, etc.
%
% Durch Filtern können wir:
% - Langsame Drifts entfernen (Hochpassfilter)
% - Hohes Rauschen entfernen (Tiefpassfilter)
% - Bestimmte Frequenzbänder isolieren (Bandpassfilter)

%% 4.2 Hochpass‑, Tiefpass‑, Bandpass‑Filter
% Es gibt drei Haupttypen von Filtern:
%
% **Hochpassfilter** (high‑pass filter): Lässt nur hohe Frequenzen durch,
% entfernt niedrige Frequenzen. Beispiel: Filter bei 1 Hz entfernt alles < 1
% Hz (langsame Drifts).
%
% **Tiefpassfilter** (low‑pass filter): Lässt nur niedrige Frequenzen durch,
% entfernt hohe Frequenzen. Beispiel: Filter bei 40 Hz entfernt alles > 40 Hz
% (hohes Rauschen).
%
% **Bandpassfilter** (band‑pass filter): Lässt nur Frequenzen in einem
% bestimmten Bereich durch. Beispiel: Filter von 8–13 Hz isoliert das
% Alpha‑Band.

%% 4.3 Einfache Filter‑Beispiele in MATLAB
% In MATLAB kannst du Filter mit der Funktion `designfilt` erstellen und dann
% mit `filtfilt` anwenden:

% Beispiel: Hochpassfilter bei 1 Hz
d_high = designfilt('highpassiir', 'FilterOrder', 4, ...
    'HalfPowerFrequency', 1, 'SampleRate', fs);
sig_filtered_high = filtfilt(d_high, sig_10hz);

% Beispiel: Tiefpassfilter bei 40 Hz
d_low = designfilt('lowpassiir', 'FilterOrder', 4, ...
    'HalfPowerFrequency', 40, 'SampleRate', fs);
sig_filtered_low = filtfilt(d_low, sig_10hz);

% Beispiel: Bandpassfilter für Alpha‑Band (8–13 Hz)
d_band = designfilt('bandpassiir', 'FilterOrder', 4, ...
    'HalfPowerFrequency1', 8, 'HalfPowerFrequency2', 13, 'SampleRate', fs);
sig_filtered_band = filtfilt(d_band, sig_10hz);

% Die Funktion `designfilt` erstellt einen Filter mit bestimmten
% Eigenschaften:
% - `'highpassiir'`, `'lowpassiir'`, `'bandpassiir'`: Filtertyp
% - `'FilterOrder'`: Ordnung des Filters (höher = steiler, aber mehr
%   Verzerrungen)
% - `'HalfPowerFrequency'`: Grenzfrequenz (bei der die Power auf die Hälfte
%   reduziert ist)
% - `'SampleRate'`: Samplingrate
%
% `filtfilt` wendet den Filter an. `filtfilt` (nicht `filter`!) wendet den
% Filter vorwärts und rückwärts an, was Phasenverzerrungen vermeidet.
%
% WICHTIGER HINWEIS: In EEGLAB verwendest du normalerweise `pop_eegfiltnew`,
% nicht `designfilt`/`filtfilt`. Aber `designfilt`/`filtfilt` sind nützlich,
% um zu verstehen, wie Filter funktionieren, und für einfache Beispiele.

%% 4.4 Visualisierung: Signal vor und nach Filterung
% Du kannst das Signal vor und nach der Filterung vergleichen:

% Erstelle ein Signal mit mehreren Frequenzen
sig_mixed = sin(2*pi*10*t) + 0.5*sin(2*pi*50*t) + 0.2*randn(size(t));

% Hochpassfilter bei 5 Hz (entfernt < 5 Hz)
d_hp = designfilt('highpassiir', 'FilterOrder', 4, ...
    'HalfPowerFrequency', 5, 'SampleRate', fs);
sig_hp = filtfilt(d_hp, sig_mixed);

figure;
subplot(3,1,1);
plot(t, sig_mixed);
xlabel('Zeit (s)');
ylabel('Amplitude');
title('Original: 10 Hz + 50 Hz + Rauschen');
grid on;

subplot(3,1,2);
plot(t, sig_hp);
xlabel('Zeit (s)');
ylabel('Amplitude');
title('Nach Hochpassfilter (5 Hz): 10 Hz + 50 Hz bleiben');
grid on;

% Frequenzspektren vergleichen
fft_orig = abs(fft(sig_mixed));
fft_hp   = abs(fft(sig_hp));
freqs = (0:length(fft_orig)/2-1) * fs / length(sig_mixed);

subplot(3,1,3);
plot(freqs, fft_orig(1:length(freqs)), 'b-', 'LineWidth', 1);
hold on;
plot(freqs, fft_hp(1:length(freqs)), 'r-', 'LineWidth', 1);
hold off;
xlabel('Frequenz (Hz)');
ylabel('Amplitude');
title('Frequenzspektren: Original (blau) vs. gefiltert (rot)');
xlim([0 60]);
legend('Original', 'Gefiltert', 'Location', 'best');
grid on;

% Im oberen Plot siehst du das ursprüngliche Signal mit mehreren Frequenzen
% und Rauschen. Im mittleren Plot siehst du das Signal nach dem Hochpassfilter
% – die niedrigen Frequenzen (< 5 Hz) wurden entfernt. Im unteren Plot siehst
% du die Frequenzspektren: Im gefilterten Signal (rot) sind die niedrigen
% Frequenzen deutlich reduziert.

EXKURS Filtertypen: Es gibt verschiedene Filtertypen (Butterworth, Chebyshev,
Elliptic, etc.), die sich in ihren Eigenschaften unterscheiden. Butterworth‑
Filter haben eine flache Durchlasscharakteristik, Chebyshev‑Filter haben einen
steileren Übergang, aber mehr Rippeln. Für die meisten EEG‑Anwendungen sind
Butterworth‑Filter eine gute Wahl. Die Filterordnung bestimmt, wie steil der
Übergang ist: höhere Ordnung = steiler, aber mehr Verzerrungen und längere
Einschwingzeit.

%% 5. Kurze Einführung Zeit‑Frequenz‑Analyse
% Die Zeit‑Frequenz‑Analyse (time‑frequency analysis) zeigt dir, wie sich die
% Frequenzkomponenten eines Signals über die Zeit ändern. Das ist wichtig, um
% z.B. Alpha‑Desynchronisation zu analysieren.

%% 5.1 Idee der Short‑Time Fourier Transform (STFT)
% Die STFT berechnet Fourier‑Spektren in gleitenden Zeitfenstern. Jedes Fenster
% liefert ein Spektrum, und zusammen ergeben sie eine Zeit‑Frequenz‑Darstellung.

% Beispiel: Signal mit wechselnder Frequenz
fs_stft = 250;
t_stft = 0:1/fs_stft:5;  % 5 Sekunden
sig1 = sin(2*pi*10*t_stft(1:round(length(t_stft)*0.5)));  % 10 Hz für erste Hälfte
sig2 = sin(2*pi*20*t_stft(round(length(t_stft)*0.5)+1:end));  % 20 Hz für zweite Hälfte
signal_tf = [sig1, sig2];

% STFT mit spectrogram
win_length = round(0.5*fs_stft);  % 500 ms Fenster
overlap    = round(0.4*fs_stft);   % 400 ms Überlappung
nfft       = 512;

[S, F, T, P] = spectrogram(signal_tf, win_length, overlap, nfft, fs_stft);

figure;
imagesc(T, F, 10*log10(P));
axis xy;
xlabel('Zeit (s)');
ylabel('Frequenz (Hz)');
title('Zeit‑Frequenz‑Darstellung (STFT)');
colorbar;
ylim([1 30]);

% Die Funktion `spectrogram` berechnet die STFT. Die Parameter sind:
% - `signal_tf`: das Signal
% - `win_length`: Fensterlänge in Datenpunkten
% - `overlap`: Überlappung zwischen Fenstern
% - `nfft`: Anzahl der FFT‑Punkte
% - `fs_stft`: Samplingrate
%
% Das Ergebnis ist eine Matrix `P` mit Dimensionen [Frequenzen × Zeitfenster].
% Die Farben zeigen die Power: Rot = hohe Power, Blau = niedrige Power.
%
% Du siehst, dass in der ersten Hälfte der Zeit die Power bei 10 Hz hoch ist,
% in der zweiten Hälfte bei 20 Hz. Das zeigt dir, wie sich die Frequenzen über
% die Zeit ändern!

%% 5.2 Fensterlänge und Zeit‑Frequenz‑Trade‑off
% Es gibt einen wichtigen Trade‑off zwischen Zeit‑ und Frequenzauflösung:
%
% - **Längere Fenster**: gute Frequenzauflösung, aber schlechte Zeitauflösung
%   (du siehst nicht genau, wann etwas passiert)
% - **Kürzere Fenster**: gute Zeitauflösung, aber schlechte Frequenzauflösung
%   (du kannst nicht genau zwischen nahen Frequenzen unterscheiden)

% Vergleich: 250 ms vs. 1 s Fenster
win_short = round(0.25*fs_stft);  % 250 ms
win_long  = round(1.0*fs_stft);   % 1 s

[S_short, F_short, T_short, P_short] = spectrogram(signal_tf, win_short, ...
    round(0.2*win_short), nfft, fs_stft);
[S_long, F_long, T_long, P_long] = spectrogram(signal_tf, win_long, ...
    round(0.8*win_long), nfft, fs_stft);

figure;
subplot(2,1,1);
imagesc(T_short, F_short, 10*log10(P_short));
axis xy;
xlabel('Zeit (s)');
ylabel('Frequenz (Hz)');
title('STFT mit 250 ms Fenstern (gute Zeitauflösung)');
colorbar;
ylim([1 30]);

subplot(2,1,2);
imagesc(T_long, F_long, 10*log10(P_long));
axis xy;
xlabel('Zeit (s)');
ylabel('Frequenz (Hz)');
title('STFT mit 1 s Fenstern (gute Frequenzauflösung)');
colorbar;
ylim([1 30]);

% Im oberen Plot (kurze Fenster) siehst du eine gute Zeitauflösung – du kannst
% genau sehen, wann der Wechsel von 10 Hz zu 20 Hz passiert. Aber die
% Frequenzauflösung ist schlechter – die Bänder sind breiter.
%
% Im unteren Plot (lange Fenster) siehst du eine gute Frequenzauflösung – die
% Bänder sind schmaler. Aber die Zeitauflösung ist schlechter – du siehst
% weniger Details in der Zeit.
%
% WICHTIGER HINWEIS: Die Frequenzauflösung ist 1/T, wobei T die Fensterlänge
% in Sekunden ist. Mit 250 ms Fenstern ist die Frequenzauflösung 4 Hz, mit 1 s
% Fenstern ist sie 1 Hz (besser). Aber die Zeitauflösung ist entsprechend
% schlechter.

%% 5.3 Erste Zeit‑Frequenz‑Plots
% Du kannst Zeit‑Frequenz‑Plots auch für komplexere Signale erstellen:

% Beispiel: Signal mit Alpha‑Band (10 Hz), das nach 2 Sekunden abnimmt
t_alpha = 0:1/fs_stft:4;
alpha_signal = sin(2*pi*10*t_alpha);
modulation = ones(size(t_alpha));
modulation(t_alpha >= 2) = 0.3;  % Nach 2 s wird die Amplitude reduziert
signal_alpha_mod = alpha_signal .* modulation;

% STFT
[S_alpha, F_alpha, T_alpha, P_alpha] = spectrogram(signal_alpha_mod, ...
    win_length, overlap, nfft, fs_stft);

figure;
subplot(2,1,1);
plot(t_alpha, signal_alpha_mod);
xlabel('Zeit (s)');
ylabel('Amplitude');
title('Alpha‑Signal mit Modulation (Desynchronisation nach 2 s)');
grid on;

subplot(2,1,2);
imagesc(T_alpha, F_alpha, 10*log10(P_alpha));
axis xy;
xlabel('Zeit (s)');
ylabel('Frequenz (Hz)');
title('Zeit‑Frequenz‑Darstellung');
colorbar;
ylim([1 30]);

% Im oberen Plot siehst du das Signal: Vor 2 Sekunden ist die Amplitude hoch,
% danach niedrig (Alpha‑Desynchronisation). Im unteren Plot siehst du die
% Zeit‑Frequenz‑Darstellung: Vor 2 Sekunden ist die Power bei 10 Hz hoch (rot),
% danach niedrig (blau). Das zeigt dir genau, wann und in welchem Frequenzband
% die Änderung passiert!

%% Zusammenfassung
% In diesem Tutorial hast du gelernt:
%
% 1. **Signale in der Zeitdomäne**: Wie Signale über die Zeit dargestellt
%    werden, und der Unterschied zwischen kontinuierlichen und diskreten Signalen
%
% 2. **Samplingrate und Nyquist‑Frequenz**: Wie die Samplingrate die maximale
%    darstellbare Frequenz bestimmt (Nyquist = fs/2)
%
% 3. **Aliasing**: Was passiert, wenn die Samplingrate zu niedrig ist (hohe
%    Frequenzen erscheinen als niedrigere Frequenzen)
%
% 4. **Frequenzdomäne**: Wie die Fourier‑Transformation ein Signal in seine
%    Frequenzkomponenten zerlegt, und der Unterschied zwischen Amplituden‑ und
%    Leistungsspektrum
%
% 5. **Filtern**: Wie Hochpass‑, Tiefpass‑ und Bandpassfilter funktionieren,
%    und warum wir EEG‑Daten filtern (um Drifts und Rauschen zu entfernen)
%
% 6. **Zeit‑Frequenz‑Analyse**: Wie die STFT zeigt, wie sich Frequenzen über
%    die Zeit ändern, und der Trade‑off zwischen Zeit‑ und Frequenzauflösung
%
% Diese Konzepte sind fundamental für das Verständnis von EEG‑Analysen. Du
% wirst sie später im Blockkurs häufig verwenden, wenn du mit echten EEG‑Daten
% arbeitest.
