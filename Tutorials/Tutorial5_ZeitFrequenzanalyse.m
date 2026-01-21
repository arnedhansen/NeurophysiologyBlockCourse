%% Tutorial 5 – Zeit‑Frequenz‑Analyse für Interessierte
% Dieses optionale Tutorial führt in die Zeit‑Frequenz‑Analyse von EEG‑Signalen ein.
%
% Inhalte:
% 1. Motivation: Warum Zeit‑Frequenz?
% 2. STFT und Wavelets – grundlegende Idee
% 3. Zeit‑Frequenz in MATLAB
% 4. Zeit‑Frequenz in EEGLAB
% 5. Kleine Fallstudie
% 6. Übungsaufgaben

%% 1. Motivation: Warum Zeit‑Frequenz?
% ERPs zeigen gut, was im Mittel über Trials und in bestimmten Zeitfenstern
% passiert, aber sie blenden zeitlich variierende Oszillationen aus
% (z.B. Alpha‑Desynchronisation, Theta‑Power‑Anstieg).
%
% Die Zeit‑Frequenz‑Analyse erlaubt es, sowohl die zeitliche als auch die
% frequenzspezifische Dynamik zu betrachten.

% Beispiel: ein Signal mit wechselnder Frequenz
fs   = 250;                   % Samplingrate
t    = 0:1/fs:5;              % 5 Sekunden
sig1 = sin(2*pi*10*t);        % 10 Hz
sig2 = sin(2*pi*20*t);        % 20 Hz

signal = [sig1(1:fs*2.5), sig2(fs*2.5+1:end)];  % 10 Hz, dann 20 Hz

figure;
plot(t, signal);
xlabel('Zeit (s)');
ylabel('Amplitude');
title('Beispiel: Frequenzwechsel von 10 Hz auf 20 Hz');

%% 2. STFT und Wavelets – grundlegende Idee
% STFT (Short‑Time Fourier Transform):
% - Wir berechnen Fourier‑Spektren in gleitenden Zeitfenstern.
% - Jedes Fenster liefert ein Spektrum, zusammen ergeben sie eine
%   Zeit‑Frequenz‑Darstellung.
%
% Wavelets:
% - Ähnliches Prinzip, aber das Fenster ist frequenzabhängig.
% - Bessere Zeitauflösung bei hohen Frequenzen, bessere Frequenzauflösung
%   bei niedrigen Frequenzen.

%% 2.1 Zeit‑Frequenz‑Trade‑off
% Längere Fenster:
% - gute Frequenzauflösung
% - schlechte Zeitauflösung
%
% Kürzere Fenster:
% - gute Zeitauflösung
% - schlechte Frequenzauflösung

%% 3. Zeit‑Frequenz in MATLAB mit spectrogram
% Wir benutzen die eingebaute Funktion spectrogram für eine STFT.

win_length = round(0.5*fs);  % 500 ms Fenster
overlap    = round(0.4*fs);  % 400 ms Überlappung
nfft       = 512;

[S,F,Tspec,P] = spectrogram(signal, win_length, overlap, nfft, fs);

% P enthält die Leistung pro Frequenz und Zeitfenster.

figure;
imagesc(Tspec, F, 10*log10(P));
axis xy;
xlabel('Zeit (s)');
ylabel('Frequenz (Hz)');
title('Zeit‑Frequenz‑Darstellung (STFT, dB)');
colorbar;

% Optional: Frequenzbereich begrenzen (z.B. 1–40 Hz):
ylim([1 40]);

%% 3.1 Parameter verändern und vergleichen
% Probiere verschiedene Fensterlängen aus (z.B. 250 ms vs. 1 s) und beobachte,
% wie sich die Darstellung verändert.
%
% win_length = round(0.25*fs);  % 250 ms
% win_length = round(1.0*fs);   % 1 s

%% 4. Zeit‑Frequenz in EEGLAB
% In EEGLAB gibt es verschiedene Funktionen zur Zeit‑Frequenz‑Analyse, z.B.
% newtimef (oder Nachfolger in neueren Versionen).
%
% Voraussetzung: EEG‑Datensatz mit Epochen (EEG_epo).

% Beispiel (kommentiert, da EEG_epo hier nicht existiert):
%
% kanalname = 'Cz';
% kanal_index = find(strcmpi({EEG_epo.chanlocs.labels}, kanalname));
%
% figure;
% [ersp,itc,powbase,timesout,freqs] = newtimef( ...
%     EEG_epo.data(kanal_index,:,:), ...
%     EEG_epo.pnts, ...
%     [EEG_epo.xmin EEG_epo.xmax]*1000, ...
%     EEG_epo.srate, ...
%     0, ...         % 0 = STFT‑ähnlich; Zahl = Anzahl Zyklen (Wavelets)
%     'baseline',[-200 0], ...
%     'freqs',[2 40], ...
%     'title',['ERSP ' kanalname]);

%% 4.1 ERSP und ITC
% ERSP (Event‑Related Spectral Perturbation):
% - zeigt Veränderungen der mittleren Leistung im Vergleich zu einer
%   Baseline (z.B. Alpha‑Desynchronisation).
%
% ITC (Inter‑Trial Coherence):
% - misst, wie stark die Phase über Trials hinweg synchron ist.

%% 5. Kleine Fallstudie (synthetisches Beispiel)
% Wir erzeugen ein künstliches Signal mit einem Alpha‑Band (10 Hz),
% das nach einem Ereignis (z.B. Stimulus) kurzzeitig abnimmt
% (Desynchronisation).

fs   = 250;
t    = -1:1/fs:2;          % -1 bis 2 s
alpha = sin(2*pi*10*t);    % 10 Hz

% Modulation: vor 0 s volle Amplitude, danach gedämpft
modulation = ones(size(t));
modulation(t >= 0 & t <= 1) = 0.3;

signal_alpha = alpha .* modulation;

figure;
plot(t, signal_alpha);
xlabel('Zeit (s)');
ylabel('Amplitude');
title('Künstliche Alpha‑Desynchronisation nach Stimulus');
grid on;

% Zeit‑Frequenz‑Darstellung:
win_length = round(0.5*fs);
overlap    = round(0.4*fs);
nfft       = 512;

[S,F,Tspec,P] = spectrogram(signal_alpha, win_length, overlap, nfft, fs);

figure;
imagesc(Tspec + t(1), F, 10*log10(P));
axis xy;
xlabel('Zeit (s)');
ylabel('Frequenz (Hz)');
title('Zeit‑Frequenz‑Darstellung des Alpha‑Signals');
colorbar;
ylim([1 30]);

%% 6. Übungsaufgaben (ohne Lösung im Code)
% Übung 1:
% Erzeuge ein Signal mit zwei Frequenzbändern (z.B. 6 Hz und 15 Hz),
% die in unterschiedlichen Zeitfenstern aktiv sind, und berechne die
% Zeit‑Frequenz‑Darstellung mit spectrogram. Variiere Fensterlänge und
% Überlappung.
%
% Übung 2:
% Verwende echte EEG‑Daten (z.B. aus dem Praxis‑Teil) und berechne eine
% Zeit‑Frequenz‑Darstellung für einen interessierenden Kanal. Nutze dabei
% newtimef in EEGLAB (oder eine ähnliche Funktion in deiner Version).
%
% Übung 3:
% Wähle ein Frequenzband (z.B. 8–12 Hz) und einen Zeitbereich (z.B. 300–600 ms)
% und berechne die mittlere Leistung in diesem Zeit‑Frequenz‑Fenster für
% zwei unterschiedliche Bedingungen. Diskutiere, wie man diese Unterschiede
% interpretieren könnte.

