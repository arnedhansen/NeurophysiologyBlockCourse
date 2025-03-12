%% Umsetzung und Auswertung von neurophysiologischen Experimenten
%
% Praxis V
% Frequenz-Analysen und Zeit-Frequenz-Analysen

%% SETUP

restoredefaultpath

% Clear all variables from the workspace
clear
% Clear the command window (the window at the bottom)
clc

% Change path into the directory of eeglab
addpath('eeglab2021.1')
eeglab;
close;

%% DATA IMPORT

pathToData='data/preprocessed_data';

% Lade alle Daten für Subject 002

load([pathToData  '/gip_sub-002.mat']);

%% Fourier Transformation

% Von Hand, etwas muehsam:
channel = 60; % Wir schauen uns das Ganze erstmal für eine Elektrode an
fft_res=abs(fft(EEG.data(channel,1:1000))); 
% Wir wählen abs(fft) für die Amplitude
% FFT liefert auch Phaseninformation - diese interessiert uns aber meist nicht

figure;
plot(fft_res)
% Schwer zu lesen!
% Ergebnis gespiegelt? -> weil 

fft_res=fft_res(1:500);
plot(fft_res)
% Mit Vorkenntnissen aus dem Blockkurs koennen wir aber berechnen um welche 
% Frequenzen es sich handelt:

% Wir haben 4-Sekunden-Zeitfenster und eine Abtastrate von 250 Hz
% Kleinste schaetzbare Frequenz = ??? Hz
% Frequenzauflösung = ??? Hz
% Groesste schaetzbare Frequenz = ??? Hz

frequenzen = XXX:XXX:XXX; %%%%% 0.25:0.25:125
figure;
plot(frequenzen,fft_res);

%% EEGLab kann das auch, besser, und gleichzeitg für alle Kanäle!

help spectopo
% Sind unsere EEG-Daten im 2D-Format (nchans, time_points)?
size(EEG.data)

[spec,freq] = spectopo(EEG.data(channel,1:1000),0,EEG.srate);
% Trick wurde angewandt! 
% Daten wurden in 4 x 1 sec Segmente unterteilt, FFT über
% diese 4 gemacht und gemittelt - deswegen schöneres, glatteres Resultat,
% aber schlechtere Frequenzauflösung

% FT gleichzeitig für alle Kanäle, über die gesamten Daten
figure;
[spec,freq] = spectopo(EEG.data,0,EEG.srate);

% Dimensionen von spec jetzt 70*126, freq bleibt unverändert, weil?
size(spec)

figure;
plot(freq,spec(60,:))

% Projekt Idee:
% Fourier Transformation fuer trials machen, in denen gesichter praesentiert
% wurden, und fuer trials in denen "scrambelled" gesichter praesentiert 
% wurden (aufpassen auf unterschiedliche anzahl von trials)
%-> Ergebnisse vergleichen (ausserdem, sinnvollere Elektrode, oder Cluster
% von Elektroden wählen)

%% Zeit-Frequenz-Analyse

%% Von Hand, für die ersten 20 sekunden, verwende 1 sek segmente

winSize = 250;

spec_tf = [];
freq_tf = [];

for i = 1:20
    start = (i-1)*winSize+1;
    stop = i*winSize;
    [spec_tf(:,i),freq_tf(i,:)] = spectopo(EEG.data(channel,start:stop),0,EEG.srate,'plot','off','winsize',winSize);
end

% Ergebnis ansehen (diesmal nur von 2-30Hz):

freq1 = find(freq_tf(1,:) == 2)
freq2 = find(freq_tf(1,:) == 30)

figure;
imagesc(spec_tf(freq1:freq2,:));
colorbar;

% Plot geht auch besser: Mit korrekter x-y Achsen Beschriftung

plotFreq=freq_tf(1,freq1:freq2);
zeit=[1:1:20];

% TODO: x / y durch korrkte variable ersetzen (zeit / plotFreq)

figure;
imagesc(zeit,plotFreq,spec_tf(freq1:freq2,:));
colorbar;
set(gca,'YDir','normal')

%%  Vergleich: Wieder die ersten 20 sekunden, diesmal 2 sek segmente

%TODO: ersetze XX, YY und YZ durch korrekte werte

winSizeB=500;

spec_tf2=[];
freq_tf2=[];

for i=1:10
    start = (i-1)*winSizeB+1;
    stop = i*winSizeB;
    [spec_tf2(:,i),freq_tf2(i,:)]=spectopo(EEG.data(channel,start:stop),0,250,'plot','off','winsize',winSizeB);
end

freq1B=find(freq_tf2(1,:)==2)
freq2B=find(freq_tf2(1,:)==30)

plotFreqB=freq_tf2(1,freq1B:freq2B);
zeitB=[1:2:20];


%TODO: x / y durch korrkte variable ersetzen (zeitB / plotFreqB)
figure;
imagesc(zeitB,plotFreqB,spec_tf2(freq1B:freq2B,:));
colorbar;
set(gca,'ydir','reverse')

%Frequenzaufloesung ist besser geworden, aber Zeitauflösung schlechter
% Und: Fuer alle frequenzen die wir geschätzt haben ist die Aufloesung
% genau die selbe

%% Man kann TF analysen von Hand programmieren, einfacher geht es aber
%% auch hier mit vorprogammierten Funktionen aus EEGLab. 

%% Neue Fragestellung, wie veraendert sich das Frequenzspektrum nach
%% Praesentation eines stimulus?

% Zuerst: Daten segmentieren!

EEGC_all = pop_epoch(EEG, {4,5,6,13,14,15,17,18,19}, [-0.4, 2.6]); 

nCycles=0; % Anazhl an Zylen für wavelet analyse -> 0 heisst: keine Zyklen -> stattdessen Short time Fourier Transformation

doc pop_newtimef

figure;
[ersp,~,~,times,freqs]=pop_newtimef(EEGC_all,1,channel,[-400, 2600],nCycles, 'freqs',[3,30],'plotphasesign','off','plotitc','off');
%Plot nicht schliessen
%Wie ist zeitauflösung, wie ist frequenzauflösung?

% Vergleiche Ergebnis mit Wavelet Analyse 

nCycles=3; %Wavelets mit 3 Zyklen
figure;
[erspWave,~,~,timesWave,freqsWave]=pop_newtimef(EEGC_all,1,channel,[-400, 2600],nCycles, 'freqs',[3,30],'plotphasesign','off','plotitc','off');

%man sieht: 
%1. Zeit teilweise abgeschnitten (wavelets müssen ganz reinpassen - whiteboard) 

% oben (hohe frequenzen), power wechselt schnell, gute
% Zeitauflösung, aber die langen "Streifen" zeigen dass man nicht wirklich
% unterscheiden kann zwischen den hohen frequenzen (zb. 20/30)

% unten (tiefe Frequenzen), power wechselt langsam (schlechte 
% Zeitaufloesung) 

%% Zum schluss: Hilbert transformation

% Fuer dieses Beispiel nehmen wir die alpha Oszillation über die
% ersten 10 sekunden

EEG_short=pop_select( EEG,'time',[0, 10] );

%zum alpha band filtern (8-13 Hz)

%TODO: Funktions-argumente ausfuellen)
EEG_short_filt=pop_eegfiltnew(EEG_short,8,13);

%plot: Daten vor und nach filtern 
figure;
plot(EEG_short.times,EEG_short.data(channel,:));
hold on;
plot(EEG_short_filt.times,EEG_short_filt.data(channel,:));

%--------------
% Alpha power extrahieren mit Hilbert Transformation

alphapow=abs(hilbert(EEG_short_filt.data(channel,:)));
%--------------

%Ergebnis visualisieren:

figure;
plot(EEG_short_filt.times,EEG_short_filt.data(channel,:));
%TODO
hold on;
plot(EEG_short_filt.times,alphapow)

% Projekt Idee:
% Das für alle Gesichter-trials machen und für alle "scrambled" Gesichter
% --> Resultat vergleichen