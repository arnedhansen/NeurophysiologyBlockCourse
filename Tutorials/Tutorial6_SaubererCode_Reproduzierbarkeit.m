%% Tutorial 6 – Sauberer Code & Reproduzierbarkeit in der EEG‑Analyse
% Dieses optionale Tutorial zeigt Prinzipien für gut strukturierten,
% reproduzierbaren Code in der EEG‑Analyse.
%
% Inhalte:
% 1. Warum saubere Skripte wichtig sind
% 2. Struktur von Analyse‑Skripten
% 3. Schleifen über Subjekte und Bedingungen
% 4. Funktionen schreiben
% 5. Mini‑Projekt: kleine EEG‑Analyse‑Pipeline
% 6. Übungsaufgaben

%% 1. Warum saubere Skripte wichtig sind
% In der Forschung müssen Analysen
% - nachvollziehbar,
% - wiederholbar und
% - erweiterbar
% sein.
%
% Typische Probleme:
% - „Klick‑Analyse“ nur über GUIs
% - Copy‑Paste von Code über viele Dateien
% - unklare Dateinamen und Ordnerstrukturen

%% 2. Struktur von Analyse‑Skripten
% Ein typisches Analyse‑Skript könnte folgende Abschnitte haben:
%
% 1. Konfiguration / Parameter
% 2. Pfade setzen
% 3. Daten laden
% 4. Vorverarbeitung
% 5. Auswertung
% 6. Speicherung der Ergebnisse

%% 2.1 Beispiel: Grundstruktur
% (Hier nur als Illustration. In der Praxis würdest du diesen Teil an den
% Anfang deines Skripts setzen.)

% 1. Konfiguration
projekt_name = "EEG_Blockkurs";
subjekte     = 2:4;   % Beispiel: VP 2–4
bedingungen  = ["kongruent","inkongruent"];

% 2. Pfade setzen (Pfad ggf. anpassen)
pfad_daten    = fullfile("Praxis","data","preprocessed_data");
pfad_ergebnis = fullfile("Ergebnisse", projekt_name);

% 3. Ordner anlegen, falls nicht vorhanden
if ~exist(pfad_ergebnis, "dir")
    mkdir(pfad_ergebnis);
end

%% 3. Schleifen über Subjekte und Bedingungen
% Häufig wollen wir dieselben Analyseschritte für viele Versuchspersonen
% und Bedingungen durchführen. Schleifen vermeiden dabei Copy‑Paste.

for s = 1:length(subjekte)
    subj_id = subjekte(s); %#ok<*NASGU> 
    fprintf("Verarbeite Subjekt %d ...\n", subj_id);
    
    % Beispieldateiname: „gip_sub-00X.mat“
    dateiname = sprintf("gip_sub-%03d.mat", subj_id);
    vollpfad  = fullfile(pfad_daten, dateiname);
    
    if ~isfile(vollpfad)
        warning("Datei %s nicht gefunden, wird übersprungen.", vollpfad);
        continue;
    end
    
    % Daten laden (Beispiel, Struktur anpassen)
    % data = load(vollpfad);
    % EEG  = data.EEG;  % falls Struktur in Variable EEG gespeichert ist
    
    % Hier würden jetzt:
    % - Vorverarbeitungsschritte
    % - Zeit‑Frequenz‑Analysen
    % - etc.
    % folgen.
    
    % Ergebnisse pro Subjekt speichern:
    % save(fullfile(pfad_ergebnis, sprintf('Ergebnis_VP_%03d.mat', subj_id)), ...
    %      'EEG', '-v7.3');
end

%% 3.1 Schleife über Bedingungen
% Wenn die Bedingungen z.B. über Events kodiert sind, können wir innerhalb
% der Subjekt‑Schleife zusätzlich über Bedingungen iterieren.

for s = 1:length(subjekte)
    subj_id = subjekte(s);
    
    for b = 1:length(bedingungen)
        bed = bedingungen(b);
        fprintf("Subjekt %d – Bedingung %s\n", subj_id, bed);
        
        % Hier: Trials für diese Bedingung auswählen,
        % ERP oder Zeit‑Frequenz analysieren usw.
    end
end

%% 4. Funktionen schreiben
% Statt denselben Codeblock mehrfach zu kopieren, schreiben wir
% wiederverwendbare Funktionen.

%% 4.1 Einfache Funktion in einer separaten Datei
% (Diese Funktion müsstest du in einer eigenen Datei speichern,
%  z.B. unter dem Namen „berechne_mittelwert.m“.)
%
% function m = berechne_mittelwert(x)
%     % BERECHNE_MITTELWERT – gibt den Mittelwert eines Vektors zurück
%     %
%     % Eingabe:
%     %   x – numerischer Vektor
%     %
%     % Ausgabe:
%     %   m – Mittelwert von x
%     m = mean(x);
% end
%
% In Skripten kannst du die Funktion dann einfach aufrufen:
%
% daten = [1 2 3 4 5];
% m = berechne_mittelwert(daten);

%% 4.2 Funktion mit mehreren Ausgaben
% Beispiel: Eine Funktion, die Mittelwert UND Standardabweichung berechnet.

% function [m, s] = beschreibe_daten(x)
%     % BESCHREIBE_DATEN – gibt Mittelwert und Standardabweichung zurück
%     m = mean(x);
%     s = std(x);
% end

%% 4.3 Funktion für einen Vorverarbeitungsschritt
% Beispiel: Hochpass‑Filterung eines EEG‑Signals (pseudocode).
%
% function EEG_out = mein_hochpass_filter(EEG_in, f_cutoff)
%     % EEG_IN: EEG‑Struktur
%     % F_CUTOFF: Grenzfrequenz in Hz
%     %
%     % Hier könntest du z.B. pop_eegfiltnew aus EEGLAB verwenden:
%     % EEG_out = pop_eegfiltnew(EEG_in, f_cutoff, []);
%     %
%     % Für dieses Tutorial lassen wir den Inhalt leer oder kommentiert.
%     EEG_out = EEG_in; % Platzhalter
% end

%% 5. Mini‑Projekt: Kleine EEG‑Analyse‑Pipeline (Konzeptuell)
% Ziel: Ein einfaches, aber reproduzierbares Analyse‑Skript für mehrere
% Subjekte und zwei Bedingungen.
%
% Schritte:
% 1. Parameter definieren (Subjekte, Bedingungen, Zeitfenster, Frequenzband)
% 2. Daten laden
% 3. Vorverarbeitung (z.B. Filter, Re‑Referenzierung)
% 4. Epochen für jede Bedingung erstellen
% 5. Metrik berechnen (z.B. mittlere Amplitude oder Leistung)
% 6. Ergebnisse als Tabelle speichern

%% 5.1 Beispiel‑Code‑Skeleton
% (ohne echten EEG‑Code, damit das Skript ohne Daten ausführbar bleibt)

% Parameter
subjekte     = 2:4;
bedingungen  = ["A","B"];
zeitfenster  = [0.3 0.6];   % 300–600 ms
freqband     = [8 12];      % 8–12 Hz (z.B. Alpha)

% Ergebnis‑Speicher
Ergebnisse = [];

for s = 1:length(subjekte)
    subj_id = subjekte(s);
    
    % --- Daten laden (Pseudocode) ---
    % [EEG] = lade_mein_eeg(subj_id);
    
    for b = 1:length(bedingungen)
        bed = bedingungen(b);
        
        % --- Trials für diese Bedingung auswählen (Pseudocode) ---
        % EEG_bed = selektiere_bedingung(EEG, bed);
        
        % --- Metrik berechnen (Pseudocode) ---
        % metr = berechne_metrik(EEG_bed, zeitfenster, freqband);
        metr = rand();  % Platzhalter
        
        % Ergebnis speichern
        Ergebnisse = [Ergebnisse; ...
            table(subj_id, bed, metr, ...
            'VariableNames', {'VP','Bedingung','Metrik'})];
    end
end

Ergebnisse

%% 6. Übungsaufgaben (ohne Lösung im Code)
% Übung 1:
% Erstelle ein Skript, das alle deine Subjekte (z.B. aus dem Praxis‑Ordner)
% automatisch lädt, einen einfachen Vorverarbeitungsschritt durchführt
% (z.B. Hochpassfilter), und die gefilterten Datensätze wieder speichert.
%
% Übung 2:
% Schreibe eine Funktion, die einen EEG‑Datensatz und ein Zeitfenster in ms
% als Eingabe erhält und die mittlere Amplitude in diesem Zeitfenster
% (über alle Trials) als Ausgabe zurückgibt.
%
% Übung 3:
% Baue eine kleine Pipeline, die für jede Versuchsperson und Bedingung
% eine Metrik berechnet (z.B. mittlere Alpha‑Leistung) und die Ergebnisse in
% einer Tabelle speichert, die du anschließend in z.B. R oder Python
% weiterverwenden kannst.

