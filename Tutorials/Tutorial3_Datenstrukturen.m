%% Tutorial 3 – Datenstrukturen in MATLAB
% Dieses optionale Tutorial vertieft den Umgang mit Datenstrukturen in MATLAB,
% wie sie später in der EEG‑Analyse nützlich sind.
%
% Inhalte:
% 0. Einführung
% 1. Warum Datenstrukturen wichtig sind
% 2. Strukturen (struct)
%    2.1 Einfache Strukturen erstellen
%    2.2 Auf Felder zugreifen und ändern
%    2.3 Verschachtelte Strukturen
%    2.4 Beispiel: Mini‑EEG‑Struktur
% 3. Zell‑Arrays (cell)
%    3.1 Zell‑Arrays erstellen
%    3.2 Zell‑Arrays in der EEG‑Analyse
%    3.3 Zugriff auf Elemente: WICHTIGER UNTERSCHIED
% 4. Tabellen (table) für Verhaltensdaten
%    4.1 Tabellen erstellen
%    4.2 Filtern und sortieren
%    4.3 Tabellen mit weiteren Infos kombinieren
% 5. Mix aus allem: kleine EEG‑Studie modellieren
%    5.1 Schleife über alle Versuchspersonen
%    5.2 Ergebnisse in einer Tabelle zusammenfassen

%% 0. Einführung
% Bisher haben wir hauptsächlich mit einfachen Variablen gearbeitet: Zahlen,
% Vektoren und Matrizen. In der EEG‑Analyse arbeiten wir aber mit komplexen
% Daten, die aus vielen verschiedenen Informationen bestehen:
% - Messdaten (Zeit x Kanal x Versuch)
% - Metadaten (Subjekt, Bedingung, Alter, Geschlecht, ...)
% - Ereignisse (Trigger, Reaktionszeiten, ...)
%
% MATLAB bietet verschiedene Datentypen, um diese Informationen sinnvoll zu
% organisieren. In diesem Tutorial lernst du drei wichtige Datenstrukturen
% kennen: Strukturen (struct), Zell‑Arrays (cell) und Tabellen (table).
%
% Diese Tutorials sind so gestaltet, dass du nicht alles auswendig lernen musst.
% Vielmehr geht es darum, ein grundlegendes Verständnis dafür zu entwickeln,
% wie verschiedene Datenstrukturen funktionieren. Du wirst später im Blockkurs
% viele Gelegenheiten haben, das Gelernte anzuwenden.

%% 1. Warum Datenstrukturen wichtig sind
% Stelle dir vor, du hast Daten von mehreren Versuchspersonen (VPs) gesammelt:
% Reaktionszeiten, Genauigkeit, Alter, Geschlecht, Bedingung, etc. Wie könntest
% du diese Informationen speichern?
%
% Eine Möglichkeit wäre, für jede Information einen separaten Vektor anzulegen:

reaktionszeiten = [520 480 510 495];   % in Millisekunden
genauigkeit     = [1   0   1   1  ];   % 1 = korrekt, 0 = falsch
alter           = [23  25  22  30];    % Alter der VPs

mittelwert_rt = mean(reaktionszeiten)
mittelwert_acc = mean(genauigkeit)

% Das funktioniert, aber es wird schnell unübersichtlich, wenn du viele
% Informationen hast. Ausserdem musst du darauf achten, dass alle Vektoren die
% gleiche Länge haben und die Reihenfolge stimmt (z.B. dass die Reaktionszeit
% an Position 1 auch wirklich zu VP 1 gehört).
%
% Datenstrukturen helfen dir dabei, zusammengehörige Informationen zu gruppieren
% und den Code übersichtlicher zu machen. In diesem Tutorial lernst du drei
% wichtige Strukturen kennen: struct, cell und table.

%% 2. Strukturen (struct)
% Strukturen erlauben es, unterschiedliche Informationen unter einem Namen mit
% sogenannten Feldern (fields) zu speichern. Das ist vergleichbar mit einem
% "Ordner" für eine Versuchsperson, in dem verschiedene Informationen abgelegt
% sind.

%% 2.1 Einfache Strukturen erstellen
% Wir erstellen eine Struktur für eine Versuchsperson. Die Struktur heisst "vp1"
% und enthält verschiedene Felder, die wir mit einem Punkt (.) trennen.

vp1.id        = 1;
vp1.alter     = 23;
vp1.geschlecht = "w";
vp1.bedingung = "Stroop_kongruent";
vp1.reaktionszeiten = [520 480 510 495];
vp1.genauigkeit     = [1   0   1   1  ];

vp1   % Ausgabe der Struktur

% Wie du siehst, werden alle Informationen jetzt unter einem Namen "vp1"
% gespeichert. Die Struktur hat verschiedene Felder: id, alter, geschlecht,
% bedingung, reaktionszeiten und genauigkeit. Jedes Feld kann einen anderen
% Datentyp enthalten (Zahl, Text, Vektor).

%% 2.2 Auf Felder zugreifen und ändern
% Auf Felder einer Struktur greift man mit Punktnotation zu. Du gibst einfach
% den Namen der Struktur, dann einen Punkt, dann den Namen des Feldes an.

vp1.alter
vp1.reaktionszeiten

% Du kannst Felder auch ändern, indem du ihnen einen neuen Wert zuweist:

vp1.alter = 24;

% Und du kannst jederzeit neue Felder hinzufügen:

vp1.handedness = "rechts";

vp1   % Die Struktur enthält jetzt auch das neue Feld "handedness"

% WICHTIGER HINWEIS: Strukturen sind sehr flexibel. Du kannst jederzeit neue
% Felder hinzufügen, aber achte darauf, dass du die Schreibweise konsistent
% hältst (z.B. immer "geschlecht" und nicht mal "geschlecht", mal "Geschlecht").

%% 2.3 Verschachtelte Strukturen
% Strukturen können wiederum andere Strukturen als Felder enthalten. Das ist
% praktisch, um Informationen zu gruppieren.

vp1.demografie.alter      = 24;
vp1.demografie.geschlecht = "w";

vp1.experiment.bedingung  = "Stroop_kongruent";
vp1.experiment.session    = 1;

vp1.demografie
vp1.experiment

% Hier haben wir die Informationen in Unterstrukturen organisiert: "demografie"
% enthält alle demografischen Informationen, "experiment" alle
% versuchsbezogenen Informationen. Das macht den Code übersichtlicher, wenn du
% viele Informationen hast.

%% 2.4 Beispiel: Mini‑EEG‑Struktur
% In EEGLAB werden EEG‑Daten in einer grossen Struktur `EEG` gespeichert. Wir
% bauen hier eine stark vereinfachte Version nach, damit du verstehst, wie
% solche Strukturen aufgebaut sind.

EEG_mini.srate   = 250;                  % Samplingrate (Abtastrate) in Hz
EEG_mini.chanlocs = ["Fz","Cz","Pz"];    % Kanalnamen (channel locations)
EEG_mini.data    = randn(3, 2500);       % 3 Kanäle x 2500 Zeitpunkte
EEG_mini.times   = (0:2499) / EEG_mini.srate * 1000; % Zeit in ms

size(EEG_mini.data)

% Die Struktur `EEG_mini` enthält jetzt verschiedene Informationen über unsere
% EEG‑Daten: die Samplingrate (srate), die Kanalnamen (chanlocs), die
% eigentlichen Messdaten (data) und einen Zeitvektor (times). Später im
% Blockkurs wirst du mit echten EEG‑Strukturen arbeiten, die noch viel mehr
% Felder enthalten (z.B. Events, Epochen, ICA‑Komponenten, etc.).

%% 3. Zell‑Arrays (cell)
% Zell‑Arrays (cell arrays) erlauben es, Elemente verschiedener Grösse oder
% Typs in einer "Matrix" zu speichern. Der Zugriff erfolgt mit geschweiften
% Klammern {} statt runden Klammern ().

%% 3.1 Zell‑Arrays erstellen
% Beispiel: verschiedene Instruktionstexte, die unterschiedlich lang sind

instruktionen = { ...
    "Bitte so schnell und genau wie möglich antworten."; ...
    "Machen Sie zwischendurch Pausen, wenn Sie müde werden."; ...
    "Fixieren Sie den Punkt in der Bildschirmmitte."};

instruktionen{1}

% Wie du siehst, verwenden wir geschweifte Klammern {} zum Erstellen und zum
% Zugriff auf Elemente eines Zell‑Arrays. Das erste Element ist ein längerer
% Text, das zweite ein noch längerer Text, das dritte ein kürzerer Text. In
% einer normalen Matrix müssten alle Zeilen gleich lang sein, hier können sie
% unterschiedlich lang sein.

%% 3.2 Zell‑Arrays in der EEG‑Analyse
% Zell‑Arrays sind besonders nützlich, wenn du pro Bedingung eine
% unterschiedliche Anzahl an Trials hast. Beispielsweise könnte Bedingung 1
% vier Trials haben, Bedingung 2 nur drei Trials und Bedingung 3 fünf Trials.

rt_bedingung = cell(1,3);  % Erstelle ein Zell‑Array mit 1 Zeile und 3 Spalten

rt_bedingung{1} = [520 480 510 495];      % Bedingung 1: 4 Trials
rt_bedingung{2} = [610 590 620];          % Bedingung 2: 3 Trials
rt_bedingung{3} = [700 710 690 705 695];  % Bedingung 3: 5 Trials

% Anzahl der Trials pro Bedingung
anzahl_trials = cellfun(@length, rt_bedingung)

% Die Funktion `cellfun` wendet eine Funktion (hier `length`) auf jedes Element
% eines Zell‑Arrays an. Das Ergebnis ist ein normaler Vektor mit der Länge
% jedes Elements. Du siehst: Bedingung 1 hat 4 Trials, Bedingung 2 hat 3
% Trials, Bedingung 3 hat 5 Trials.

%% 3.3 Zugriff auf Elemente: WICHTIGER UNTERSCHIED
% Das ist ein häufiger Anfängerfehler! Es gibt einen wichtigen Unterschied
% zwischen runden Klammern () und geschweiften Klammern {}:

rt_bed1_cell = rt_bedingung(1)    % gibt eine 1x1 Zelle zurück (noch immer ein Zell‑Array!)
rt_bed1_vec  = rt_bedingung{1}    % gibt den Zahlenvektor zurück (den Inhalt der Zelle)

% Mit runden Klammern (1) greifst du auf das Element als Zelle zu – du bekommst
% also wieder ein Zell‑Array zurück. Mit geschweiften Klammern {1} greifst du
% auf den Inhalt der Zelle zu – du bekommst also den Zahlenvektor zurück.
%
% Wenn du mit den Daten rechnen möchtest (z.B. den Mittelwert berechnen),
% brauchst du geschweifte Klammern:

mittelwerte_rt = cellfun(@mean, rt_bedingung)

% Die Funktion `cellfun` mit `@mean` berechnet automatisch den Mittelwert für
% jedes Element im Zell‑Array. Das Ergebnis ist ein Vektor mit den
% Mittelwerten: [501.25, 606.67, 700.00] (gerundet).

EXKURS Geschweifte Klammern vs. runde Klammern: Dieser Unterschied ist sehr
wichtig und wird oft übersehen! Stelle dir ein Zell‑Array wie eine Schachtel
mit mehreren Fächern vor. Mit runden Klammern (1) nimmst du die ganze Schachtel
heraus (du bekommst also wieder eine Schachtel zurück). Mit geschweiften
Klammern {1} öffnest du die Schachtel und nimmst den Inhalt heraus (du bekommst
also den eigentlichen Inhalt – z.B. einen Zahlenvektor – zurück). Wenn du mit
den Daten rechnen möchtest, brauchst du immer den Inhalt, also geschweifte
Klammern.

%% 4. Tabellen (table) für Verhaltensdaten
% Tabellen (tables) sind praktisch, um Versuchspersonen‑ und Versuchs‑Daten in
% einer Form ähnlich wie in Excel zu organisieren. Jede Spalte kann einen
% anderen Datentyp haben, und du kannst leicht filtern, sortieren und
% kombinieren.

%% 4.1 Tabellen erstellen
% Wir erstellen eine Tabelle mit Informationen über mehrere Versuchspersonen:

vp_id   = [1; 2; 3; 4];
alter   = [23; 25; 22; 30];
bedingung = ["A"; "A"; "B"; "B"];
mittel_rt = [500; 520; 540; 560];

T = table(vp_id, alter, bedingung, mittel_rt, ...
    'VariableNames', {'VP','Alter','Bedingung','Mittel_RT'});

T

% Wie du siehst, wird die Tabelle ähnlich wie eine Excel‑Tabelle dargestellt:
% jede Zeile ist eine Versuchsperson, jede Spalte ist eine Variable. Die
% Spaltennamen haben wir mit 'VariableNames' festgelegt. WICHTIG: Bei Tabellen
% müssen alle Spalten die gleiche Anzahl an Zeilen haben (hier: 4 Zeilen).

%% 4.2 Filtern und sortieren
% Tabellen machen es einfach, Daten zu filtern und zu sortieren. Beispielsweise
% können wir nur die Versuchspersonen aus Bedingung A anzeigen:

T_A = T(T.Bedingung == "A", :)

% Die Syntax `T.Bedingung == "A"` erstellt einen logischen Vektor (true/false),
% der angibt, welche Zeilen die Bedingung "A" haben. Mit `:` sagen wir, dass
% wir alle Spalten behalten möchten. Das Ergebnis ist eine neue Tabelle mit nur
% den Zeilen, die Bedingung "A" haben.
%
% Wir können die Tabelle auch nach Reaktionszeit sortieren:

T_sort = sortrows(T, "Mittel_RT", "ascend")

% Die Funktion `sortrows` sortiert die Zeilen einer Tabelle nach einer
% bestimmten Spalte. "ascend" bedeutet aufsteigend (kleinste RT zuerst),
% "descend" würde absteigend bedeuten (grösste RT zuerst).

%% 4.3 Tabellen mit weiteren Infos kombinieren
% Angenommen, wir haben eine zweite Tabelle mit z.B. Fragebogenwerten. Wir
% können diese Tabellen zusammenführen:

fragebogen = table([1;2;3;4], [12;18;15;10], ...
    'VariableNames', {'VP','Stress_Skala'});

fragebogen

% Tabellen anhand der VP‑ID zusammenführen:

T_merged = join(T, fragebogen, 'Keys', 'VP')

T_merged

% Die Funktion `join` verbindet zwei Tabellen anhand einer gemeinsamen Spalte
% (hier: 'VP'). Das Ergebnis ist eine neue Tabelle, die alle Spalten aus beiden
% Tabellen enthält. Versuchspersonen, die nur in einer Tabelle vorkommen,
% werden nicht übernommen (das ist ein "inner join" – es gibt auch andere
% Join‑Typen, die wir hier aber nicht brauchen).

%% 5. Mix aus allem: kleine EEG‑Studie modellieren
% Jetzt kombinieren wir alles, was wir gelernt haben, und erstellen eine
% Datenstruktur für mehrere Versuchspersonen. Das ist ähnlich zu dem, was du
% später im Blockkurs machen wirst, wenn du Daten von mehreren VPs analysierst.

anzahl_vp = 3;
vp = struct();  % Erstelle eine leere Struktur

for i = 1:anzahl_vp
    vp(i).id        = i;
    vp(i).alter     = randi([20 35]);  % Zufälliges Alter zwischen 20 und 35
    vp(i).bedingung = randsample(["A","B"],1);  % Zufällige Bedingung A oder B
    vp(i).rt        = 400 + randn(1,20)*30;  % 20 Trials mit zufälligen RTs
end

vp

% Hier haben wir eine Struktur erstellt, die mehrere Versuchspersonen enthält.
% Jede Versuchsperson ist ein Element im Array `vp`. `vp(1)` ist die erste VP,
% `vp(2)` die zweite VP, etc. Jede VP hat die Felder id, alter, bedingung und
% rt (Reaktionszeiten als Vektor mit 20 Trials).
%
% WICHTIGER HINWEIS: `vp` ist ein Array von Strukturen. Das bedeutet, dass `vp`
% selbst ein Array ist (wie ein Vektor), aber jedes Element ist eine Struktur.
% Du kannst auf die Struktur der ersten VP mit `vp(1)` zugreifen und dann auf
% ihre Felder mit `vp(1).alter`, `vp(1).rt`, etc.

%% 5.1 Schleife über alle Versuchspersonen
% Jetzt können wir über alle Versuchspersonen iterieren und z.B. die
% Mittelwerte berechnen:

for i = 1:anzahl_vp
    fprintf("VP %d (Bedingung %s): mittlere RT = %.1f ms\n", ...
        vp(i).id, vp(i).bedingung, mean(vp(i).rt));
end

% Die Funktion `fprintf` gibt formatierte Textausgaben aus. `%d` steht für eine
% ganze Zahl, `%s` für Text, `%.1f` für eine Dezimalzahl mit einer
% Nachkommastelle. `\n` erzeugt einen Zeilenumbruch.
%
% Du siehst, dass jede VP eine andere mittlere Reaktionszeit hat (weil wir
% zufällige Werte generiert haben). In echten Daten würdest du hier die
% tatsächlichen Mittelwerte sehen.

%% 5.2 Ergebnisse in einer Tabelle zusammenfassen
% Oft möchtest du die Ergebnisse aller Versuchspersonen in einer Tabelle
% zusammenfassen. Das geht so:

vp_id   = (1:anzahl_vp)';
alter   = arrayfun(@(x)x.alter, vp)';
bed     = string({vp.bedingung})';
mittel_rt = arrayfun(@(x)mean(x.rt), vp)';

ErgebnisTabelle = table(vp_id, alter, bed, mittel_rt, ...
    'VariableNames', {'VP','Alter','Bedingung','Mittel_RT'})

ErgebnisTabelle

% Das sieht kompliziert aus, aber Schritt für Schritt:
% - `arrayfun(@(x)x.alter, vp)` wendet eine Funktion auf jedes Element von `vp`
%   an und extrahiert das Feld `alter`
% - `string({vp.bedingung})` konvertiert die Bedingungswerte zu Strings
% - `arrayfun(@(x)mean(x.rt), vp)` berechnet den Mittelwert der RTs für jede VP
% - Das `'` am Ende transponiert die Vektoren zu Spaltenvektoren (für die Tabelle)
%
% Das Ergebnis ist eine übersichtliche Tabelle mit allen wichtigen Informationen
% über die Versuchspersonen. Diese Tabelle kannst du dann z.B. in R oder Python
% weiterverwenden oder als CSV‑Datei speichern.

EXKURS arrayfun und cellfun: Diese Funktionen sind sehr nützlich, wenn du
Operationen auf alle Elemente eines Arrays oder Zell‑Arrays anwenden möchtest.
`arrayfun` funktioniert mit normalen Arrays (z.B. Arrays von Strukturen),
`cellfun` funktioniert mit Zell‑Arrays. Die Syntax `@(x)x.alter` ist eine
sogenannte anonyme Funktion (anonymous function): sie nimmt ein Element `x` und
gibt `x.alter` zurück. Du könntest das auch mit einer normalen for‑Schleife
machen, aber `arrayfun` und `cellfun` sind oft kürzer und lesbarer.

%% Zusammenfassung
% In diesem Tutorial hast du drei wichtige Datenstrukturen kennengelernt:
%
% 1. **Strukturen (struct)**: Organisieren zusammengehörige Informationen unter
%    einem Namen mit Feldern. Praktisch für Versuchspersonen oder EEG‑Daten.
%
% 2. **Zell‑Arrays (cell)**: Erlauben es, Elemente verschiedener Grösse oder
%    Typs zu speichern. Praktisch, wenn du z.B. pro Bedingung unterschiedlich
%    viele Trials hast.
%
% 3. **Tabellen (table)**: Organisieren Daten ähnlich wie Excel‑Tabellen.
%    Praktisch für Verhaltensdaten, die du filtern, sortieren und kombinieren
%    möchtest.
%
% Diese Strukturen wirst du später im Blockkurs häufig verwenden, besonders
% wenn du mit EEG‑Daten arbeitest. Die EEGLAB‑Struktur `EEG` ist selbst eine
% grosse Struktur mit vielen Feldern, und du wirst oft Tabellen verwenden, um
% Ergebnisse von mehreren Versuchspersonen zu organisieren.
