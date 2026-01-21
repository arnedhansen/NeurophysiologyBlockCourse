%% Vorbereitung


% Dieser code bewirkt, dass Matlab immer in den richtigen Ordner springt
editorFile = matlab.desktop.editor.getActiveFilename;
cd(fileparts(editorFile))

restoredefaultpath

% Alle Variablen die evtl., noch im Workspace bestehen löschen
clear
% Das "Command Window" leeren
clc


%% Pfade vorbereiten

% Pfad zu den Daten
pathToData='data/preprocessed_data'; 

% Pfad zu EEGlab
addpath('eeglab2021.1')
%Danach wird matlab eeglab öffnen können, jedoch noch nicht alle Funktionen
%wie Filter etc verwenden können.

% EEGlab öffnen und schliessen (damit werden alle wichtigen Funktionen zum
% Pfad hinzugefügt)
eeglab
close;

%% interate over all subjects
% list files in directory
d = dir([pathToData, filesep, '*sub*']);
d(1).name
d(1).folder

tic
clear ERP1 ERP2 ERP3 ERP1_65 ERP2_65 ERP3_65
for sub = 1 : size(d, 1) 
    
    disp(sub)
    
    % load EEG data
    load(fullfile(d(sub).folder, d(sub).name))

    % epoch
    % OUTEEG = pop_epoch( EEG, events, timelimits);
    EEGC1 = pop_epoch(EEG, {5, 6, 7}, [-0.2 0.8]); % familiar
    EEGC2 = pop_epoch(EEG, {13, 14, 15}, [-0.2 0.8]); % unfamiliar
    EEGC3 = pop_epoch(EEG, {17, 18, 19}, [-0.2 0.8]); % scrambled

    % basline correction
    EEGC1 = pop_rmbase(EEGC1, [-200 0]);
    EEGC2 = pop_rmbase(EEGC2, [-200 0]);
    EEGC3 = pop_rmbase(EEGC3, [-200 0]);

    % compute means: cond 1
    ERP1(sub, :, :) = mean(EEGC1.data(:, :, :), 3);
    ERP2(sub, :, :) = mean(EEGC2.data(:, :, :), 3);
    ERP3(sub, :, :) = mean(EEGC3.data(:, :, :), 3);
    
    % electrode 65
    i65 = find(ismember({EEGC1.chanlocs.labels}, 'EEG065'));

    ERP1_65(sub, :) = mean(EEGC1.data(i65, :, :), 3);
    ERP2_65(sub, :) = mean(EEGC2.data(i65, :, :), 3);
    ERP3_65(sub, :) = mean(EEGC3.data(i65, :, :), 3);

end
toc

%% Plotten
% variability between subjects
figure;
subplot(3, 1, 1)
plot(EEGC1.times, ERP1_65)
title('Familiar')
subplot(3, 1, 2)
plot(EEGC1.times, ERP2_65)
title('Unfamiliar')
subplot(3, 1, 3)
plot(EEGC1.times, ERP3_65)
title('Scrambled')
xlabel('Time (ms)')
sgtitle('Variability between subjects across conditions')

% grand average across conditions
GM1 = squeeze(mean(ERP1, 1));
GM2 = squeeze(mean(ERP2, 1));
GM3 = squeeze(mean(ERP3, 1));

% EKP plotten using GM
figure;
plot(EEGC1.times, GM1(61, :), 'LineWidth', 1, 'Color', 'red') % try setting LineWidth to 2
hold on
plot(EEGC1.times, GM2(61, :), 'Color', 'blue')
plot(EEGC1.times, GM3(61, :))
xlabel('Time (ms)')
ylabel('Voltage')
set(gca, 'FontSize', 16)
set(gcf, 'Color', 'w')
legend('familiar', 'unfamiliar', 'scrambled')

% EKP plotten EEG065
figure;
plot(EEGC1.times, mean(ERP1_65, 1), 'LineWidth', 2, 'Color', 'red')
hold on
plot(EEGC1.times, mean(ERP2_65, 1), 'Color', 'blue')
plot(EEGC1.times, mean(ERP3_65, 1))
xlabel('Time (ms)')
ylabel('Voltage')
set(gca, 'FontSize', 16)
legend('familiar', 'unfamiliar', 'scrambled')

%% Topography
figure; 
topoplot([],EEGC1.chanlocs, 'style','blank','electrodes','labels'); % blank topo

a = find(EEGC1.times == 152, 1) % find time points between 152ms 
b = find(EEGC1.times == 212, 1) % and 212 ms (time window around N170 peak)

figure; 
topoplot(mean(GM1(:, a:b), 2),EEGC1.chanlocs,'electrodes','on'); % mean(GM1(:, a:b), 2) => average over time window = [152 : 212]
colorbar;
% für extra punkte: colorbar zu red-white-blue ändern

%% shaded error bar
figure;
% Input: 1. time, 2. data, 3. standard fehler = standardabweichung / sqrt(n)
shadedErrorBar(EEGC1.times, mean(ERP1_65, 1), std(ERP1_65)/sqrt(size(ERP1_65, 1)),'lineprops','b', 'patchSaturation', 0.05);
hold on
shadedErrorBar(EEGC2.times, mean(ERP2_65, 1), std(ERP2_65)/sqrt(size(ERP2_65, 1)), 'lineprops','r', 'patchSaturation', 0.05);
shadedErrorBar(EEGC3.times, mean(ERP3_65, 1), std(ERP3_65)/sqrt(size(ERP3_65, 1)), 'lineprops','g', 'patchSaturation', 0.05);
alpha(0.3)
legend('familiar', 'unfamiliar', 'scrambled')
xlabel('Time (ms)')
ylabel('Voltage')
set(gcf, 'color', 'w')
set(gca, 'FontSize', 16)

%% end