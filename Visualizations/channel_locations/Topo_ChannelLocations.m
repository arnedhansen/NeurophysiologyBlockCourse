%% Vorbereitung
clear
clc
pathToData = '/Users/Arne/Documents/GitHub/NeurophysiologyBlockCourse/Praxis/data/preprocessed_data'; 
addpath('eeglab2021.1')
eeglab
close;

%% Load data
% list files in directory
d = dir([pathToData, filesep, '*sub*']);
d(1).name
d(1).folder

% load EEG data
load(fullfile(d(1).folder, d(1).name))

% epoch
% OUTEEG = pop_epoch( EEG, events, timelimits);
EEGC1 = pop_epoch(EEG, {5, 6, 7}, [-0.2 0.8]); % familiar
EEGC2 = pop_epoch(EEG, {13, 14, 15}, [-0.2 0.8]); % unfamiliar
EEGC3 = pop_epoch(EEG, {17, 18, 19}, [-0.2 0.8]); % scrambled

% basline correction
EEGC1 = pop_rmbase(EEGC1, [-200 0]);
EEGC2 = pop_rmbase(EEGC2, [-200 0]);
EEGC3 = pop_rmbase(EEGC3, [-200 0]);

%% Topography
figure; 
set(gcf, 'Position', [0 0 2000 2000], 'Color', 'W')
topoplot([],EEGC1.chanlocs, 'style','blank','electrodes','labels'); % blank topo
saveas(gcf, '/Users/Arne/UZH/PhD/Teaching/25FS Blockkurs Neurophys Exp/Topo_ChannelLocations.png')

