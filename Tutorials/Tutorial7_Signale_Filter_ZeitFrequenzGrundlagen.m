%% Tutorial 7 – Signale, Aliasing, Filter und Zeit‑Frequenz‑Analyse
% Dieses optionale Tutorial vertieft die Grundlagen der digitalen
% Signalverarbeitung für EEG‑Signale.
%
% Inhalte:
% 1. Signale in der Zeitdomäne
% 2. Aliasing verstehen
% 3. Signale in der Frequenzdomäne
% 4. Filtern von Signalen
% 5. Kurze Einführung Zeit‑Frequenz‑Analyse
% 6. Übungsaufgaben mit EEG‑ähnlichen Signalen

%% 1. Signale in der Zeitdomäne
% In der Zeitdomäne betrachten wir, wie sich ein Signal über die Zeit
% verändert. Beim EEG ist das z.B. die Spannungsänderung in µV über die Zeit.

fs  = 250;          % Samplingrate in Hz
t   = 0:1/fs:2;     % 2 Sekunden
sig = sin(2*pi*10*t);  % 10‑Hz‑Sinus

figure;
plot(t, sig);
xlabel('Zeit (s)');
ylabel('Amplitude');
title('10‑Hz‑Sinussignal in der Zeitdomäne');
grid on;

%% 1.1 Was ist ein Signal? Beispiele aus EEG
% Beispiele für Signale:
% - Rohes EEG an einem Kanal über mehrere Sekunden
% - ERPs (gemittelte Signale über Trials)
% - Zeitverläufe spezifischer Frequenzbänder (z.B. Alpha‑Power über Zeit)

%% 1.2 Diskrete vs. kontinuierliche Signale
% Kontinuierlich:
% - Signal ist zu jedem Zeitpunkt definiert (theoretisch unendlich fein).
%
% Diskret:
% - Signal ist nur zu bestimmten Zeitpunkten definiert, z.B. alle 4 ms
%   bei einer Samplingrate von 250 Hz.

%% 1.3 Samplingrate und Nyquist‑Frequenz
% Die Samplingrate (fs) gibt an, wie viele Messpunkte pro Sekunde
% aufgezeichnet werden. Die Nyquist‑Frequenz ist fs/2 und ist die
% maximale Frequenz, die ohne Aliasing korrekt dargestellt werden kann.

fs1 = 100;          % 100 Hz Samplingrate
nyquist1 = fs1/2

fs2 = 500;          % 500 Hz Samplingrate
nyquist2 = fs2/2

%% 2. Aliasing verstehen
% Aliasing tritt auf, wenn die Samplingrate zu niedrig ist, um die
% im Signal enthaltenen hohen Frequenzen korrekt abzubilden.

%% 2.1 Intuition: zu selten abtasten
% Wir betrachten ein 30‑Hz‑Signal mit unterschiedlicher Samplingrate.

f_sig = 30;   % Signal‑Frequenz 30 Hz

fs_low  = 40;                 % zu niedrige Samplingrate
t_low   = 0:1/fs_low:1;
sig_low = sin(2*pi*f_sig*t_low);

fs_high  = 200;               % ausreichend hohe Samplingrate
t_high   = 0:1/fs_high:1;
sig_high = sin(2*pi*f_sig*t_high);

figure;
subplot(2,1,1);
stem(t_low, sig_low, 'filled');
hold on;
plot(t_high, sig_high, 'r:');
hold off;
xlabel('Zeit (s)');
ylabel('Amplitude');
title('30 Hz bei fs = 40 Hz (Aliasing‑Gefahr)');
legend('gesampelte Punkte','„wahres“ Signal');

subplot(2,1,2);
plot(t_high, sig_high);
xlabel('Zeit (s)');
ylabel('Amplitude');
title('30 Hz bei fs = 200 Hz (gut abgetastet)');

%% 2.2 Aliasing‑Simulation in MATLAB
% Wir simulieren eine höhere Frequenz (z.B. 80 Hz) bei fs = 100 Hz
% und betrachten, wie sie in der diskreten Darstellung erscheint.

fs_alias = 100;
f_high   = 80;
t_alias  = 0:1/fs_alias:1;
sig_alias = sin(2*pi*f_high*t_alias);

figure;
stem(t_alias, sig_alias, 'filled');
xlabel('Zeit (s)');
ylabel('Amplitude');
title('80 Hz bei fs = 100 Hz (erscheint als niedrigere Frequenz)');

%% 2.3 Praktische Konsequenzen für EEG‑Aufnahmen
% - Die Samplingrate sollte mindestens doppelt so hoch sein wie die
%   höchste interessierende Frequenz.
% - In der Praxis wird oft deutlich höher gesampelt (z.B. 500 oder 1000 Hz),
%   um Verarbeitungsspielraum zu haben.
% - Anti‑Aliasing‑Filter vor der Digitalisierung sind wichtig.

%% 3. Signale in der Frequenzdomäne
% In der Frequenzdomäne betrachten wir, wie stark verschiedene Frequenzen
% im Signal vertreten sind.

fs  = 250;
t   = 0:1/fs:2;
sig = sin(2*pi*8*t) + 0.5*sin(2*pi*20*t);  % 8 Hz + 20 Hz

figure;
plot(t, sig);
xlabel('Zeit (s)');
ylabel('Amplitude');
title('Signal mit 8 Hz und 20 Hz in der Zeitdomäne');

%% 3.1 Sinuswellen und Frequenzen
% Jede Sinuswelle ist durch Frequenz, Amplitude und Phase definiert.
% Viele Signale lassen sich als Summe von Sinuswellen darstellen.

%% 3.2 Fourier‑Transformation in MATLAB (fft)
N    = length(sig);
Y    = fft(sig);
P2   = abs(Y/N);          % zweiseitiges Spektrum
P1   = P2(1:N/2+1);       % einseitiges Spektrum
P1(2:end-1) = 2*P1(2:end-1);
f    = fs*(0:(N/2))/N;

figure;
plot(f, P1);
xlabel('Frequenz (Hz)');
ylabel('Amplitude');
title('Amplitudenspektrum des Signals');
xlim([0 50]);
grid on;

%% 3.3 Amplituden‑ und Leistungsspektren
% Amplitudenspektrum:
% - zeigt die Stärke jeder Frequenzkomponente.
%
% Leistungsspektrum (Power):
P_power = P1.^2;

figure;
plot(f, P_power);
xlabel('Frequenz (Hz)');
ylabel('Leistung');
title('Leistungsspektrum des Signals');
xlim([0 50]);
grid on;

%% 4. Filtern von Signalen
% Filtern bedeutet, bestimmte Frequenzbereiche zu dämpfen oder zu entfernen.
% Typische Filter im EEG:
% - Hochpass (entfernt sehr langsame Schwankungen)
% - Tiefpass (entfernt sehr schnelle Schwankungen/Rauschen)
% - Bandpass (lässt nur einen Frequenzbereich durch)

%% 4.1 Warum filtern wir EEG?
% - Entfernen von Drift (langsamen Trends)
% - Reduzierung von Hochfrequenz‑Rauschen (z.B. Muskelartefakte)
% - Isolierung bestimmter Frequenzbänder (z.B. Alpha 8–12 Hz)

%% 4.2 Hochpass‑, Tiefpass‑, Bandpass‑Filter (konzeptionell)
% In MATLAB/EEGLAB verwendet man meist fertige Funktionen, z.B.
% - designfilt, filtfilt
% - pop_eegfiltnew (EEGLAB)
%
% Hier zeigen wir ein einfaches Beispiel mit designfilt + filtfilt.

fs = 250;
t  = 0:1/fs:5;
% Signal: 1 Hz (langsam) + 10 Hz (schneller)
sig = sin(2*pi*1*t) + sin(2*pi*10*t);

% Hochpassfilter bei 2 Hz (dämpft 1 Hz)
hpFilt = designfilt('highpassiir','FilterOrder',4, ...
    'HalfPowerFrequency',2,'SampleRate',fs);
sig_hp = filtfilt(hpFilt, sig);

figure;
subplot(2,1,1);
plot(t, sig);
title('Originalsignal (1 Hz + 10 Hz)');
xlabel('Zeit (s)');
ylabel('Amplitude');

subplot(2,1,2);
plot(t, sig_hp);
title('Hochpassgefiltertes Signal (Grenzfrequenz 2 Hz)');
xlabel('Zeit (s)');
ylabel('Amplitude');

%% 4.3 Einfache Filter‑Beispiele in MATLAB
% Analog könnten Tiefpass oder Bandpass‑Filter definiert werden:
%
% lpFilt = designfilt('lowpassiir','FilterOrder',4, ...
%     'HalfPowerFrequency',30,'SampleRate',fs);
%
% bpFilt = designfilt('bandpassiir','FilterOrder',4, ...
%     'HalfPowerFrequency1',8,'HalfPowerFrequency2',12, ...
%     'SampleRate',fs);   % 8–12 Hz (Alpha‑Band)
%
% sig_lp = filtfilt(lpFilt, sig);
% sig_bp = filtfilt(bpFilt, sig);

%% 5. Kurze Einführung Zeit‑Frequenz‑Analyse
% Statt ein einziges Spektrum für das ganze Signal zu berechnen, wollen
% wir sehen, wie sich die Frequenzzusammensetzung über die Zeit ändert.

%% 5.1 Idee der Short‑Time Fourier Transform (STFT)
% - Das Signal wird in überlappende Zeitfenster aufgeteilt.
% - Für jedes Fenster wird eine Fourier‑Transformation berechnet.
% - Die Ergebnisse werden zu einer Zeit‑Frequenz‑Darstellung kombiniert.

%% 5.2 Fensterlänge und Zeit‑Frequenz‑Trade‑off
% Längeres Fenster:
% - bessere Frequenzauflösung
% - schlechtere Zeitauflösung
%
% Kürzeres Fenster:
% - bessere Zeitauflösung
% - schlechtere Frequenzauflösung

%% 5.3 Erste Zeit‑Frequenz‑Plots mit spectrogram
fs = 250;
t  = 0:1/fs:5;
sig1 = sin(2*pi*8*t);
sig2 = sin(2*pi*20*t);
signal = [sig1(1:fs*2.5), sig2(fs*2.5+1:end)];

win_length = round(0.5*fs);   % 500 ms
overlap    = round(0.4*fs);   % 400 ms
nfft       = 512;

[S,F,Tspec,P] = spectrogram(signal, win_length, overlap, nfft, fs);

figure;
imagesc(Tspec, F, 10*log10(P));
axis xy;
xlabel('Zeit (s)');
ylabel('Frequenz (Hz)');
title('Zeit‑Frequenz‑Darstellung (STFT, dB)');
colorbar;
ylim([1 40]);

%% 6. Übungsaufgaben mit EEG‑ähnlichen Signalen (ohne Lösung im Code)
% 6.1 Erzeugen künstlicher Signale (z.B. Alpha, Beta)
% Erzeuge ein Signal mit zwei Frequenzbändern (z.B. 10 Hz und 20 Hz),
% die in unterschiedlichen Zeitintervallen aktiv sind. Visualisiere das
% Signal in der Zeitdomäne und in der Frequenzdomäne (fft).
%
% 6.2 Aliasing nachstellen
% Erzeuge ein hochfrequentes Sinussignal (z.B. 60 Hz) und sampel es mit
% verschiedenen Samplingraten (z.B. 100 Hz, 200 Hz, 500 Hz). Untersuche,
% wie sich die Darstellung im Zeitverlauf verändert und identifiziere
% Alias‑Frequenzen.
%
% 6.3 Spektren vergleichen (mit/ohne Rauschen, vor/nach Filter)
% Erzeuge ein Signal mit Alpha‑Band (8–12 Hz) und füge Rauschen hinzu.
% Vergleiche das Leistungsspektrum vor und nach dem Anwenden eines
% Bandpass‑Filters (8–12 Hz). Diskutiere, was sich verändert und warum.

