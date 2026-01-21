%% Tutorial 3 – Datenstrukturen in MATLAB
% Dieses optionale Tutorial vertieft den Umgang mit Datenstrukturen in MATLAB,
% wie sie später in der EEG‑Analyse nützlich sind.
%
% Inhalte:
% 1. Warum Datenstrukturen wichtig sind
% 2. Strukturen (struct)
% 3. Zell‑Arrays (cell)
% 4. Tabellen (table) für Verhaltensdaten
% 5. Kleine EEG‑Studie modellieren
% 6. Übungsaufgaben

%% 1. Warum Datenstrukturen wichtig sind
% In der EEG‑Analyse arbeiten wir mit komplexen Daten:
% - Messdaten (Zeit x Kanal x Versuch)
% - Metadaten (Subjekt, Bedingung, Alter, ... )
% - Ereignisse (Trigger, Reaktionszeiten, ...)
%
% MATLAB bietet verschiedene Datentypen, um diese Informationen sinnvoll
% zu organisieren: Vektoren, Matrizen, Strukturen, Zell‑Arrays und Tabellen.
%
% In diesem Tutorial konzentrieren wir uns auf:
% - struct
% - cell
% - table

% Kurze Wiederholung: normale Matrizen
reaktionszeiten = [520 480 510 495];   % in Millisekunden
genauigkeit     = [1   0   1   1  ];   % 1 = korrekt, 0 = falsch

mittelwert_rt = mean(reaktionszeiten)
mittelwert_acc = mean(genauigkeit)

%% 2. Strukturen (struct)
% Strukturen erlauben es, unterschiedliche Informationen unter einem Namen
% mit sogenannten Feldern zu speichern. Das ist vergleichbar mit einem
% „Ordner“ für eine Versuchsperson.

%% 2.1 Einfache Strukturen erstellen
% Wir erstellen eine Struktur für eine Versuchsperson.

vp1.id        = 1;
vp1.alter     = 23;
vp1.geschlecht = "w";
vp1.bedingung = "Stroop_kongruent";
vp1.reaktionszeiten = [520 480 510 495];
vp1.genauigkeit     = [1   0   1   1  ];

vp1   % Ausgabe der Struktur im Command Window

%% 2.2 Auf Felder zugreifen und ändern
% Auf Felder greift man mit Punktnotation zu.

vp1.alter
vp1.reaktionszeiten

% Feld ändern:
vp1.alter = 24;

% Neues Feld hinzufügen:
vp1.handedness = "rechts";

%% 2.3 Verschachtelte Strukturen
% Strukturen können wiederum andere Strukturen als Felder enthalten.

vp1.demografie.alter      = 24;
vp1.demografie.geschlecht = "w";

vp1.experiment.bedingung  = "Stroop_kongruent";
vp1.experiment.session    = 1;

vp1.demografie
vp1.experiment

%% 2.4 Beispiel: Mini‑EEG‑Struktur
% In EEGLAB werden EEG‑Daten in einer großen Struktur `EEG` gespeichert.
% Wir bauen eine stark vereinfachte Version nach.

EEG_mini.srate   = 250;                  % Samplingrate in Hz
EEG_mini.chanlocs = ["Fz","Cz","Pz"];    % Kanalnamen
EEG_mini.data    = randn(3, 2500);       % 3 Kanäle x 2500 Zeitpunkte
EEG_mini.times   = (0:2499) / EEG_mini.srate * 1000; % Zeit in ms

size(EEG_mini.data)

%% 3. Zell‑Arrays (cell)
% Zell‑Arrays erlauben, Elemente verschiedener Größe oder Typs in einer
% „Matrix“ zu speichern. Der Zugriff erfolgt mit geschweiften Klammern {}.

%% 3.1 Zell‑Arrays erstellen
% Beispiel: verschiedene Instruktionstexte

instruktionen = { ...
    "Bitte so schnell und genau wie möglich antworten."; ...
    "Machen Sie zwischendurch Pausen, wenn Sie müde werden."; ...
    "Fixieren Sie den Punkt in der Bildschirmmitte."};

instruktionen{1}

%% 3.2 Zell‑Arrays in der EEG‑Analyse
% Wir können z.B. pro Bedingung eine unterschiedliche Anzahl an Trials
% haben und die Reaktionszeiten in einem Zell‑Array speichern.

rt_bedingung = cell(1,3);  % 3 Bedingungen

rt_bedingung{1} = [520 480 510 495];      % Bedingung 1
rt_bedingung{2} = [610 590 620];          % Bedingung 2
rt_bedingung{3} = [700 710 690 705 695];  % Bedingung 3

% Anzahl der Trials pro Bedingung
anzahl_trials = cellfun(@length, rt_bedingung)

%% 3.3 Zugriff auf Elemente
% WICHTIG: runde Klammern () vs. geschweifte Klammern {}

rt_bed1_cell = rt_bedingung(1)    % gibt eine 1x1 Zelle zurück
rt_bed1_vec  = rt_bedingung{1}    % gibt den Zahlenvektor zurück

mittelwerte_rt = cellfun(@mean, rt_bedingung)

%% 4. Tabellen (table) für Verhaltensdaten
% Tabellen sind praktisch, um Versuchspersonen‑ und Versuchs‑Daten in einer
% Form ähnlich wie in Excel zu organisieren.

%% 4.1 Tabellen erstellen

vp_id   = [1; 2; 3; 4];
alter   = [23; 25; 22; 30];
bedingung = ["A"; "A"; "B"; "B"];
mittel_rt = [500; 520; 540; 560];

T = table(vp_id, alter, bedingung, mittel_rt, ...
    'VariableNames', {'VP','Alter','Bedingung','Mittel_RT'});

T

%% 4.2 Filtern und sortieren
% Nur Bedingung A:

T_A = T(T.Bedingung == "A", :)

% Nach Reaktionszeit sortieren:

T_sort = sortrows(T, "Mittel_RT", "ascend")

%% 4.3 Tabellen mit weiteren Infos kombinieren
% Angenommen, wir haben eine zweite Tabelle mit z.B. Fragebogenwerten.

fragebogen = table([1;2;3;4], [12;18;15;10], ...
    'VariableNames', {'VP','Stress_Skala'});

fragebogen

% Tabellen anhand der VP‑ID zusammenführen:

T_merged = join(T, fragebogen, 'Keys', 'VP')

%% 5. Kleine EEG‑Studie modellieren
% Wir erstellen jetzt eine Datenstruktur für mehrere Versuchspersonen.

anzahl_vp = 3;
vp = struct();  % leere Struktur

for i = 1:anzahl_vp
    vp(i).id        = i;
    vp(i).alter     = randi([20 35]);
    vp(i).bedingung = randsample(["A","B"],1);
    vp(i).rt        = 400 + randn(1,20)*30;  % 20 Trials
end

vp

% Mittelwerte pro VP:

for i = 1:anzahl_vp
    fprintf("VP %d (Bedingung %s): mittlere RT = %.1f ms\n", ...
        vp(i).id, vp(i).bedingung, mean(vp(i).rt));
end

%% 5.1 Schleife über alle Versuchspersonen
% Wir können jetzt z.B. eine Tabelle mit den Ergebnissen erstellen.

vp_id   = (1:anzahl_vp)';
alter   = arrayfun(@(x)x.alter, vp)';
bed     = string({vp.bedingung})';
mittel_rt = arrayfun(@(x)mean(x.rt), vp)';

ErgebnisTabelle = table(vp_id, alter, bed, mittel_rt, ...
    'VariableNames', {'VP','Alter','Bedingung','Mittel_RT'})

%% 6. Übungsaufgaben (ohne Lösung im Code)
% Übung 1:
% Erstelle eine Struktur für 5 Versuchspersonen mit den Feldern
% id, alter, bedingung, rt (Vektor mit 30 Trials).
% Berechne für jede VP die mittlere RT und speichere sie in einem neuen
% Feld mittel_rt.
%
% Übung 2:
% Speichere für jede Bedingung die Reaktionszeiten in einem Zell‑Array,
% so dass du die mittlere RT pro Bedingung mit cellfun berechnen kannst.
%
% Übung 3:
% Erstelle eine Tabelle mit allen Versuchspersonen, füge ein weiteres Feld
% hinzu (z.B. Fragebogenwert), und filtere die Tabelle nach einer bestimmten
% Bedingung.

