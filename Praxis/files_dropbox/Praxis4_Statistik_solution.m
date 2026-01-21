%% Vorbereitung: Ausnahme!

% Diese mal löschen wir den Inhalt der workspace nicht, und setzen die
% Pfade nicht erneut, da wir direkt mit den Daten aus Praxis3_EKP
% weiterarbeiten wollen


% Zur Erinerung:
% C1= familiar, C2= unfamiliar, C3=scrambled

%% Teil 1: Hypothesegetrieben: Ttest, ANOVA und lineares Modell

%% 1A) Vorbereitung: Peaks finden:

% Zuerst: Mittelwert über alle conditions berechnen, hier suchen wir nach
% den maximalen auschlägen im EKP

%Schritt A: Mittelwert über Bedingungen
subjMeanERP = (ERP1_65 + ERP2_65 + ERP3_65) / 3;

% Schritt B: Mittelwert über Versuchspersonen
GA = mean(subjMeanERP, 1);

%. ... und visualisieren:
figure;
plot(EEGC1.times, GA);

% Wir könnten Zeit des kleinsten Wertes ablesen, oder wir extrahieren ihn
% aus den Daten:
[val, lat] = min(GA)
% wichtig: "min" funktion weiss nichts über EEG Daten oder zeit, wird uns
% einfach den Datenpunkt (sample) geben welcher den kleinsten wert hat

% Wann (in ms) tritt der kleinste wert auf?
EEGC1.times(lat)

% Da das EEG Signal oft ein wenig verrauscht ist, mitteln wir ein paar
% Samples / Datenpunkte um den Minimalwert:

startLat = lat - 5;
endLat = lat + 5;

% sanity check plot
figure;
plot(EEGC1.times, GA)
hold on
xline(EEGC1.times(startLat));
xline(EEGC1.times(endLat));


% Jetzt: Mittelwert um N170 (von startLat bis endLat) für jede 
% Versuchsperson (und pro Bedingung) berechnen

for sub = 1:10
    avgpeakC1(sub) = mean(ERP1_65(sub,startLat : endLat), 2);
    avgpeakC2(sub) = mean(ERP2_65(sub,startLat : endLat), 2);
    avgpeakC3(sub) = mean(ERP3_65(sub,startLat : endLat), 2);
end


%% 1B) Peaks aller 3 Bedingungen vergleichen: ANOVA

% ANOVA
[p,tbl] = anova1([avgpeakC1;avgpeakC2;avgpeakC3]'); 

% Problem hier?
% Antwort: Daten jeder Versuchsperson werden als unabhängig betrachtet
% Tatsächlich unterschätzen wir so die effekte wenn wir between subject
% varianz mit in den eigentlichen within subject vergleich vermischen

% Lösung: rmANOVA (Lassen wir für jetzt aus, etwas umständlich in MATLAB aufzusetzen)
%èberspringen wir da wir sowieso nachher das bessere lineare modell aufsetzen 

% T = table(avgpeakC1', avgpeakC2', avgpeakC3','VariableNames',{'avgpeakC1','avgpeakC2','avgpeakC3'});
% within = table([1; 2; 3], 'VariableNames', {'Condition'});
% rm = fitrm(T, 'avgpeakC1,avgpeakC2,avgpeakC3 ~ 1', 'WithinDesign', within);
% ranovatbl = ranova(rm);
% disp(ranovatbl);

% Aber: Wir nehmen einfach an wir hätten eigentlich signifikante ANOVA 
% Effekte --> Knnen post-hoc ttest für verbundene stichproben durchführen

%% 1C) Post-hoc tests - Ttests:


% ttest
[h,p1,ci,stats] = ttest(avgpeakC1,avgpeakC2); % nonsigificant: familiar vs unfamiliar
disp(p1)

[h,p2,ci,stats] = ttest(avgpeakC1,avgpeakC3); % significant: familar vs scrambled
disp(p2)

[h,p3,ci,stats] = ttest(avgpeakC2,avgpeakC3); % significant: unfamilar vs scrambled
disp(p3)

% Aufgabe: statt ttest für verbundene stichproben, vergleich von C1 und C3 
% mit ttest für unabhängige stichproben durchführen, p werte vergleichen
[h,p2b,ci,stats] = ttest2(avgpeakC1,avgpeakC3); % significant
disp(p2b)

%% 1D) Bonferroni Korrektur:
alpha = 0.05; % Significance level
numComparisons = 3; % Number of t-tests
p1 = alpha / numComparisons

p1<correctedAlpha
p2<correctedAlpha
p3<correctedAlpha



%%  1E) Besser als ANOVA: Gemischtes Lineares Modell:

% Dafür Vorbereitung: Daten in Tabelle organisieren:

tbl= table();
tbl.N170=double([avgpeakC1, avgpeakC2, avgpeakC3])'; % ' --> transponiert den vektor
tbl.condition =[ones(1,10), ones(1,10)*2, ones(1,10)*3]';
tbl.subject=[1:10, 1:10, 1:10]';

tbl.condition=categorical(tbl.condition);
tbl.subject=categorical(tbl.subject);


mdl=fitlme(tbl,'N170 ~ condition + (1|subject)')

% Gibt uns nicht wirklich das was wir wissen wollten.
% Sagt uns stattdessen: 

% 1.) Bei familiar faces hat die N170 im Mittel den Wert -6.24.
% 2.) Bei unfamilair gibt es eine leichte Abnahme (mitteler N170 ist 0.36
%     kleiner) im vergleich zu familair -> Aber das ist nicht signifikant
% 3.) scrambled hat im Vergleich zu familair faces (referenzkategorie) eine 
%     N170, die um 1.5 grösser (weniger negativ) ist, das ist signifikant

% Wir wollten aber wissen ob es generell einen einfluss der
% Versuchsbedingungen gibt:

mdlReduced = fitlme(tbl, 'N170 ~ 1 + (1|subject)') %Modell ohne echten prädiktor

% Output sagt uns nur, dass der Intercept (mittelwert über alle Bedingungen)
% -5.86 ist.
% Wir bekommen dennoch einen model fit von AIC = 127,68. 
% Dieser model fit sagt uns wie gut ein Modell die daten vorhersagt, das
% jeden Wert durch den mittelwert aller Daten (-5.86) vorhersagt

comparison = compare(mdlReduced, mdl); % Macht einen likelyhood ratio test um zu sehen ob das grössere moell die Daten signifikant besser erklärt.
disp(comparison);
comparison.pValue(2)




%% Teil 2: Datengetrieben / "Mass univariate": Lineares modell + Korrektur für multiples testen 

%%  Lineare Modelle für alle Zeitpunkte schätzen

%% 2A)  Neue tabelle vorbereiten:

tbl2= table();
tbl2.condition =[ones(1,10), ones(1,10)*2, ones(1,10)*3]';
tbl2.subject=[1:10, 1:10, 1:10]';

tbl2.condition=categorical(tbl2.condition);
tbl2.subject=categorical(tbl2.subject);

%% 2B) Teste lineares modell für Ersten zeitpunkt

% in das "ERP" Feld der tabelle den aktuellen wert des ERPs einsetzen
t=1; %erstes sample auswählen
tbl2.ERP= double([ERP1_65(:,t); ERP2_65(:,t); ERP3_65(:,t)]);

% jetzt Modelle zum zeitpunkt t fitten und Vergleichen:
mdl_full=fitlme(tbl2,'ERP ~ condition + (1|subject)');
mdl_small=fitlme(tbl2,'ERP ~ 1 + (1|subject)');
comparison_all=compare(mdl_small,mdl_full);
comparison_all.pValue(2)


%% 2C) TODO: Jetzt Diesen Code für alle Zeitpunkte laufen lassen:
% und jeweils den resultierenden p wert im Vektor "p_all" abspeichern

nTimePoints=length(ERP1_65);
tic;
for t = 1:nTimePoints

    tbl2.ERP= double([ERP1_65(:,t); ERP2_65(:,t); ERP3_65(:,t)]);

    mdl_full=fitlme(tbl2,'ERP ~ condition + (1|subject)');
    mdl_small=fitlme(tbl2,'ERP ~ 1 + (1|subject)');
    comparison_all=compare(mdl_small,mdl_full);
    p_all(t)= comparison_all.pValue(2);

end
toc;


%% 2D) Visualisiere Zeitverlauf der unkorrigierten p werte:

figure;
plot(EEGC1.times, p_all)

%gebe aus wieviele tests insgesamt signifikant waren
sum(p_all<0.05)


%% 2E) Korrektur für multiples Testen (250 tests)
which mafdr

p_all_fdr = mafdr(p_all, 'BHFDR', true);

figure;
plot(EEGC1.times, p_all);
hold on;
plot(EEGC1.times, p_all_fdr);
yline(0.05)
legend('Unkorrigiert', 'Nach FDR','0.05 cut off')

sum(p_all_fdr<0.05)

% Viel noch signifikant, aber zum Beispiel:
% Zufällige Effekte, die vor der Stimuluspräsentation stattfinden (können 
% nicht echt sein) verschwinden grösstenteils


