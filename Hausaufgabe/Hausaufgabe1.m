%% FREIWILLIGE Hausaufgabe 1
%
% Die folgenden Aufgaben dienen dazu, die in dieser Praxis gelernten
% Konzepte eigenständig zu vertiefen. Viel Erfolg!
%
% -----------------------------------------------------------------------
% Aufgabe 1: Einen anderen Datensatz (anderes Subject) laden und inspizieren
% -----------------------------------------------------------------------
% a) Lade einen anderen Datensatz aus dem Ordner 'data/preprocessed_data'.
%    Tipp: Schau nach, welche Dateien dort verfügbar sind (z.B. mit "dir").
%
% b) Wie viele Kanäle und wie viele Datenpunkte hat dieser Datensatz?
%    Nutze die Funktion "size" auf EEG.data und EEG.chanlocs.
%
% c) Wie hoch ist die Abtastrate (Sampling Rate)?
%


% -----------------------------------------------------------------------
% Aufgabe 2: Zeitverlauf mehrerer Kanäle vergleichen
% -----------------------------------------------------------------------
% a) Wähle drei beliebige Kanäle aus und plotte deren Zeitverläufe
%    für die Datenpunkte 1 bis 1000 in einer einzigen Abbildung. Hinweis:
%    'hold on'. (optional: Verwende unterschiedliche Farben für jeden Kanal.)
%
% b) Füge eine Legende hinzu, die die Kanalnamen anzeigt.
%    Tipp: Die Kanalnamen findest du in EEG.chanlocs(kanal).labels
%
% c) Beschrifte die Achsen sinnvoll (x-Achse: Zeit in ms, y-Achse: uV).
%
% Dein Code hier:





% -----------------------------------------------------------------------
% Aufgabe 3: Topographien zu verschiedenen Zeitpunkten
% -----------------------------------------------------------------------
% a) Erstelle eine Abbildung mit 4 Subplots (2x2), die jeweils eine
%    Topographie zu einem anderen Zeitpunkt zeigen:
%    - Datenpunkt 100
%    - Datenpunkt 500
%    - Datenpunkt 1000
%    - Datenpunkt 2000
%
% b) Jeder Subplot soll einen Titel haben, der den Zeitpunkt in
%    Millisekunden angibt (nicht den Datenpunkt!).
%    Tipp: Nutze EEG.times, um den Datenpunkt in ms umzurechnen.
%
% c) Optional: Verwende die Mittelwertsreferenz für alle vier Topographien.
%
% Dein Code hier:




