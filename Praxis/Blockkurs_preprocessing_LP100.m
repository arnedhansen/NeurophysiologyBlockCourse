% Blockkurs preprocessing for Gamma (LP100)
clear
clc
close all

%% Setup
pathToDataRaw      = 'data/raw/';
pathToDataCleanLP100 = 'data/preproLP100/';
addpath('eeglab2025.1')
eeglab;
close;
CRDpath = 'eeglab2025.1/plugins/clean_rawdata';
addpath(genpath(CRDpath));
addpath(genpath(['eeglab2025.1' filesep 'plugins' filesep 'zapline-plus']));
addpath(genpath(['eeglab2025.1' filesep 'plugins' filesep 'ICLabel']));

subjects = {'sub-002','sub-003','sub-004','sub-005', 'sub-006','sub-007','sub-008','sub-009','sub-010', 'sub-011'};

for iSub = 1:length(subjects)
    subID = subjects{iSub};
    fprintf('Processing %s ...\n', subID);

    %% Daten laden
    load([pathToDataRaw subID '.mat']);

    %% Erkennung schlechter Elektroden & Interpolation
    params.FlatlineCriterion  = 5; %Sekunden
    params.LineNoiseCriterion = 4; %Standardabweichungen
    params.ChannelCriterion   = 0.8; %Korrelation
    params.BurstCriterion     = 'off';
    params.WindowCriterion    = 'off';
    EEG_CRD = clean_artifacts(EEG, params);
    CRD_goodChannels = EEG_CRD.etc.clean_channel_mask;
    badChannels = find(not(CRD_goodChannels));

    % Interpolate bad channels
    EEG = eeg_interp(EEG, badChannels, 'spherical');

    % Mittelwertsreferenz anwenden
    EEG.data = reref(EEG.data);

    %% Filtern

    % High-pass Filter (1 Hz):
    EEG_filt_HP = pop_eegfiltnew(EEG, 1, []);

    % Low-pass Filter (100 Hz):
    EEG_filt_LPHP = pop_eegfiltnew(EEG_filt_HP, [], 100);

    % Line Noise (ZapLine, 7 DSS components):
    EEG_filt_ZL = pop_zapline_plus(EEG_filt_LPHP, 'noisefreqs', 50, 'fixedNremove', 7, 'adaptiveNremove', 0, 'plotResults', 0);

    % Überschreiben
    EEG = EEG_filt_ZL;

    %% ICA Decomposition
    EEG = pop_runica(EEG, 'icatype', 'runica', 'extended', 1);

    %% ICLabel

    % IClabel klassifizieren lassen:
    EEG_ICL = iclabel(EEG);

    % Komponenten behalten die mit hoher Wahrscheinlichkeit Artefakte sind (80%):
    markBad      = EEG_ICL.etc.ic_classification.ICLabel.classifications(:,2:6) > 0.8;
    badComps_ICL = find(any(markBad, 2));
    EEG          = pop_subcomp(EEG_ICL, badComps_ICL);

    %% Saubere Daten mit LP 100 speichern
    mkdir(pathToDataCleanLP100)
    save([pathToDataCleanLP100, subID, '-LP100.mat'], 'EEG');
    clc
    fprintf('Done: %s\n', subID);
end

%% Fourier

% Frequenzanalyse mit spectopo
% figure();
% [spec,freq] = spectopo(EEG.data, 0, EEG.srate);
