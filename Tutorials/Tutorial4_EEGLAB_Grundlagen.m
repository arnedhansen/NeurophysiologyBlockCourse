%% Tutorial 4 – Arbeiten mit EEG‑Daten in EEGLAB (Grundlagen)
% Dieses optionale Tutorial gibt einen praktischen Einstieg in EEGLAB.
%
% Inhalte:
% 1. Überblick: Was ist EEGLAB?
% 2. Daten laden und inspizieren
% 3. Ereignisse und Epochen
% 4. Grundlagen der Vorverarbeitung
% 5. Einfache ERPs
% 6. Übungsaufgaben

%% 1. Überblick: Was ist EEGLAB?
% EEGLAB ist ein MATLAB‑Toolbox für die Analyse von EEG‑Daten.
% Es bietet:
% - eine grafische Benutzeroberfläche (GUI)
% - Komfortfunktionen zum Laden, Vorverarbeiten und Analysieren von EEG
% - eine Datenstruktur (EEG‑Struct), die alle relevanten Infos enthält
%
% In diesem Tutorial verwenden wir die EEGLAB‑Funktionen hauptsächlich
% in Skripten, nicht über die GUI.
%
% WICHTIG: Bevor du dieses Tutorial ausführst, füge den Ordner „eeglab2021.1“
% zum MATLAB‑Pfad hinzu (z.B. mit „Add with Subfolders“ in MATLAB)
% oder verwende addpath/genpath im Skript.

%% 1.1 EEGLAB starten (falls nötig)
% Wenn du EEGLAB noch nicht gestartet hast, kannst du dies mit:

% Pfad ggf. anpassen:
% addpath(genpath('Pfad/zum/Ordner/eeglab2021.1'));

% Dann EEGLAB starten:
% eeglab;

%% 1.2 Die EEG‑Struktur (nur zur Illustration)
% Eine typische EEG‑Struktur enthält u.a.:
% - EEG.data      : EEG‑Daten (Kanäle x Zeitpunkte x Trials)
% - EEG.srate     : Samplingrate
% - EEG.nbchan    : Anzahl der Kanäle
% - EEG.pnts      : Anzahl der Zeitpunkte pro Trial
% - EEG.trials    : Anzahl der Trials (1 bei kontinuierlichen Daten)
% - EEG.times     : Zeitvektor (in ms)
% - EEG.chanlocs  : Kanalinformation (Name, Position, ...)
% - EEG.event     : Event‑Informationen (Trigger, Reaktion u.a.)

%% 2. Daten laden und inspizieren
% Für dieses Tutorial kannst du die EEGLAB‑Beispieldaten verwenden.
% Hier wird angenommen, dass du im Ordner eeglab2021.1/sample_data bist.

% Beispiel: Daten laden (Pfad ggf. anpassen)
% EEG = pop_loadset('filename','eeglab_data.set', ...
%                   'filepath','../eeglab2021.1/sample_data/');
% EEG = eeg_checkset(EEG);

% Alternativ kannst du deine eigenen Daten verwenden, z.B. aus dem Ordner
% „Praxis/data/raw_data“ dieser Repository.

%% 2.1 Grundlegende Informationen anzeigen
% Wenn ein EEG‑Datensatz geladen ist, kannst du dir die wichtigsten
% Informationen anschauen.

% EEG
% EEG.srate
% EEG.nbchan
% size(EEG.data)

%% 2.2 Rohsignal plotten
% EEGLAB stellt bereits Plot‑Funktionen bereit.

% pop_eegplot(EEG, 1, 1, 1);

% Hinweis: Dieser Befehl öffnet ein interaktives Fenster zur Betrachtung
% des Rohsignals.

%% 2.3 Power‑Spektrum plotten
% Ein einfaches Leistungsspektrum kann mit pop_spectopo erstellt werden.

% figure;
% pop_spectopo(EEG, 1, [], 'EEG' , 'freqrange',[1 50],'electrodes','off');

%% 3. Ereignisse und Epochen
% Die meisten EEG‑Experimente arbeiten ereignisbezogen (Event‑Related),
% z.B. Stimulus‑Onset, Antwort, Feedback usw.

%% 3.1 Events inspizieren
% Events sind in EEG.event gespeichert.

% EEG.event(1:5)

% Typische Felder:
% - type: Event‑Typ (z.B. Stimuluscode)
% - latency: Zeitpunkt im Datensatz

%% 3.2 Epochen definieren
% Wir schneiden aus kontinuierlichen Daten Zeitfenster um bestimmte Events.
%
% Beispiel: Epochen von -200 ms bis 800 ms relativ zu Event‑Typ "square".

% EEG_epo = pop_epoch(EEG, {'square'}, [-0.2 0.8]);
% EEG_epo = eeg_checkset(EEG_epo);

% Baseline‑Korrektur:
% EEG_epo = pop_rmbase(EEG_epo, [-200 0]);

%% 3.3 Artefakte markieren (kurz)
% Es gibt viele Möglichkeiten, Artefakte zu erkennen (Augenbewegungen,
% Muskelartefakte, etc.). Hier nur ein einfacher, automatischer Ansatz:

% EEG_epo = pop_eegthresh(EEG_epo,1,[1:EEG_epo.nbchan],-100,100,...
%                         EEG_epo.xmin, EEG_epo.xmax,0,1);

% Dies markiert Epochen mit Amplituden außerhalb des Bereichs [-100 100] µV.

%% 4. Grundlagen der Vorverarbeitung
% Typische Schritte:
% - Re‑Referenzierung
% - Filtern
% - (Optional: ICA, Kanal‑Interpolation, etc.)

%% 4.1 Re‑Referenzierung
% Beispiel: Durchschnittsreferenz:

% EEG_reref = pop_reref(EEG, []);
% EEG_reref = eeg_checkset(EEG_reref);

%% 4.2 Filtern
% Beispiel: Hochpassfilter bei 0.1 Hz, Tiefpass bei 40 Hz.

% EEG_filt = pop_eegfiltnew(EEG_reref, 0.1, []);  % Hochpass
% EEG_filt = pop_eegfiltnew(EEG_filt, [], 40);    % Tiefpass

%% 4.3 Speichern eines Datensatzes
% Du kannst Zwischenergebnisse als .set‑Dateien speichern.

% EEG_filt = pop_saveset(EEG_filt, 'filename','mein_datensatz_filt.set', ...
%                        'filepath','Pfad/zum/speichern/');

%% 5. Einfache ERPs
% Event‑Related Potentials (ERPs) entstehen durch Mittelung über Trials,
% die dasselbe Ereignis enthalten.

%% 5.1 ERP berechnen (über Epochen)
% Wir gehen davon aus, dass EEG_epo bereits Epochen enthält.

% ERP = mean(EEG_epo.data, 3);  % Mittelung über Trials

% ERP hat jetzt Dimensionen: Kanäle x Zeitpunkte

%% 5.2 ERP plotten
% Beispiel: einen Kanal (z.B. Cz) auswählen.

% kanalname = 'Cz';
% kanal_index = find(strcmpi({EEG_epo.chanlocs.labels}, kanalname));
%
% figure;
% plot(EEG_epo.times, squeeze(ERP(kanal_index, :)));
% xlabel('Zeit (ms)');
% ylabel('Amplitude (\muV)');
% title(['ERP an Kanal ' kanalname]);
% grid on;

%% 5.3 Vergleich zwischen Bedingungen (kurzer Ausblick)
% In einem echten Experiment gibt es mehrere Bedingungen (z.B. kongruent vs.
% inkongruent). Man würde für jede Bedingung ein ERP berechnen und dann
% z.B. die Differenzkurve betrachten.
%
% In EEGLAB kann man dies z.B. über verschiedene Datensätze oder über
% event‑basierte Selektion lösen.

%% 6. Übungsaufgaben (ohne Lösung im Code)
% Übung 1:
% Lade einen der Beispiel‑EEG‑Datensätze (oder deine eigenen Daten) in
% EEGLAB und inspiziere die Struktur EEG im Command Window.
%
% Übung 2:
% Erzeuge Epochen für einen bestimmten Event‑Typ (z.B. 'square') im Intervall
% von -200 bis 800 ms und führe eine Baseline‑Korrektur durch.
%
% Übung 3:
% Re‑referenziere den Datensatz auf Durchschnittsreferenz und filtere ihn mit
% einem Hochpass von 0.1 Hz und einem Tiefpass von 40 Hz. Speichere den
% gefilterten Datensatz als neue .set‑Datei.
%
% Übung 4:
% Berechne ein ERP für einen interessierenden Kanal (z.B. Cz oder Pz) und
% plotte die Wellenform. Markiere im Plot den Nullpunkt (Stimulus‑Onset)
% und diskutiere kurz, welche Komponenten du eventuell erkennen kannst.

