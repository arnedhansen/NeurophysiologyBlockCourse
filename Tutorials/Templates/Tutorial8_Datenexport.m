%% Tutorial 8 – Datenexport und Speicherung
% Dieses optionale Tutorial zeigt dir, wie du Ergebnisse aus deinen EEG‑Analysen
% speicherst und exportierst, sowohl für die weitere Verarbeitung in anderen
% Programmen (z.B. R, Python) als auch für Publikationen.
%
% Inhalte:
% 
% - 0. Einführung
% - 1. Tabellen als CSV/TXT exportieren
%   - 1.1 Tabellen als CSV speichern
%   - 1.2 Tabellen als TXT speichern
%   - 1.3 Tabellen mit zusätzlichen Optionen speichern
% - 2. Plots speichern
%   - 2.1 Plots als PNG speichern
%   - 2.2 Hochauflösende Plots für Publikationen
%   - 2.3 Plots als PDF speichern
%   - 2.4 Plots mit spezifischen Dimensionen speichern
%   - 2.5 Mehrere Plots speichern
% - 3. Daten als MAT‑Dateien speichern
%   - 3.1 Einfaches Speichern
%   - 3.2 Strukturen speichern
%   - 3.3 Komprimiertes Speichern (v7.3 Format)
% - 4. BIDS‑Format: Struktur für organisierte Datenspeicherung
%   - 4.1 Was ist BIDS?
%   - 4.2 Warum BIDS verwenden?
%   - 4.3 Einfache BIDS‑ähnliche Struktur erstellen
%   - 4.4 Dateien nach BIDS‑Konvention benennen
%   - 4.5 Metadaten in JSON speichern
%   - 4.6 participants.tsv erstellen
% - 5. Best Practices für Datenspeicherung
%   - 5.1 Organisierte Ordnerstruktur
%   - 5.2 Konsistente Dateinamen
%   - 5.3 Dokumentation

%% 0. Einführung
% Nachdem du deine EEG‑Analysen durchgeführt hast, möchtest du die Ergebnisse
% oft speichern oder exportieren:
% - **Für weitere Analysen**: z.B. in R oder Python für statistische Tests
% - **Für Publikationen**: hochauflösende Plots für Papers oder Präsentationen
% - **Für Reproduzierbarkeit**: Zwischenergebnisse speichern, damit du sie
%   später nicht nochmal berechnen musst
%
% In diesem Tutorial lernst du verschiedene Methoden kennen, um Daten und
% Ergebnisse zu speichern und zu exportieren.
%
% Diese Tutorials sind so gestaltet, dass du nicht alles auswendig lernen musst.
% Vielmehr geht es darum, ein grundlegendes Verständnis dafür zu entwickeln,
% wie Datenexport funktioniert. Du wirst später im Blockkurs viele Gelegenheiten
% haben, das Gelernte anzuwenden.

%% 1. Tabellen als CSV/TXT exportieren
% Tabellen (tables) sind ideal, um Ergebnisse zu speichern, die du später in
% anderen Programmen verwenden möchtest (z.B. R, Python, Excel).

%% 1.1 Tabellen als CSV speichern
% CSV (Comma‑Separated Values) ist ein universelles Format, das von fast allen
% Programmen gelesen werden kann:

% Beispiel: Tabelle mit Ergebnissen erstellen und speichern
% vp_id = [1; 2; 3; 4];
% bedingung = ["A"; "A"; "B"; "B"];
% mittel_rt = [500; 520; 540; 560];
% 
% T = table(vp_id, bedingung, mittel_rt, ...
%     'VariableNames', {'VP','Bedingung','Mittel_RT'});
% 
% % Als CSV speichern
% writetable(T, 'ergebnisse.csv');

% Die Funktion `writetable` speichert eine Tabelle als CSV‑Datei. Die Datei wird
% im aktuellen Ordner gespeichert (oder du gibst einen vollständigen Pfad an).
%
% Du kannst die Datei dann in R oder Python öffnen:
% - R: `read.csv("ergebnisse.csv")`
% - Python: `pandas.read_csv("ergebnisse.csv")`
% - Excel: einfach öffnen

%% 1.2 Tabellen als TXT speichern
% Du kannst Tabellen auch als TXT‑Dateien speichern, mit verschiedenen
% Trennzeichen:

% Beispiel: Als TXT mit Tabulator als Trennzeichen
% writetable(T, 'ergebnisse.txt', 'Delimiter', '\t');

% Die Option `'Delimiter', '\t'` verwendet Tabulator als Trennzeichen statt
% Komma. Das ist manchmal nützlich, wenn deine Daten Kommas enthalten.
%
% Weitere Optionen:
% - `'Delimiter', ','`: Komma (Standard für CSV)
% - `'Delimiter', '\t'`: Tabulator
% - `'Delimiter', ';'`: Semikolon (manchmal in Excel verwendet)

%% 1.3 Tabellen mit zusätzlichen Optionen speichern
% `writetable` hat viele Optionen, um die Ausgabe anzupassen:

% Beispiel: Ohne Zeilennamen speichern
% writetable(T, 'ergebnisse.csv', 'WriteRowNames', false);

% Beispiel: Mit spezifischer Kodierung (für Sonderzeichen)
% writetable(T, 'ergebnisse.csv', 'Encoding', 'UTF-8');

% WICHTIGER HINWEIS: Wenn deine Daten Sonderzeichen enthalten (z.B. Umlaute),
% stelle sicher, dass die Kodierung richtig ist. `'UTF-8'` ist meist eine gute
% Wahl.

%% 2. Plots speichern
% Plots für Publikationen müssen oft hochauflösend sein und in bestimmten
% Formaten gespeichert werden.

%% 2.1 Plots als PNG speichern
% PNG (Portable Network Graphics) ist ein gutes Format für Plots mit vielen
% Details:

% Beispiel: Plot erstellen und als PNG speichern
% figure;
% plot(EEGC1.times, ERP1(kanal_index, :), 'LineWidth', 2)
% xlabel('Time (ms)')
% ylabel('Voltage (\muV)')
% title('ERP')
% 
% % Als PNG speichern
% print('erp_plot.png', '-dpng');

% Die Funktion `print` speichert die aktuelle Figure. `'-dpng'` gibt das Format
% an (PNG). Die Datei wird im aktuellen Ordner gespeichert.

%% 2.2 Hochauflösende Plots für Publikationen
% Für Publikationen brauchst du oft hochauflösende Plots. Du kannst die
% Auflösung mit der Option `'-r'` (resolution) angeben:

% Beispiel: Hochauflösender Plot (300 DPI, Standard für Publikationen)
% print('erp_plot_highres.png', '-dpng', '-r300');

% Die Auflösung wird in DPI (dots per inch) angegeben:
% - 150 DPI: Für Bildschirmpräsentationen
% - 300 DPI: Standard für Publikationen (Zeitschriften)
% - 600 DPI: Sehr hochauflösend (für sehr detaillierte Plots)

% Du kannst auch die Grösse der Figure anpassen, bevor du sie speicherst:

% figure('Position', [100, 100, 800, 600]);  % Breite x Höhe in Pixeln
% plot(EEGC1.times, ERP1(kanal_index, :), 'LineWidth', 2)
% print('erp_plot_customsize.png', '-dpng', '-r300');

% WICHTIGER HINWEIS: Grössere Figures brauchen mehr Speicherplatz. Für
% Publikationen sind meist 800–1200 Pixel Breite und 300 DPI ausreichend.

%% 2.3 Plots als PDF speichern
% PDF (Portable Document Format) ist ein vektorbasiertes Format, das sich gut
% für Publikationen eignet, weil es ohne Qualitätsverlust skaliert werden kann:

% Beispiel: Plot als PDF speichern
% figure;
% plot(EEGC1.times, ERP1(kanal_index, :), 'LineWidth', 2)
% xlabel('Time (ms)')
% ylabel('Voltage (\muV)')
% print('erp_plot.pdf', '-dpdf');

% PDFs sind besonders nützlich, wenn die Zeitschriften PDFs bevorzugen oder
% wenn du die Plots später noch bearbeiten möchtest (z.B. in Adobe Illustrator).

%% 2.4 Plots mit spezifischen Dimensionen speichern
% Oft möchtest du Plots in bestimmten Dimensionen speichern (z.B. für eine
% bestimmte Spaltenbreite in einem Paper):

% Beispiel: Plot mit spezifischen Dimensionen (in cm)
% figure('Units', 'centimeters', 'Position', [10, 10, 12, 8]);
% plot(EEGC1.times, ERP1(kanal_index, :), 'LineWidth', 2)
% xlabel('Time (ms)')
% ylabel('Voltage (\muV)')
% print('erp_plot_cm.pdf', '-dpdf', '-r300');

% Hier wird die Figure‑Grösse in Zentimetern angegeben (12 cm breit, 8 cm hoch).
% Das ist nützlich, wenn du genau weisst, welche Grösse du brauchst (z.B. für
% eine Spaltenbreite von 8.5 cm in einem Paper).

%% 2.5 Mehrere Plots speichern
% Wenn du mehrere Plots hast, möchtest du sie vielleicht alle speichern:

% Beispiel: Alle offenen Figures speichern
% figures = findall(0, 'Type', 'figure');  % Finde alle offenen Figures
% for i = 1:length(figures)
%     figure(figures(i));  % Aktiviere diese Figure
%     dateiname = sprintf('plot_%02d.png', i);
%     print(dateiname, '-dpng', '-r300');
% end

% Oder du kannst jede Figure einzeln speichern, nachdem du sie erstellt hast:

% figure(1);
% plot(EEGC1.times, ERP1(kanal_index, :))
% print('erp_bedingung1.png', '-dpng', '-r300');
% 
% figure(2);
% plot(EEGC1.times, ERP2(kanal_index, :))
% print('erp_bedingung2.png', '-dpng', '-r300');

%% 3. Daten als MAT‑Dateien speichern
% MAT‑Dateien sind MATLABs natives Format und eignen sich gut, um Zwischenergebnisse
% oder vollständige Datensätze zu speichern.

%% 3.1 Einfaches Speichern
% Die einfachste Methode ist, Variablen direkt zu speichern:

% Beispiel: Einzelne Variablen speichern
% save('ergebnisse.mat', 'ERP1', 'ERP2', 'ERP3');

% Dies speichert die Variablen `ERP1`, `ERP2` und `ERP3` in der Datei
% `ergebnisse.mat`. Du kannst sie später mit `load('ergebnisse.mat')` wieder
% laden.

%% 3.2 Strukturen speichern
% Oft möchtest du mehrere zusammengehörige Variablen speichern. Strukturen sind
% dafür ideal:

% Beispiel: Ergebnisse in einer Struktur speichern
% ergebnisse.ERP1 = ERP1;
% ergebnisse.ERP2 = ERP2;
% ergebnisse.ERP3 = ERP3;
% ergebnisse.zeiten = EEGC1.times;
% ergebnisse.kanal = kanal_index;
% 
% save('ergebnisse_struktur.mat', 'ergebnisse');

% So hast du alle Ergebnisse in einer Struktur organisiert. Wenn du die Datei
% später lädst, hast du alles in einer übersichtlichen Struktur.

%% 3.3 Komprimiertes Speichern (v7.3 Format)
% Für grosse Dateien (z.B. vollständige EEG‑Datensätze) solltest du das v7.3
% Format verwenden, das komprimiert und effizienter ist:

% Beispiel: Komprimiert speichern
% save('eeg_daten.mat', 'EEG', '-v7.3');

% Das `'-v7.3'` Format unterstützt:
% - Kompression (kleinere Dateien)
% - Dateien grösser als 2 GB
% - Teilweises Laden (nur bestimmte Variablen laden)

% WICHTIGER HINWEIS: Das v7.3 Format ist langsamer beim Speichern und Laden,
% aber die Dateien sind kleiner. Für kleine Dateien ist das Standardformat
% (v7) ausreichend.

%% 4. BIDS‑Format: Struktur für organisierte Datenspeicherung
% BIDS (Brain Imaging Data Structure) ist ein Standard für die Organisation von
% neuroimaging Daten. Es macht deine Daten nachvollziehbar und reproduzierbar.

%% 4.1 Was ist BIDS?
% BIDS definiert eine klare Ordnerstruktur und Namenskonventionen für
% neuroimaging Daten. Die Struktur sieht etwa so aus:
%
% ```
% dataset/
% ├── dataset_description.json
% ├── participants.tsv
% ├── sub-001/
% │   ├── ses-001/
% │   │   ├── eeg/
% │   │   │   ├── sub-001_ses-001_task-rest_eeg.set
% │   │   │   ├── sub-001_ses-001_task-rest_eeg.fdt
% │   │   │   └── sub-001_ses-001_task-rest_eeg.json
% │   │   └── beh/
% │   │       └── sub-001_ses-001_task-rest_beh.tsv
% │   └── sub-001_ses-002/
% └── sub-002/
% ```
%
% Die wichtigsten Prinzipien:
% - **Hierarchische Struktur**: Subjekte → Sessions → Modalities (z.B. EEG)
% - **Konsistente Namenskonventionen**: `sub-XXX_ses-XXX_task-XXX_eeg.set`
% - **Metadaten in JSON**: Zusätzliche Informationen in strukturierten Dateien

%% 4.2 Warum BIDS verwenden?
% BIDS bietet mehrere Vorteile:
% - **Reproduzierbarkeit**: Andere können deine Datenstruktur leicht verstehen
% - **Kompatibilität**: Viele Tools unterstützen BIDS (z.B. EEGLAB, MNE‑Python)
% - **Metadaten**: Wichtige Informationen werden strukturiert gespeichert
% - **Sharing**: Einfacher, Daten mit anderen zu teilen

%% 4.3 Einfache BIDS‑ähnliche Struktur erstellen
% Auch wenn du nicht vollständig BIDS‑konform sein musst, kannst du eine
% ähnliche Struktur verwenden:

% Beispiel: BIDS‑ähnliche Ordnerstruktur erstellen
% projekt_name = "EEG_Blockkurs";
% base_dir = "BIDS_dataset";
% 
% % Ordnerstruktur erstellen
% for sub = 2:11
%     subj_dir = fullfile(base_dir, sprintf("sub-%03d", sub), "eeg");
%     if ~exist(subj_dir, "dir")
%         mkdir(subj_dir);
%     end
% end

% Dies erstellt eine Struktur wie:
% ```
% BIDS_dataset/
% ├── sub-002/
% │   └── eeg/
% ├── sub-003/
% │   └── eeg/
% ...
% ```

%% 4.4 Dateien nach BIDS‑Konvention benennen
% BIDS verwendet eine spezifische Namenskonvention:

% Beispiel: Dateien nach BIDS benennen
% subj_id = 2;
% session = 1;
% task = "rest";
% 
% dateiname = sprintf("sub-%03d_ses-%02d_task-%s_eeg.set", ...
%     subj_id, session, task);
% 
% % Datei speichern
% % pop_saveset(EEG, 'filename', dateiname, 'filepath', subj_dir);

% Die Namenskonvention ist:
% - `sub-XXX`: Subjekt‑ID (3 Stellen, mit führenden Nullen)
% - `ses-XXX`: Session (optional, wenn mehrere Sessions)
% - `task-XXX`: Aufgabe/Bedingung
% - `modality`: Art der Daten (z.B. `eeg`, `meg`, `ieeg`)
% - `suffix`: Dateityp (z.B. `eeg`, `events`, `channels`)

%% 4.5 Metadaten in JSON speichern
% BIDS verwendet JSON‑Dateien für Metadaten. Du kannst diese in MATLAB erstellen:

% Beispiel: JSON‑Metadaten erstellen (vereinfacht)
% metadata = struct();
% metadata.SamplingFrequency = EEG.srate;
% metadata.PowerLineFrequency = 50;  % 50 Hz in Europa, 60 Hz in USA
% metadata.SoftwareFilters = struct();
% metadata.SoftwareFilters.HighPass = struct('FilterType', 'Butterworth', ...
%     'HalfPowerFrequency', 1, 'FilterOrder', 4);
% 
% % Als JSON speichern (benötigt jsonencode, verfügbar ab MATLAB R2016b)
% json_str = jsonencode(metadata);
% fid = fopen('eeg_metadata.json', 'w');
% fprintf(fid, '%s', json_str);
% fclose(fid);

% JSON (JavaScript Object Notation) ist ein textbasiertes Format für strukturierte
% Daten. Es ist leicht lesbar und wird von vielen Programmen unterstützt.
%
% WICHTIGER HINWEIS: `jsonencode` ist ab MATLAB R2016b verfügbar. Für ältere
% Versionen kannst du externe Funktionen verwenden oder die Metadaten als
% MAT‑Dateien speichern.

%% 4.6 participants.tsv erstellen
% BIDS verwendet eine `participants.tsv` Datei, die Informationen über alle
% Versuchspersonen enthält:

% Beispiel: participants.tsv erstellen
% vp_ids = (2:11)';
% alter = [23; 25; 22; 30; 28; 24; 26; 27; 29; 25];  % Beispielwerte
% geschlecht = ["w"; "m"; "w"; "m"; "w"; "w"; "m"; "w"; "m"; "w"];
% 
% participants = table(vp_ids, alter, geschlecht, ...
%     'VariableNames', {'participant_id', 'age', 'sex'});
% 
% % Als TSV speichern
% writetable(participants, fullfile(base_dir, 'participants.tsv'), ...
%     'Delimiter', '\t', 'FileType', 'text');

% Die `participants.tsv` Datei enthält demografische Informationen über alle
% Versuchspersonen. Das macht es einfach, diese Informationen später zu verwenden
% (z.B. für statistische Analysen in R).

EXKURS Vollständige BIDS‑Konformität: Für vollständige BIDS‑Konformität gibt
es viele weitere Anforderungen (z.B. `dataset_description.json`,
`channels.tsv`, `events.tsv`, etc.). Die EEGLAB‑BIDS‑Tools können dabei helfen,
BIDS‑konforme Datensätze zu erstellen. Für den Blockkurs reicht eine einfache,
BIDS‑inspirierte Struktur meist aus, um die Daten organisiert zu halten.

%% 5. Best Practices für Datenspeicherung
% Hier sind einige Tipps für gute Datenspeicherung:

%% 5.1 Organisierte Ordnerstruktur
% Verwende eine klare Ordnerstruktur:

% ```
% Projekt/
% ├── data/
% │   ├── raw_data/
% │   └── preprocessed_data/
% ├── scripts/
% ├── results/
% │   ├── erps/
% │   ├── plots/
% │   └── tables/
% └── figures/
% ```

% Dies macht es einfach, Daten zu finden und zu organisieren.

%% 5.2 Konsistente Dateinamen
% Verwende konsistente Namenskonventionen:

% GUT:
% - `erp_bedingung1_sub002.png`
% - `ergebnisse_alle_vps.csv`
% - `eeg_sub002_preprocessed.mat`

% SCHLECHT:
% - `plot1.png`
% - `ergebnisse_final_v2.csv`
% - `daten.mat`

% Konsistente Namen machen es einfacher, Dateien zu finden und zu verstehen,
% was sie enthalten.

%% 5.3 Dokumentation
% Dokumentiere, was in den Dateien gespeichert ist:

% Beispiel: README‑Datei erstellen
% fid = fopen('README_results.txt', 'w');
% fprintf(fid, 'Ergebnisse vom %s\n', datestr(now));
% fprintf(fid, 'ERP1: Bedingung 1 (familiar)\n');
% fprintf(fid, 'ERP2: Bedingung 2 (unfamiliar)\n');
% fprintf(fid, 'ERP3: Bedingung 3 (scrambled)\n');
% fprintf(fid, 'Zeitfenster: -200 bis 800 ms\n');
% fprintf(fid, 'Baseline: -200 bis 0 ms\n');
% fclose(fid);

% Eine README‑Datei erklärt, was in den Dateien gespeichert ist und wie sie
% erstellt wurden. Das ist besonders wichtig, wenn du die Daten später nochmal
% verwenden möchtest oder sie mit anderen teilst.

%% Zusammenfassung
% In diesem Tutorial hast du gelernt:
%
% 1. **Tabellen exportieren**: Wie du Tabellen als CSV oder TXT speicherst, um
%    sie in anderen Programmen zu verwenden
%
% 2. **Plots speichern**: Wie du Plots als PNG oder PDF speicherst, mit
%    verschiedenen Auflösungen für Publikationen
%
% 3. **MAT‑Dateien**: Wie du Daten als MAT‑Dateien speicherst, sowohl einfach
%    als auch komprimiert (v7.3 Format)
%
% 4. **BIDS‑Format**: Wie du eine BIDS‑inspirierte Struktur für organisierte
%    Datenspeicherung verwendest
%
% 5. **Best Practices**: Tipps für gute Datenspeicherung und Organisation
%
% Diese Methoden helfen dir, deine Ergebnisse zu organisieren und zu speichern,
% sowohl für die weitere Verarbeitung als auch für Publikationen und
% Reproduzierbarkeit.
