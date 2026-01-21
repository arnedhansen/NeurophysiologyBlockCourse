%% Vorbereitung
% 1) Daten Herunterladen
% https://www.dropbox.com/sh/ldpm2mobd3y62eb/AACy_gw9Wbfrbmpji9rAMoura?dl=0
% (sollte bereits erledigt sein)


%% Ordner struktur 

% Blockkurs Ordner
% -> Unterordner "Theorie" (Foliensätze)
% -> Unterordner: Praxis
%   -> Praxis1B_CodingIntro.m
%   -> Unterordner: "eeglab2021.1" 
%   -> Unterordner "data"  
%       -> Unterodrner "raw_data" (Hier heruntergaldene Daten reinkopieren)
%       -> Unterordner "preprocessed_data" (Hier heruntergaldene Daten reinkopieren)

%% Matlab script vs- Matlab Live script
% 1) Output erscheint auf Konsole
% 2) Es gibt nur noch Code, für regulären Text muss man Kommentare verwenden
% 3) Figures: In Live script erscheinen sie automatisch rechts, hier müssen
% wir zuerst leere figure öffnen (öffnet in neuem Fenster)
% 3) Es können Teile des Codes ausgeführt weden, auch wenn andere noch
% fehlerhaft sind
%   3a) Code markieren - Rechtsklick - Evaluate selection (siehe
%   Tastenkombination)
%   3b) Sections bilden

% Umfrage: Wie kompliziert war Umstieg von Tutorial (Live Script) zu Aufgabe
% (Script)

%% Hello world
disp('Hello world')

%% Operatoren

%arithmetisch
2+3
2*3
2/3

%logisch:
1>2
1<=1

1==2
2==2

%Neu: logische Operatoren können kombiniert werden

%Logisches UND
1<2 & (3+2)<4


%Beispiel aus dem Visuellen Arbeitsgedächtnisparadigma:
% wir wollen aktuelles Datensegment nur analysieren, wenn das EEG keine
% Artefakte anzeigt UND der Eyetracker keine Augenbewegungen während des
% Versuchsdurchgangs registriert hat

%Logisches ODER
1<2 | (3+2)<4

%Beispiel aus dem Visuellen Arbeitsgedächtnisparadigma:
% wir wollen aktuelles Datensegment analysieren wenn dabei zwei ODER vier
% Stimuli präsentiert wurden


%% Variablen
meineVar1= 8;
meineVar2= 10;
meineVar3= meineVar1+meineVar2; %Ergebnis von Berechnungen in Variable speichern

meineVar4= 'Acht';
%--> alle Variablen in Workspace sichtbar

%% Arrays (= Vektoren) 

meinArray=[3, 4, 5];
meinArray(2)

meineVar4(2) %War in Wirklichkeit auch ein array, an jedem eintrag steht ein Buchstabe

%% Inahlte von Variablen verbinden ("concatenate")
a='Hello';
b=[a, ' World '];
disp(b)

x1= [1, 2, 3];

c_wrong=[b, x1]; %sind zwei verschiedene datentypen
disp(c_wrong)

c=[b, num2str(x1)]; % Eckige klammern verbinden zahlen und zeichenketten
disp(c) 



%% Matrizen

x3=[1, 2, 3];
x4=[4, 5, 6];

%zuerst: zu Array verbinden  (horizontal)
array34=[x3,x4]

%zu Matrix verbinden (vertikal)
matrix34=[x3;x4]

%Versuche auf die Zahl 6 in matrix34 zuzugreifen: matrix(zeile,spalte)
matrix34( 2 , 3)

%% Funktionen / Methoden
% ..sind vorprogrammierter Code der gewisse Aufgaben (Funktionen) für uns
% erfüllt

% Beispiel: Mittelwert von x3
( x3(1) + x3(2) + x3(3) ) / 3 % Abstände (spaces) spielen keine Rolle


% Kann man auch einfacher haben, indem man Funktionen benutzt:
sum(x3)/3 % Funktionen ruft man mit runden klammern auf
mean(x3) 

% wir können uns den code auch ansehen (in den allermeisten Fällen)
open mean

disp(x3)


%% Wiederholung: Runde vs. eckige Klammern.

%Runde Klammern:

%Elemente aus Arrays/Matrizen abrufen ("indizieren"):
array34(5)

%Funktionen aufrufen
mean(array34)

%Eckige Klammern: 

% Elemente Verbinden
x5=[2, 3, 4];
x6=[x1,x3]

%erweiterung: Geschweifte klammern:
%Für arrays die verschiedenste Daten speichern können.
%Zuvor: z.B. nur Buchstaben, oder nur Zahlen

c_wrong(1)=1;
c_wrong(2)='Hello';

c_cell{1}=1;
c_cell{2}='Hello';


%% Schleifen / "Loops"

% Loop, die die zahlen 1 bis 10 auf dem Command Window ausgibt

for i=1:10

    disp(num2str(i)) 

end


meineVar=1;
for i=1:1:10 
% wenn man 1:10 schreibt, geschieht eigentlich das. Man könnte auch andere
% Schrittgrössen wählen, zb i=1:2:10

    disp(['Aktueller wert von i: ' num2str(i) ', aktueller Wert von meineVar: ' num2str(meineVar)]) 
    
    %variable jedes mal mit 2 multiplizieren
    meineVar=meineVar*2;
end



%% Kontrollstrukturen: if - else

%if else statement
zahl1=3;
zahl2=1;

if zahl1>zahl2
    disp('Wert in Variable zahl1 ist grösser als Wert in Variable zahl2');
else
    disp('Wert in Variable zahl1 ist kleiner oder gleich Wert in Variable zahl2');
end

%if else innerhalb einer Schleife
for i=1:10
    if i<5
        disp('i ist aktuell kleiner als 5')
    else
        disp('i is aktuell grösser oder gleichgross wie 5')
    end
end



%% Uebung: Schleifen, if - else

zahlen=[3, 4, 7, 1, 6, 10, 11, 13, 14];
summe=0;

% Aufgabe:
% Schleife bilden die über das Array "zahlen" geht, und dabei die ungeraden 
% Zalen aufaddiert. Danach soll das ergbnis ausgegeben werden

anzZahlen=length(zahlen);

for i = 1:anzZahlen
    rest=mod(zahlen(i),2); % Welcher Rest bleibt übrig wenn wir die 
                           % aktuelle Zahlt durch 2 teilen
    if  rest==1
        %Aktuelle Zahl aus dem Vektor/Array "zahlen" auslesen und zu
        %"summe" addieren
        summe=summe+zahlen(i);
        
    end
end

disp(['Die Summe der ungeraden zahlen lautet: ' num2str(summe)])
