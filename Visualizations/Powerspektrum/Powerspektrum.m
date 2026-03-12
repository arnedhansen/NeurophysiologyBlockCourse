%% Powerspectrum for Block Course
%
% Extract Power from AOC Data

%% Setup
clear
[subjects, path] = setup('AOC');

%% Define channels
datapath = strcat(path, subjects{1}, '/eeg');
cd(datapath);
load('power_nback.mat');
% Occipital channels
occ_channels = {};
for i = 1:length(powload2.label)
    label = powload2.label{i};
    if contains(label, {'O'})
        occ_channels{end+1} = label;
    end
end
channels = occ_channels;

%% Extract POWER
datapath = strcat(path,subjects{1}, '/eeg');
cd(datapath)
close all
load dataEEG_nback
load('/Volumes/methlab/Students/Arne/MA/headmodel/ant128lay.mat');

%% Identify indices of trials belonging to conditions
ind1=find(data.trialinfo==21);
ind2=find(data.trialinfo==22);
ind3=find(data.trialinfo==23);

%% Frequency analysis
cfg = [];
cfg.latency = [0 2]; % Segment from 0 to 2 [seconds]
dat = ft_selectdata(cfg,data);
cfg = []; % empty config
cfg.output = 'pow'; % estimates power only
cfg.method = 'mtmfft'; % multi taper fft method
cfg.taper = 'dpss'; % multiple tapers
cfg.tapsmofrq = 1; % smoothening frequency around foi
cfg.foilim = [1 100]; % frequencies of interest (foi)
cfg.keeptrials = 'no';% do not keep single trials in output
cfg.pad = 10;
cfg.trials = ind1;
powload1 = ft_freqanalysis(cfg,dat);
cfg.trials = ind2;
powload2 = ft_freqanalysis(cfg,dat);
cfg.trials = ind3;
powload3 = ft_freqanalysis(cfg,dat);

%% Plot alpha power POWERSPECTRUM
close all
figure;
set(gcf, 'Position', [600, 0, 800, 1600], 'Color', 'w');

% Plot 
cfg = [];
cfg.channel = channels;
cfg.figure = 'gcf';
cfg.linecolor = 'k';
cfg.linewidth = 5;
ft_singleplotER(cfg,powload1);
hold on;

% Add shadedErrorBar
addpath('/Volumes/methlab/Students/Arne/toolboxes')
%channels_seb = ismember(powload1.label, cfg.channel);
%l1ebar = shadedErrorBar(powload1.freq, mean(powload1.powspctrm(channels_seb, :), 1), std(powload1.powspctrm(channels_seb, :))/sqrt(size(powload1.powspctrm(channels_seb, :), 1)), {'k', 'markerfacecolor', 'k'});
%transparency = 0.5;
%set(l1ebar.patch, 'FaceAlpha', transparency);

% Adjust plotting
set(gca,'Fontsize',20);
set(gca, 'yscale', 'log')
xlim([1 90])
xticks([0 4 8 13 30 90])
xlabel('Frequenz [Hz]');
ylabel('Power [\muV^2/Hz]');
title('Powerspektrum', 'FontSize', 30)

% Add frequency band patches
delta = [0 4];
theta = [4 8];
alpha = [8 13];
beta  = [13 30];
gamma = [30 90];
deltaColor = [1, 0, 0];    % red
thetaColor = [0, 0.5, 0];  % dark green
alphaColor = [0, 0, 1];    % blue
betaColor  = [1, 0.5, 0];  % orange
gammaColor = [0.5, 0, 0.5];% purple
y_min = 0.0001;  % must be > 0 for log scale
y_max = 1;
h1 = patch([delta(1) delta(2) delta(2) delta(1)], [y_min y_min y_max y_max], deltaColour, ...
           'FaceAlpha', 0.2, 'EdgeColor', 'none');
h2 = patch([theta(1) theta(2) theta(2) theta(1)], [y_min y_min y_max y_max], thetaColour, ...
           'FaceAlpha', 0.2, 'EdgeColor', 'none');
h3 = patch([alpha(1) alpha(2) alpha(2) alpha(1)], [y_min y_min y_max y_max], alphaColour, ...
           'FaceAlpha', 0.2, 'EdgeColor', 'none');
h4 = patch([beta(1) beta(2) beta(2) beta(1)], [y_min y_min y_max y_max], betaColour, ...
           'FaceAlpha', 0.2, 'EdgeColor', 'none');
h5 = patch([gamma(1) gamma(2) gamma(2) gamma(1)], [y_min y_min y_max y_max], gammaColour, ...
           'FaceAlpha', 0.2, 'EdgeColor', 'none');

% Add a legend with the corresponding patch handles
legend([h1, h2, h3, h4, h5], {'Delta (0.1-4 Hz)', 'Theta (4-8 Hz)', ...
       'Alpha (8-13 Hz)', 'Beta (13-30 Hz)', 'Gamma (30-90 Hz)'}, 'Location', 'best', 'FontSize', 25);

% Save
saveas(gcf, '/Users/Arne/UZH/PhD/Teaching/25FS Blockkurs Neurophys Exp/Powerspektrum.png');