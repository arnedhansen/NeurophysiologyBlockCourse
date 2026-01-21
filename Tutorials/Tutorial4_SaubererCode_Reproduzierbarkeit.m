%% Tutorial 4 – Sauberer Code & Reproduzierbarkeit
% Dieses optionale Tutorial zeigt dir Prinzipien für gut strukturierten,
% reproduzierbaren Code. Diese Fähigkeiten sind wichtig, wenn du später im
% Blockkurs mit echten EEG‑Daten arbeitest.
%
% Inhalte:
% 
% - 0. Einführung
% - 1. Warum saubere Skripte wichtig sind
% - 2. Struktur von Analyse‑Skripten
%   - 2.1 Beispiel: Grundstruktur
% - 3. Schleifen über Subjekte und Bedingungen
%   - 3.1 Schleife über Subjekte
%   - 3.2 Verschachtelte Schleifen: Subjekte und Bedingungen
% - 4. Funktionen schreiben
%   - 4.1 Einfache Funktion
%   - 4.2 Funktion mit mehreren Ausgaben
%   - 4.3 Funktion für einen Vorverarbeitungsschritt
% - 5. Mini‑Projekt: kleine Analyse‑Pipeline
%   - 5.1 Beispiel‑Code‑Skeleton
%   - 5.2 Tipps für gute Pipeline‑Struktur
% - 6. Fehlerbehandlung
%   - 6.1 try‑catch für robuste Skripte
%   - 6.2 warning vs. error
% - 7. Debugging‑Tipps
%   - 7.1 Ausgaben mit disp und fprintf
%   - 7.2 Timing mit tic und toc
%   - 7.3 Workspace inspizieren

%% 0. Einführung
% Bisher hast du in den Tutorials hauptsächlich kurze Code‑Beispiele gesehen,
% die einzelne Konzepte demonstrieren. In der Praxis wirst du aber längere
% Skripte schreiben, die mehrere Schritte nacheinander ausführen: Daten laden,
% verarbeiten, analysieren und Ergebnisse speichern.
%
% In diesem Tutorial lernst du, wie du solche Skripte gut strukturierst, damit
% sie:
% - nachvollziehbar sind (du verstehst auch nach Wochen noch, was der Code macht)
% - wiederholbar sind (du kannst die Analyse später nochmal durchführen)
% - erweiterbar sind (du kannst leicht neue Subjekte oder Bedingungen hinzufügen)
%
% Diese Tutorials sind so gestaltet, dass du nicht alles auswendig lernen musst.
% Vielmehr geht es darum, ein grundlegendes Verständnis dafür zu entwickeln,
% wie guter Code strukturiert ist. Du wirst später im Blockkurs viele
% Gelegenheiten haben, das Gelernte anzuwenden.

%% 1. Warum saubere Skripte wichtig sind
% Stelle dir vor, du hast vor drei Monaten eine Analyse durchgeführt und
% möchtest sie jetzt nochmal wiederholen oder erweitern. Wenn dein Code
% unübersichtlich ist, wirst du Schwierigkeiten haben, zu verstehen, was genau
% du gemacht hast.
%
% Typische Probleme bei schlecht strukturiertem Code:
%
% - "Klick‑Analyse" nur über GUIs: Du hast alles per Mausklick gemacht, aber
%   keine Aufzeichnung, welche Schritte du durchgeführt hast
% - Copy‑Paste von Code: Du hast denselben Codeblock 10‑mal kopiert und
%   jedes Mal leicht verändert – wenn du einen Fehler findest, musst du ihn
%   10‑mal korrigieren
% - Unklare Dateinamen und Ordnerstrukturen: Du weisst nicht mehr, welche Datei
%   welche Version der Daten enthält
%
% Guter Code vermeidet diese Probleme, indem er:
%
% - alle Schritte dokumentiert (mit Kommentaren)
% - wiederholbare Operationen in Schleifen oder Funktionen auslagert
% - klare Struktur hat (Parameter am Anfang, dann Verarbeitung, dann Speicherung)

%% 2. Struktur von Analyse‑Skripten
% Ein typisches Analyse‑Skript sollte folgende Abschnitte haben:
%
% 1. **Konfiguration / Parameter**: Alle wichtigen Werte werden am Anfang
%    definiert (z.B. welche Subjekte, welche Bedingungen, welche Zeitfenster)
% 
% 2. **Pfade setzen**: Wo liegen die Daten? Wo sollen Ergebnisse gespeichert werden?
% 
% 3. **Daten laden**: Daten werden geladen (oft in einer Schleife über Subjekte)
% 
% 4. **Vorverarbeitung**: Daten werden bereinigt, gefiltert, etc.
% 
% 5. **Auswertung**: Die eigentliche Analyse wird durchgeführt
% 
% 6. **Speicherung der Ergebnisse**: Ergebnisse werden gespeichert (als MAT‑Dateien,
%    Tabellen, Plots, etc.)

%% 2.1 Beispiel: Grundstruktur
% Hier siehst du ein Beispiel für die Grundstruktur eines Analyse‑Skripts:

% 1. Konfiguration / Parameter

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

% Die Funktion `fullfile` erstellt Pfade, die auf jedem Betriebssystem
% funktionieren (Windows verwendet Backslashes, Mac/Linux verwenden
% Schrägstriche). `fullfile` macht das automatisch richtig.
%
% Die Funktion `exist` prüft, ob etwas existiert. `"dir"` bedeutet, dass wir
% prüfen, ob es ein Ordner (directory) ist. Wenn der Ordner nicht existiert,
% wird er mit `mkdir` erstellt.
%
% WICHTIGER HINWEIS: Es ist eine gute Idee, alle Parameter am Anfang des
% Skripts zu definieren. Wenn du später etwas ändern möchtest (z.B. andere
% Subjekte analysieren), musst du nur eine Zeile ändern, nicht den ganzen Code
% durchsuchen.

%% 3. Schleifen über Subjekte und Bedingungen
% Häufig möchtest du dieselben Analyseschritte für viele Versuchspersonen und
% Bedingungen durchführen. Statt den Code für jede VP und jede Bedingung
% einzeln zu schreiben, verwendest du Schleifen.

%% 3.1 Schleife über Subjekte
% Hier siehst du, wie du über mehrere Subjekte iterierst:

for s = 1:length(subjekte)
    subj_id = subjekte(s);
    fprintf("Verarbeite Subjekt %d ...\n", subj_id);
    
    % Beispieldateiname: „gip_sub-00X.mat"
    dateiname = sprintf("gip_sub-%03d.mat", subj_id);
    vollpfad  = fullfile(pfad_daten, dateiname);
    
    if ~isfile(vollpfad)
        warning("Datei %s nicht gefunden, wird übersprungen.", vollpfad);
        continue;
    end
    
    % Hier würden jetzt die eigentlichen Analyseschritte folgen:
    % - Daten laden
    % - Vorverarbeitung
    % - Zeit‑Frequenz‑Analysen
    % - etc.
    
    % Ergebnisse pro Subjekt speichern (Beispiel, auskommentiert):
    % save(fullfile(pfad_ergebnis, sprintf('Ergebnis_VP_%03d.mat', subj_id)), ...
    %      'EEG', '-v7.3');
end

% Die Funktion `sprintf` formatiert Text ähnlich wie `fprintf`, gibt aber
% einen String zurück statt ihn auszugeben. `%03d` bedeutet: eine ganze Zahl
% mit mindestens 3 Stellen, führende Nullen auffüllen (z.B. 002 statt 2).
%
% `isfile` prüft, ob eine Datei existiert. Wenn die Datei nicht gefunden wird,
% gibt `continue` die Schleife zum nächsten Durchgang weiter, ohne den Rest
% des Codes auszuführen. Das verhindert Fehler, wenn eine Datei fehlt.
%
% WICHTIGER HINWEIS: Die Variable `s` ist der Index im Array `subjekte`, nicht
% die Subjekt‑ID selbst! `subjekte(s)` gibt dir die tatsächliche Subjekt‑ID
% (z.B. 2, 3 oder 4). Das ist wichtig, wenn deine Subjekt‑IDs nicht
% fortlaufend bei 1 beginnen.

%% 3.2 Verschachtelte Schleifen: Subjekte und Bedingungen
% Oft möchtest du für jede Versuchsperson auch noch über verschiedene
% Bedingungen iterieren. Das machst du mit verschachtelten Schleifen:

for s = 1:length(subjekte)
    subj_id = subjekte(s);
    
    for b = 1:length(bedingungen)
        bed = bedingungen(b);
        fprintf("Subjekt %d – Bedingung %s\n", subj_id, bed);
        
        % Hier: Trials für diese Bedingung auswählen,
        % ERP oder Zeit‑Frequenz analysieren usw.
    end
end

% Die äussere Schleife iteriert über Subjekte, die innere Schleife über
% Bedingungen. Das bedeutet, dass für jedes Subjekt alle Bedingungen
% durchlaufen werden, bevor zum nächsten Subjekt gewechselt wird.
%
% WICHTIGER HINWEIS: Verschachtelte Schleifen können schnell komplex werden.
% Achte darauf, dass die Variablennamen klar sind (`s` für Subjekt‑Index,
% `b` für Bedingungs‑Index) und dass du nicht versehentlich die falsche
% Variable verwendest.

EXKURS Schleifen vs. Vektorisierung: In MATLAB gibt es oft zwei Wege, etwas
zu erreichen: mit Schleifen oder mit vektorisierten Operationen. Vektorisierte
Operationen sind oft schneller, aber Schleifen sind manchmal klarer und
leichter zu verstehen. Für Anfänger sind Schleifen meist der bessere Weg, weil
sie explizit zeigen, was passiert. Später kannst du lernen, wann
Vektorisierung sinnvoll ist.

%% 4. Funktionen schreiben
% Wenn du denselben Codeblock mehrfach verwendest, solltest du ihn in eine
% Funktion auslagern. Funktionen machen deinen Code:
% - kürzer (du schreibst den Code nur einmal)
% - klarer (der Funktionsname sagt, was gemacht wird)
% - leichter zu testen (du kannst die Funktion isoliert testen)
% - leichter zu korrigieren (wenn du einen Fehler findest, musst du ihn nur
%   einmal korrigieren)

%% 4.1 Einfache Funktion
% Eine Funktion ist eine separate Datei mit dem Namen der Funktion. Beispiel:
% Du erstellst eine Datei `berechne_mittelwert.m` mit folgendem Inhalt:
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
% In deinem Skript kannst du die Funktion dann einfach aufrufen:

daten = [1 2 3 4 5];
m = mean(daten);  % Du könntest auch direkt mean() verwenden, aber das ist ein Beispiel

% WICHTIGER HINWEIS: Der Dateiname muss genau dem Funktionsnamen entsprechen!
% Die Funktion `berechne_mittelwert` muss in der Datei `berechne_mittelwert.m`
% stehen. MATLAB findet die Funktion dann automatisch, wenn sie im aktuellen
% Ordner oder im MATLAB‑Pfad liegt.

%% 4.2 Funktion mit mehreren Ausgaben
% Funktionen können auch mehrere Ausgaben haben. Beispiel: Eine Funktion, die
% Mittelwert UND Standardabweichung berechnet.
%
% function [m, s] = beschreibe_daten(x)
%     % BESCHREIBE_DATEN – gibt Mittelwert und Standardabweichung zurück
%     %
%     % Eingabe:
%     %   x – numerischer Vektor
%     %
%     % Ausgabe:
%     %   m – Mittelwert von x
%     %   s – Standardabweichung von x
%     m = mean(x);
%     s = std(x);
% end
%
% Aufruf:

daten = [1 2 3 4 5];
[m, s] = [mean(daten), std(daten)];  % Beispiel, du könntest auch die Funktion aufrufen

% Wenn du nur den Mittelwert brauchst, kannst du auch nur eine Ausgabe
% anfordern:
% m = beschreibe_daten(daten);  % Nur Mittelwert wird zurückgegeben

%% 4.3 Funktion für einen Vorverarbeitungsschritt
% Funktionen sind besonders nützlich für wiederkehrende Schritte, z.B. einen
% Filter‑Schritt, den du für mehrere Subjekte durchführst.
%
% Beispiel (Pseudocode, nicht ausführbar):
%
% function EEG_out = mein_hochpass_filter(EEG_in, f_cutoff)
%     % MEIN_HOCHPASS_FILTER – filtert EEG‑Daten mit einem Hochpassfilter
%     %
%     % Eingabe:
%     %   EEG_in   – EEG‑Struktur (input EEG structure)
%     %   f_cutoff – Grenzfrequenz in Hz (cutoff frequency)
%     %
%     % Ausgabe:
%     %   EEG_out  – gefilterte EEG‑Struktur (filtered EEG structure)
%     %
%     % Hier könntest du z.B. pop_eegfiltnew aus EEGLAB verwenden:
%     % EEG_out = pop_eegfiltnew(EEG_in, f_cutoff, []);
%     %
%     % Für dieses Beispiel lassen wir den Inhalt leer.
%     EEG_out = EEG_in; % Platzhalter
% end
%
% WICHTIGER HINWEIS: Funktionen sollten gut dokumentiert sein. Der Kommentar
% direkt unter der Funktionszeile (mit `%` beginnend) wird von MATLAB als
% Hilfe‑Text angezeigt, wenn du `help funktionsname` eingibst. Beschreibe
% immer, was die Funktion macht, welche Eingaben sie erwartet und welche
% Ausgaben sie liefert.

EXKURS Lokale vs. globale Variablen: Variablen, die du innerhalb einer
Funktion definierst, sind "lokal" – sie existieren nur innerhalb der Funktion
und werden nicht im Workspace gespeichert. Das ist meist gut so, weil es
verhindert, dass Funktionen versehentlich Variablen überschreiben, die du in
deinem Hauptskript verwendest. Wenn du wirklich eine Variable aus dem
Workspace in einer Funktion verwenden möchtest, kannst du sie als Eingabe
übergeben.

%% 5. Mini‑Projekt: kleine Analyse‑Pipeline
% Jetzt kombinieren wir alles, was wir gelernt haben, und erstellen eine
% kleine Analyse‑Pipeline. Das ist ein vereinfachtes Beispiel für das, was du
% später im Blockkurs machen wirst.

%% 5.1 Beispiel‑Code‑Skeleton
% Hier siehst du die Struktur einer typischen Pipeline:

% Parameter definieren
subjekte     = 2:4;
bedingungen  = ["A","B"];
zeitfenster  = [0.3 0.6];   % 300–600 ms
freqband     = [8 12];      % 8–12 Hz (z.B. Alpha)

% Ergebnis‑Speicher initialisieren
Ergebnisse = [];

for s = 1:length(subjekte)
    subj_id = subjekte(s);
    
    % --- Daten laden (Pseudocode) ---
    % dateiname = sprintf("gip_sub-%03d.mat", subj_id);
    % data = load(fullfile(pfad_daten, dateiname));
    % EEG = data.EEG;
    
    for b = 1:length(bedingungen)
        bed = bedingungen(b);
        
        % --- Trials für diese Bedingung auswählen (Pseudocode) ---
        % EEG_bed = selektiere_bedingung(EEG, bed);
        
        % --- Metrik berechnen (Pseudocode) ---
        % metr = berechne_metrik(EEG_bed, zeitfenster, freqband);
        metr = rand();  % Platzhalter für dieses Beispiel
        
        % Ergebnis zur Tabelle hinzufügen
        Ergebnisse = [Ergebnisse; ...
            table(subj_id, bed, metr, ...
            'VariableNames', {'VP','Bedingung','Metrik'})];
    end
end

Ergebnisse

% Diese Pipeline zeigt die typische Struktur:
% 1. Parameter werden am Anfang definiert
% 2. Ein Ergebnis‑Speicher wird initialisiert (hier eine leere Tabelle)
% 3. Verschachtelte Schleifen iterieren über Subjekte und Bedingungen
% 4. Für jede Kombination wird eine Metrik berechnet
% 5. Die Ergebnisse werden in einer Tabelle gespeichert
%
% WICHTIGER HINWEIS: Die Initialisierung von `Ergebnisse` als leere Tabelle
% ist wichtig. Wenn du versuchst, eine Tabelle zu konkatenieren, die noch
% nicht existiert, bekommst du einen Fehler. Du könntest auch `Ergebnisse = []`
% verwenden und dann die erste Zeile anders hinzufügen, aber die Tabelle ist
% übersichtlicher.

%% 5.2 Tipps für gute Pipeline‑Struktur
% Hier sind einige Tipps, die dir helfen, gute Pipelines zu schreiben:
%
% 1. **Kommentiere wichtige Schritte**: Nicht jede Zeile muss kommentiert
%    sein, aber komplexe oder wichtige Schritte sollten erklärt werden.
%
% 2. **Verwende aussagekräftige Variablennamen**: `subj_id` ist besser als `s`,
%    `bedingung` ist besser als `b`. (Aber in Schleifen sind kurze Namen wie
%    `s` und `b` auch okay, wenn der Kontext klar ist.)
%
% 3. **Teste mit wenigen Subjekten zuerst**: Bevor du die Pipeline auf alle
%    Subjekte anwendest, teste sie mit einem oder zwei Subjekten. Das spart
%    Zeit, wenn du einen Fehler findest.
%
% 4. **Speichere Zwischenergebnisse**: Wenn eine Berechnung lange dauert,
%    speichere das Ergebnis, damit du es nicht nochmal berechnen musst, wenn
%    etwas schiefgeht.
%
% 5. **Prüfe auf Fehler**: Verwende `isfile`, `exist` oder `try‑catch`, um
%    Fehler abzufangen, bevor sie das ganze Skript zum Absturz bringen.

%% 6. Fehlerbehandlung
% Wenn du mit vielen Dateien oder komplexen Analysen arbeitest, können Fehler
% auftreten. Gute Fehlerbehandlung sorgt dafür, dass dein Skript nicht komplett
% abstürzt, wenn etwas schiefgeht.

%% 6.1 try‑catch für robuste Skripte
% Die `try‑catch`‑Struktur erlaubt es dir, Fehler abzufangen und darauf zu
% reagieren, ohne dass das ganze Skript stoppt:

% Beispiel: Versuche, Daten zu laden, fange Fehler ab
% for s = 1:length(subjekte)
%     subj_id = subjekte(s);
%     dateiname = sprintf("gip_sub-%03d.mat", subj_id);
%     vollpfad = fullfile(pfad_daten, dateiname);
%     
%     try
%         load(vollpfad);
%         fprintf("Subjekt %d erfolgreich geladen.\n", subj_id);
%         % Hier würdest du die Analyse durchführen
%     catch ME
%         warning("Fehler beim Laden von Subjekt %d: %s", subj_id, ME.message);
%         continue;  % Überspringe dieses Subjekt und gehe zum nächsten
%     end
% end

% Die `try`‑Sektion enthält den Code, der fehlschlagen könnte. Wenn ein Fehler
% auftritt, wird die `catch`‑Sektion ausgeführt. `ME` (MException) enthält
% Informationen über den Fehler, z.B. `ME.message` für die Fehlermeldung.
%
% WICHTIGER HINWEIS: `try‑catch` sollte sparsam verwendet werden. Es ist besser,
% Fehler zu vermeiden (z.B. mit `isfile` prüfen, ob eine Datei existiert), als
% sie abzufangen. Aber für unvorhersehbare Fehler (z.B. beschädigte Dateien) ist
% `try‑catch` sehr nützlich.

%% 6.2 warning vs. error
% MATLAB bietet zwei Arten von Meldungen:
% - `warning`: Gibt eine Warnung aus, aber das Skript läuft weiter
% - `error`: Stoppt das Skript mit einer Fehlermeldung

% Beispiel: Warning für fehlende Dateien
% if ~isfile(vollpfad)
%     warning("Datei %s nicht gefunden, wird übersprungen.", vollpfad);
%     continue;
% end

% Beispiel: Error für kritische Fehler
% if isempty(EEG.data)
%     error("EEG-Daten sind leer! Analyse kann nicht durchgeführt werden.");
% end

% Verwende `warning` für Probleme, die nicht kritisch sind (z.B. fehlende
% Dateien, die übersprungen werden können). Verwende `error` für kritische
% Probleme, die die Analyse unmöglich machen (z.B. leere Daten).

%% 7. Debugging‑Tipps
% Wenn dein Code nicht funktioniert, musst du herausfinden, warum. Hier sind
% einige nützliche Techniken:

%% 7.1 Ausgaben mit disp und fprintf
% Die einfachste Methode ist, Zwischenwerte auszugeben:

% Beispiel: Ausgabe während einer Schleife
% for s = 1:length(subjekte)
%     subj_id = subjekte(s);
%     fprintf("Verarbeite Subjekt %d ...\n", subj_id);
%     
%     % Hier würdest du die Analyse durchführen
%     % Wenn etwas schiefgeht, siehst du, bei welchem Subjekt es passiert ist
% end

% `fprintf` ist flexibler als `disp`, weil du formatierte Ausgaben erstellen
% kannst. `%d` steht für eine ganze Zahl, `%s` für Text, `\n` für einen
% Zeilenumbruch.

%% 7.2 Timing mit tic und toc
% Wenn dein Code langsam ist, möchtest du vielleicht wissen, wie lange bestimmte
% Teile dauern:

% tic;  % Starte Timer
% % Hier kommt dein Code, der lange dauert
% % z.B. eine Schleife über alle Subjekte
% for s = 1:length(subjekte)
%     % Analyse durchführen
% end
% elapsed_time = toc;  % Stoppe Timer und speichere Zeit
% fprintf("Analyse dauerte %.2f Sekunden.\n", elapsed_time);

% `tic` startet einen Timer, `toc` stoppt ihn und gibt die vergangene Zeit
% zurück. Das hilft dir, zu identifizieren, welche Teile deines Codes langsam
% sind.

%% 7.3 Workspace inspizieren
% Wenn etwas nicht funktioniert, schaue dir die Variablen im Workspace an:

% size(EEG.data)      % Dimensionen prüfen
% class(EEG.data)     % Datentyp prüfen
% isempty(EEG.data)   % Prüfen, ob leer
% unique([EEG.event.type])  % Einzigartige Event‑Typen sehen

% Diese Befehle helfen dir, zu verstehen, was in deinen Variablen steht und
% warum etwas nicht funktioniert.

%% Zusammenfassung
% In diesem Tutorial hast du gelernt:
%
% 1. **Warum saubere Skripte wichtig sind**: Sie sind nachvollziehbar,
%    wiederholbar und erweiterbar.
%
% 2. **Struktur von Analyse‑Skripten**: Parameter am Anfang, dann
%    Verarbeitung, dann Speicherung.
%
% 3. **Schleifen über Subjekte und Bedingungen**: Vermeiden Copy‑Paste und
%    machen Code übersichtlicher.
%
% 4. **Funktionen schreiben**: Machen Code kürzer, klarer und leichter zu
%    testen.
%
% 5. **Pipeline‑Struktur**: Wie du alles zusammenfügst zu einer vollständigen
%    Analyse‑Pipeline.
%
% Diese Prinzipien wirst du später im Blockkurs häufig verwenden, besonders
% wenn du mit echten EEG‑Daten arbeitest. Guter Code spart dir Zeit und macht
% deine Analysen reproduzierbar.
