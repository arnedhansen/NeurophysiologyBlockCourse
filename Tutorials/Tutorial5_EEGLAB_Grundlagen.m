%% Tutorial 5 – Arbeiten mit EEG‑Daten in EEGLAB (Grundlagen)
% Dieses optionale Tutorial gibt dir einen praktischen Einstieg in EEGLAB,
% eine MATLAB‑Toolbox für die Analyse von EEG‑Daten.
%
% Inhalte:
% 1. Überblick: Was ist EEGLAB?
% 2. Daten laden und inspizieren
% 3. Ereignisse und Epochen
% 4. Grundlagen der Vorverarbeitung
% 5. Einfache ERPs

%% 0. Einführung
% In diesem Tutorial lernst du, wie du mit EEGLAB arbeitest, einer
% MATLAB‑Toolbox, die speziell für die Analyse von EEG‑Daten entwickelt wurde.
% EEGLAB bietet viele Funktionen zum Laden, Vorverarbeiten und Analysieren von
% EEG‑Daten.
%
% WICHTIG: Bevor du dieses Tutorial ausführst, musst du EEGLAB zum MATLAB‑Pfad
% hinzufügen. In den Praxis‑Skripten wird das so gemacht:
%
% addpath('eeglab2021.1')
% eeglab;
% close;
%
% Der erste Befehl fügt den EEGLAB‑Ordner zum Pfad hinzu, der zweite startet
% EEGLAB (was alle wichtigen Funktionen lädt), und der dritte schliesst das
% GUI‑Fenster wieder (wir arbeiten nur mit Skripten, nicht mit der GUI).
%
% Diese Tutorials sind so gestaltet, dass du nicht alles auswendig lernen musst.
% Vielmehr geht es darum, ein grundlegendes Verständnis dafür zu entwickeln,
% wie EEGLAB funktioniert. Du wirst später im Blockkurs viele Gelegenheiten
% haben, das Gelernte anzuwenden.

%% 1. Überblick: Was ist EEGLAB?
% EEGLAB ist eine MATLAB‑Toolbox für die Analyse von EEG‑Daten. Es bietet:
% - eine grafische Benutzeroberfläche (GUI, graphical user interface)
% - viele Komfortfunktionen zum Laden, Vorverarbeiten und Analysieren von EEG
% - eine Datenstruktur (EEG‑Struct), die alle relevanten Informationen enthält
%
% In diesem Tutorial verwenden wir die EEGLAB‑Funktionen hauptsächlich in
% Skripten, nicht über die GUI. Das hat den Vorteil, dass du genau weisst,
% welche Schritte du durchgeführt hast, und die Analyse später wiederholen
% kannst.

%% 1.1 Die EEG‑Struktur
% In EEGLAB werden alle EEG‑Daten in einer grossen Struktur namens `EEG`
% gespeichert. Diese Struktur enthält viele verschiedene Felder (fields), die
% unterschiedliche Informationen speichern. Die wichtigsten Felder sind:
%
% - `EEG.data`      : Die eigentlichen EEG‑Daten (Kanäle x Zeitpunkte x Trials)
% - `EEG.srate`     : Samplingrate (Abtastrate) in Hz
% - `EEG.nbchan`     : Anzahl der Kanäle (number of channels)
% - `EEG.pnts`       : Anzahl der Zeitpunkte pro Trial (points)
% - `EEG.trials`     : Anzahl der Trials (1 bei kontinuierlichen Daten)
% - `EEG.times`      : Zeitvektor (in ms)
% - `EEG.chanlocs`   : Kanalinformationen (channel locations: Name, Position, etc.)
% - `EEG.event`      : Event‑Informationen (Trigger, Reaktion, etc.)
%
% Wenn du später im Blockkurs mit echten EEG‑Daten arbeitest, wirst du diese
% Struktur sehr häufig verwenden. Es lohnt sich also, sich mit ihr vertraut
% zu machen.

%% 2. Daten laden und inspizieren
% Bevor du mit der Analyse beginnen kannst, musst du die Daten laden. In den
% Praxis‑Skripten werden die Daten meist so geladen:

% Pfad zu den Daten (Platzhalter, anpassen!)
% pathToData = 'data/preprocessed_data';
% load([pathToData '/gip_sub-002.mat']);

% Nach dem Laden solltest du eine Variable `EEG` im Workspace haben. Du kannst
% dir die Struktur anschauen, indem du einfach `EEG` eingibst oder im Workspace
% darauf klickst.

%% 2.1 Grundlegende Informationen anzeigen
% Wenn ein EEG‑Datensatz geladen ist, kannst du dir die wichtigsten
% Informationen anschauen:

% EEG          % Zeigt die gesamte Struktur an
% EEG.srate    % Samplingrate
% EEG.nbchan   % Anzahl der Kanäle
% size(EEG.data)  % Dimensionen der Datenmatrix

% Die Funktion `size` zeigt dir die Dimensionen der Datenmatrix. Bei
% kontinuierlichen Daten (keine Epochen) ist das normalerweise:
% [Anzahl Kanäle, Anzahl Zeitpunkte]
%
% Bei epoched Daten (mit Epochen) ist das:
% [Anzahl Kanäle, Anzahl Zeitpunkte pro Epoche, Anzahl Epochen]

%% 2.2 Rohsignal visualisieren mit eegplot
% Die Funktion `eegplot` zeigt dir das gesamte EEG‑Signal in einem
% interaktiven Fenster. Du kannst durch die Daten scrollen und alle Kanäle
% gleichzeitig betrachten.

% eegplot(EEG.data)

% Wenn deine Daten Events enthalten (z.B. Trigger, Marker), kannst du diese
% auch anzeigen lassen:

% eegplot(EEG.data, 'events', EEG.event)

% Das zeigt dir die Events als vertikale Linien im Plot. Das ist sehr nützlich,
% um zu sehen, wann bestimmte Ereignisse aufgetreten sind (z.B. wann ein
% Stimulus präsentiert wurde).
%
% WICHTIGER HINWEIS: `eegplot` öffnet ein interaktives Fenster. Du kannst
% durch die Daten scrollen, zoomen und einzelne Kanäle auswählen. Das Fenster
% bleibt offen, bis du es schliesst. Wenn du viele Plots erstellst, solltest
% du das Fenster nach dem Betrachten schliessen, damit es nicht zu voll wird.

%% 2.3 Einzelne Kanäle plotten
% Manchmal möchtest du nur einen oder wenige Kanäle genauer betrachten. Das
% kannst du mit normalen MATLAB‑Plot‑Funktionen machen:

% Beispiel: Erste 500 Datenpunkte von Kanal 1 und Kanal 50 plotten
% nChannelA = 1;
% nChannelB = 50;
% minPnt = 1;
% maxPnt = 500;

% figure;
% plot(EEG.times(minPnt:maxPnt), EEG.data(nChannelA, minPnt:maxPnt), 'color', 'r')
% hold on
% plot(EEG.times(minPnt:maxPnt), EEG.data(nChannelB, minPnt:maxPnt), 'color', 'y')
% legend('Kanal A', 'Kanal B')
% title('Timecourse of two EEG channels')
% xlabel('time [ms]')
% ylabel('signal [\muV]')

% Hier siehst du, wie du auf einzelne Kanäle und Zeitpunkte zugreifst:
% - `EEG.data(nChannelA, minPnt:maxPnt)` gibt dir die Daten von Kanal
%   `nChannelA` für die Zeitpunkte von `minPnt` bis `maxPnt`
% - `EEG.times(minPnt:maxPnt)` gibt dir die entsprechenden Zeitpunkte in ms
%
% WICHTIGER HINWEIS: Die Dimensionen von `EEG.data` sind [Kanäle, Zeitpunkte].
% Das erste Argument ist also der Kanal‑Index, das zweite der Zeitpunkt‑Index.
% Wenn du das vertauschst, bekommst du einen Fehler oder falsche Daten.

%% 2.4 Kanalpositionen visualisieren mit pop_chanedit
% Die Funktion `pop_chanedit` zeigt dir, wo die Elektroden auf dem Kopf
% positioniert sind. Das ist wichtig, um zu verstehen, welche Kanäle wo
% gemessen haben.

% pop_chanedit(EEG)

% Dies öffnet ein Fenster, das die Kanalpositionen (channel locations) zeigt.
% Du siehst eine 2D‑Darstellung des Kopfes von oben, mit den Positionen aller
% Elektroden. Das hilft dir, zu verstehen, welche Kanäle frontal, zentral,
% parietal, etc. sind.

%% 2.5 Topographien plotten mit topoplot
% Eine Topographie (topography) zeigt dir, wie die elektrische Aktivität über
% den Kopf verteilt ist zu einem bestimmten Zeitpunkt. Das ist wie eine
% "Landkarte" der Gehirnaktivität.

% Beispiel: Topographie für Datenpunkt 500
% timePnt = 500;
% figure;
% topoplot(EEG.data(:, timePnt), EEG.chanlocs)
% colorbar;
% title('Data at timepoint 500')

% Die Funktion `topoplot` nimmt als Eingabe:
% - einen Vektor mit Werten für jeden Kanal (hier: `EEG.data(:, timePnt)`)
% - die Kanalpositionen (hier: `EEG.chanlocs`)
%
% Das Ergebnis ist eine farbige Darstellung des Kopfes von oben, wobei die
% Farben die Amplitude an jeder Elektrode zeigen. Rot könnte z.B. positive
% Werte bedeuten, Blau negative Werte.
%
% WICHTIGER HINWEIS: `EEG.data(:, timePnt)` gibt dir einen Spaltenvektor mit
% den Werten aller Kanäle zum Zeitpunkt `timePnt`. Der Doppelpunkt `:` bedeutet
% "alle Kanäle". Das ist wichtig für `topoplot`, das einen Vektor mit einem
% Wert pro Kanal erwartet.

%% 3. Ereignisse und Epochen
% Die meisten EEG‑Experimente arbeiten ereignisbezogen (event‑related). Das
% bedeutet, dass bestimmte Ereignisse (Events) während der Aufnahme markiert
% wurden, z.B. wenn ein Stimulus präsentiert wurde oder wenn eine Person
% reagiert hat.

%% 3.1 Events inspizieren
% Events sind in `EEG.event` gespeichert. Du kannst dir die ersten Events
% anschauen:

% EEG.event(1:5)

% Typische Felder in `EEG.event` sind:
% - `type`: Event‑Typ (z.B. ein Stimuluscode wie "5", "6", "7" oder ein
%   Textlabel wie "Stimulus")
% - `latency`: Zeitpunkt im Datensatz (in Datenpunkten, nicht in ms!)
%
% WICHTIGER HINWEIS: `latency` ist in Datenpunkten angegeben, nicht in
% Millisekunden! Wenn du wissen möchtest, wann ein Event in ms aufgetreten
% ist, musst du `latency` durch die Samplingrate teilen und mit 1000
% multiplizieren, oder du verwendest `EEG.times(latency)`.

%% 3.2 Epochen definieren mit pop_epoch
% Epochen (epochs) sind Zeitfenster um bestimmte Events herum. Beispielsweise
% möchtest du vielleicht 200 ms vor einem Stimulus bis 800 ms nach dem
% Stimulus analysieren.

% Beispiel: Epochen von -200 ms bis 800 ms relativ zu Event‑Typen 5, 6, 7
% EEGC1 = pop_epoch(EEG, {5, 6, 7}, [-0.2 0.8]);

% Die Funktion `pop_epoch` nimmt als Eingabe:
% - die EEG‑Struktur
% - eine Zell‑Array mit Event‑Typen (hier: {5, 6, 7})
% - ein Zeitfenster in Sekunden (hier: [-0.2 0.8] bedeutet -200 ms bis 800 ms)
%
% Das Ergebnis ist eine neue EEG‑Struktur mit Epochen. Die Dimensionen von
% `EEGC1.data` sind jetzt [Kanäle, Zeitpunkte pro Epoche, Anzahl Epochen].
%
% WICHTIGER HINWEIS: Das Zeitfenster wird in Sekunden angegeben, nicht in
% Millisekunden! -0.2 bedeutet -200 ms, 0.8 bedeutet 800 ms. Das ist ein
% häufiger Fehler – achte darauf, dass du die Einheiten richtig hast.

%% 3.3 Baseline‑Korrektur mit pop_rmbase
% Die Baseline‑Korrektur (baseline correction) subtrahiert den Mittelwert
% eines Zeitfensters (meist vor dem Stimulus) von allen Zeitpunkten. Das
% entfernt langsame Drifts und macht die Daten vergleichbarer.

% Beispiel: Baseline‑Korrektur für das Zeitfenster -200 ms bis 0 ms
% EEGC1 = pop_rmbase(EEGC1, [-200 0]);

% Die Funktion `pop_rmbase` nimmt als Eingabe:
% - die EEG‑Struktur (mit Epochen)
% - ein Zeitfenster in ms (hier: [-200 0] bedeutet -200 ms bis 0 ms)
%
% WICHTIGER HINWEIS: Bei `pop_rmbase` wird das Zeitfenster in Millisekunden
% angegeben, nicht in Sekunden wie bei `pop_epoch`! Das ist verwirrend, aber
% so ist es in EEGLAB. Achte darauf, die richtigen Einheiten zu verwenden.
%
% Nach der Baseline‑Korrektur sollte der Mittelwert im Baseline‑Zeitfenster
% bei etwa 0 liegen. Das macht es einfacher, Effekte nach dem Stimulus zu
% erkennen.

%% 4. Grundlagen der Vorverarbeitung
% Vorverarbeitung (preprocessing) ist wichtig, um die Daten zu bereinigen und
% für die Analyse vorzubereiten. Typische Schritte sind:
% - Re‑Referenzierung (rereferencing)
% - Filtern (filtering)
% - (Optional: ICA, Kanal‑Interpolation, etc. – diese werden in anderen
%   Tutorials behandelt)

%% 4.1 Re‑Referenzierung mit reref
% Bei der Re‑Referenzierung (rereferencing) wird die Referenz der EEG‑Daten
% geändert. Die ursprüngliche Referenz könnte z.B. die Nase oder ein Ohr sein,
% und du möchtest auf eine andere Referenz umstellen (z.B. Durchschnittsreferenz).

% Beispiel: Re‑Referenzierung auf Durchschnittsreferenz (average reference)
% averageRefData = reref(EEG.data);

% Die Funktion `reref` nimmt als Eingabe:
% - die Datenmatrix (hier: `EEG.data`)
% - optional: einen Index eines Referenzkanals (wenn nicht angegeben, wird
%   Durchschnittsreferenz verwendet)
%
% Das Ergebnis ist eine neue Datenmatrix mit der neuen Referenz. Du kannst
% diese dann wieder in die EEG‑Struktur einfügen:
%
% EEG.data = averageRefData;

% Beispiel: Re‑Referenzierung auf einen spezifischen Kanal (z.B. Kanal 13)
% chlLeftEar = 13;
% leftEarData = reref(EEG.data, chlLeftEar);

% WICHTIGER HINWEIS: Re‑Referenzierung ändert die absoluten Amplituden der
% Daten, aber nicht die relativen Unterschiede zwischen Kanälen. Die Wahl der
% Referenz kann die Interpretation der Daten beeinflussen, besonders bei
% topographischen Darstellungen.

%% 4.2 Filtern mit pop_eegfiltnew
% Filtern entfernt unerwünschte Frequenzanteile aus den Daten. Typischerweise
% verwendet man:
% - Hochpassfilter (high‑pass filter): entfernt langsame Drifts (z.B. < 1 Hz)
% - Tiefpassfilter (low‑pass filter): entfernt hohe Frequenzen und Rauschen
%   (z.B. > 40 Hz)

% Beispiel: Hochpassfilter bei 1 Hz
% EEG = pop_eegfiltnew(EEG, 1, []);

% Die Funktion `pop_eegfiltnew` nimmt als Eingabe:
% - die EEG‑Struktur
% - die untere Grenzfrequenz (high‑pass cutoff) in Hz (hier: 1)
% - die obere Grenzfrequenz (low‑pass cutoff) in Hz (hier: [] bedeutet "kein
%   Tiefpassfilter")
%
% Beispiel: Tiefpassfilter bei 40 Hz (nach dem Hochpassfilter)
% EEG = pop_eegfiltnew(EEG, [], 40);

% Hier wird nur der Tiefpassfilter angewendet (die erste Grenzfrequenz ist [],
% also kein Hochpassfilter).
%
% Beispiel: Bandpassfilter (beide Grenzen gesetzt)
% EEG = pop_eegfiltnew(EEG, 1, 40);

% Dies filtert die Daten so, dass nur Frequenzen zwischen 1 Hz und 40 Hz
% übrig bleiben.
%
% WICHTIGER HINWEIS: Die Reihenfolge der Filterung ist wichtig! Normalerweise
% filtert man zuerst mit einem Hochpassfilter (um langsame Drifts zu
% entfernen) und dann mit einem Tiefpassfilter (um hohe Frequenzen zu
% entfernen). Wenn du beide Filter gleichzeitig anwenden möchtest, kannst du
% auch beide Grenzen in einem Aufruf setzen.

%% 4.3 Daten ausschneiden mit pop_select
% Manchmal möchtest du nur einen Teil der Daten analysieren, z.B. die ersten
% zwei Minuten oder einen bestimmten Zeitbereich.

% Beispiel: Erste zwei Minuten (120 Sekunden) ausschneiden
% EEG = pop_select(EEG, 'time', [1, 121]);

% Die Funktion `pop_select` ist sehr flexibel und kann Daten nach verschiedenen
% Kriterien auswählen:
% - `'time'`: Zeitbereich in Sekunden
% - `'channel'`: bestimmte Kanäle
% - `'trial'`: bestimmte Epochen (wenn Daten bereits epoched sind)
%
% WICHTIGER HINWEIS: Das Zeitfenster wird in Sekunden angegeben, nicht in
% Millisekunden! [1, 121] bedeutet von Sekunde 1 bis Sekunde 121 (also 120
% Sekunden Daten).

%% 5. Einfache ERPs
% Event‑Related Potentials (ERPs) entstehen durch Mittelung über mehrere
% Trials, die dasselbe Ereignis enthalten. Das reduziert Rauschen und macht
% die ereignisbezogenen Signale sichtbar.

%% 5.1 ERP berechnen
% Wenn du bereits Epochen hast, kannst du ein ERP einfach durch Mittelung über
% die dritte Dimension (Trials) berechnen:

% Beispiel: ERP für eine Bedingung berechnen
% ERP1 = mean(EEGC1.data, 3);

% Die Funktion `mean` mit dem dritten Argument `3` mittelt über die dritte
% Dimension, also über die Trials. Das Ergebnis `ERP1` hat jetzt die
% Dimensionen [Kanäle, Zeitpunkte].
%
% WICHTIGER HINWEIS: Die Dimensionen von epoched Daten sind [Kanäle,
% Zeitpunkte, Trials]. Wenn du über Trials mittelst (Dimension 3), bleibt eine
% Matrix mit [Kanäle, Zeitpunkte] übrig.

%% 5.2 ERP plotten
% Du kannst ein ERP für einen bestimmten Kanal plotten:

% Beispiel: ERP für Kanal 61 plotten
% kanal_index = 61;
% figure;
% plot(EEGC1.times, ERP1(kanal_index, :))
% xlabel('Time (ms)')
% ylabel('Voltage (\muV)')
% title('ERP at channel 61')
% grid on

% Hier siehst du die gemittelte Wellenform für diesen Kanal. Typische ERP‑
% Komponenten sind z.B. die N170 (eine negative Welle bei etwa 170 ms) oder
% die P300 (eine positive Welle bei etwa 300 ms), je nach Experiment.
%
% WICHTIGER HINWEIS: `EEGC1.times` gibt dir die Zeitpunkte in ms für die
% Epochen. Diese sind normalerweise relativ zum Event (z.B. -200 ms bis 800
% ms), nicht absolut.

%% 5.3 Vergleich zwischen Bedingungen
% In einem echten Experiment gibt es meist mehrere Bedingungen (z.B. kongruent
% vs. inkongruent). Du kannst für jede Bedingung ein separates ERP berechnen
% und dann vergleichen:

% Beispiel: ERP für zwei Bedingungen berechnen und plotten
% EEGC1 = pop_epoch(EEG, {5, 6, 7}, [-0.2 0.8]);  % Bedingung 1
% EEGC2 = pop_epoch(EEG, {13, 14, 15}, [-0.2 0.8]); % Bedingung 2
%
% EEGC1 = pop_rmbase(EEGC1, [-200 0]);
% EEGC2 = pop_rmbase(EEGC2, [-200 0]);
%
% ERP1 = mean(EEGC1.data, 3);
% ERP2 = mean(EEGC2.data, 3);
%
% kanal_index = 61;
% figure;
% plot(EEGC1.times, ERP1(kanal_index, :), 'LineWidth', 2, 'Color', 'red')
% hold on
% plot(EEGC2.times, ERP2(kanal_index, :), 'LineWidth', 2, 'Color', 'blue')
% xlabel('Time (ms)')
% ylabel('Voltage (\muV)')
% legend('Bedingung 1', 'Bedingung 2')
% grid on

% So kannst du die ERPs der beiden Bedingungen direkt vergleichen. Die
% Differenz zwischen den Bedingungen zeigt dir, wo sich die Bedingungen
% unterscheiden.

%% 5.4 Topographien für ERPs
% Du kannst auch Topographien für bestimmte Zeitfenster im ERP erstellen:

% Beispiel: Topographie für Zeitfenster 152-212 ms (z.B. um N170 Peak)
% a = find(EEGC1.times == 152, 1);  % Finde Zeitpunkt 152 ms
% b = find(EEGC1.times == 212, 1);  % Finde Zeitpunkt 212 ms
%
% figure;
% topoplot(mean(ERP1(:, a:b), 2), EEGC1.chanlocs, 'electrodes', 'on')
% colorbar;
% title('ERP topography: 152-212 ms')

% Hier mittelst du über das Zeitfenster (Dimension 2 in `mean(ERP1(:, a:b), 2)`)
% und erhältst einen Wert pro Kanal. Dieser wird dann in der Topographie
% dargestellt.
%
% WICHTIGER HINWEIS: `mean(ERP1(:, a:b), 2)` mittelt über die Spalten
% (Zeitpunkte), nicht über die Zeilen (Kanäle). Das zweite Argument `2` gibt
% die Dimension an, über die gemittelt wird. Das Ergebnis ist ein
% Spaltenvektor mit einem Wert pro Kanal.

%% Zusammenfassung
% In diesem Tutorial hast du gelernt:
%
% 1. **Die EEG‑Struktur**: Wie EEG‑Daten in EEGLAB organisiert sind (Felder
%    wie `EEG.data`, `EEG.srate`, `EEG.chanlocs`, etc.)
%
% 2. **Daten laden und inspizieren**: Wie du Daten lädst und mit `eegplot`,
%    `topoplot` und normalen Plot‑Funktionen visualisierst
%
% 3. **Ereignisse und Epochen**: Wie du Events inspizierst und mit `pop_epoch`
%    Epochen erstellst, und wie du mit `pop_rmbase` eine Baseline‑Korrektur
%    durchführst
%
% 4. **Vorverarbeitung**: Wie du mit `reref` re‑referenzierst und mit
%    `pop_eegfiltnew` filterst, und wie du mit `pop_select` Daten ausschneidest
%
% 5. **ERPs**: Wie du ERPs berechnest (durch Mittelung über Trials) und für
%    einzelne Kanäle oder als Topographien visualisierst
%
% Diese Funktionen wirst du später im Blockkurs häufig verwenden, wenn du mit
% echten EEG‑Daten arbeitest. Es lohnt sich, sich mit ihnen vertraut zu machen.

EXKURS Weitere Vorverarbeitungsschritte: In den Praxis‑Skripten wirst du auch
andere Vorverarbeitungsschritte kennenlernen, die hier nicht behandelt wurden:
- ICA (Independent Component Analysis) mit `pop_runica` und `pop_subcomp`
- Automatische Artefakterkennung mit `clean_artifacts` und `iclabel`
- Kanal‑Interpolation mit `eeg_interp`
Diese sind komplexer und werden in den Praxis‑Teilen des Blockkurses behandelt.
