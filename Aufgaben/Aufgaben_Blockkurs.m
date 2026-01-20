%% Aufgaben

% Im Folgenden werdet ihr das Wissen aus Tutorial 1: MATLAB und Tutorial 2:
% Digitale Signalverarbeitung anwenden. Ihr könnt natürlich immer in den
% Tutorials nachschauen, wenn ihr nicht mehr genau wisst, wie etwas
% programmiert werden soll.
% 
% Schreibt euren Code direkt in die Felder unterhalb der Frage. Bitte 
% stellt sicher, dass ihr alle Felder ausgefüllt habt, bevor ihr das Skript
% an Arne (arne.hansen@psychologie.uzh.ch) sendet.
%
% Um den Code hier laufen zu lassen, könnt ihr entweder auf den grünen Pfeil
% oben ('Run') drücken, oder in eine Aufgaben-Box klicken und oben 'Run
% Section' klicken. Falls ihr diese Buttons nicht oben sehen könnt, müsst
% ihr ganz oben in der blauen Leiste auf den Tab 'Editor' wechseln.

% Ihr könnt dann im Workspace (ganz rechts)
% kontrollieren, ob eure Variablen richtig abgespeichert sind.

%% 1.1 Variablen
% Erstelle eine Variable x und weise ihr den Wert 10 zu.



%% 1.2 Arrays und Matrizen
% Erstelle einen Zeilenvektor von 1 bis 10, einen Vektor mit allen Buchstaben
% des Alphabets und eine 3x3-Matrix (3 Zeilen, 3 Spalten) mit beliebigen 
% Zahlen. Speichere diese Matrix mit dem Variabelnamen M



%% 1.2.1 Konkatenieren
% Verknüpfe die Matrix M einmal mit einem neuen Spaltenvektor (Länge 3) 
% und einmal mit einem neuen Zeilenvektor (Länge 3). 
% (Diese Spalten/Zeilenvektoren können mit beliebigen Zahlen befüllt
% werden)



%% 1.3 Klammern & 1.4 Indizierung
% Greife auf das zweite Element deines Vektors aus Aufgabe 1.2 zu und 
% speichere es unter einem neuen Namen ab. Greife auf das Element in der 
% zweiten Zeile, dritten Spalte deiner Matrix aus Aufgabe 1.2 zu und 
% speichere es unter einem neuen Namen ab.



%% 1.5 Funktionen
% Benutze die mean Funktion um dir den Mittelwert von einem deiner oben
% erstellen Vektoren ausgeben zu lassen. Speichere das Resultat
% unter einem entsprechenden Namen ab und lass es dir mit 'disp' ausgeben.
% Versuche herauszufinden (google/chatGPT etc) mit welcher Funktion der
% Median ermittelt werden kann. Verwende diese um den Median des Vektors zu
% berechnen und ihn ebenfalls ausgeben zu lassen.



%% 1.6.1 if-else
% Erstelle eine Bedingung für den untenstehenden Code:
% Falls x grösser ist als 5, gib "Gross" aus, sonst "Klein".

x = 3;
if x 
    disp();
else
    disp();
end

%% 1.6.2 for-Loops
% Erstelle einen for-Loop, der in jeder Iteration (=Schlaufe) von 1:10 die 
% aktuelle Schlaufenzahl (i) + 1 ausgibt.

for i=1:10
    disp
end

%% OPTIONALE Zusatzaufgabe für Loops:
% Berechne die Summe der Zahlen von 1 bis 100 (d.h.: 1+2+3+4+5 etc) 
% mit einer for-Schleife. Lass dir das Ergebnis mit 'disp' ausgeben.

summe = 0;
for i=1:100
    summe = 
end
disp(['Summe: ', num2str(summe)]);

%% 1.7 Plotten
% Erstelle zwei beliebige Zahlenvektoren und visualisiere deren
% Zusammenhang (plotte die Werte des 1. Vektors auf der X Achse, 
% und die des zweiten auf der Y Achse.
% Füge einen Titel und die Achsenbeschriftungen hinzu.

figure; % Das öffnet hier eine leere Figur, sonst seht ihr nichts.
plot() % Hier einfüllen

%% (2.1 Sinuswellen)
% Hier ist noch mal der Code zur Visualisierung einer Sinuswelle
t = 0:0.001:1; % Zeitvektor von 0 bis 1 Sekunde in Schritten von 1ms (0.001s)
f = 5; % Frequenz der Sinuswelle in Hz
A = 1; % Amplitude

% Sinuswelle berechnen
y = A * sin(2 * pi * f * t);

figure;
plot(t, y, 'LineWidth', 2);
title('Sinuswelle (Frequenz = 5Hz, Amplitude = 1)');
xlabel('Zeit (s)');
ylabel('Amplitude');

%% 2.2 Frequenz
% Erstelle eine Sinuswelle mit einer Frequenz von 10 Hz und eine zweite 
% Sinuswelle mit 2 Hz. Visualisiere beide Wellen im gleichen Plot 
% (Tipp: 'hold on').



%% 2.3 Amplitude
% Erstelle eine Sinuswelle mit einer Amplitude von 2 und eine zweite 
% Sinuswelle mit 8. Visualisiere beide Wellen im gleichen Plot 
% (Tipp: 'hold on').



%%  2.4 Phase (Freiwillige Zusatzaufgabe)
% Erstelle eine Sinuswelle mit einer Phasenverschiebung von 0 und eine zweite 
% Sinuswelle mit einer Phasenverschiebung von 180°. Visualisiere beide Wellen 
% im gleichen Plot (Tipp: 'hold on').


