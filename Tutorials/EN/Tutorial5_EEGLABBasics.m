%% Tutorial 5 – Working with EEG Data in EEGLAB (Basics)
% This optional tutorial gives you a practical introduction to EEGLAB, a
% MATLAB toolbox for analyzing EEG data.
%
% Contents:
% 
% - 0. Introduction
% - 1. Overview: What is EEGLAB?
%   - 1.1 The EEG structure
% - 2. Loading and inspecting data
%   - 2.1 Displaying basic information
%     - 2.1.1 Listing and loading multiple files
%   - 2.2 Visualizing raw signal with eegplot
%   - 2.3 Plotting individual channels
%   - 2.4 Visualizing channel positions with pop_chanedit
%     - 2.4.1 Finding channels by name
%   - 2.5 Plotting topographies with topoplot
%     - 2.5.1 topoplot options
% - 3. Events and epochs
%   - 3.1 Inspecting events
%     - 3.1.1 Filtering and finding events
%   - 3.2 Defining epochs with pop_epoch
%   - 3.3 Baseline correction with pop_rmbase
% - 4. Basics of preprocessing
%   - 4.1 Re-referencing with reref
%   - 4.2 Filtering with pop_eegfiltnew
%   - 4.3 Cutting data with pop_select
% - 5. Simple ERPs
%   - 5.1 Calculating ERP
%   - 5.2 Plotting ERP
%   - 5.3 Comparison between conditions
%   - 5.4 Finding time points
%   - 5.5 Topographies for ERPs
%   - 5.6 Calculating grand average
%   - 5.7 Plot formatting for publications

%% 0. Introduction
% In this tutorial, you will learn how to work with EEGLAB, a MATLAB toolbox
% specifically developed for analyzing EEG data. EEGLAB offers many functions
% for loading, preprocessing, and analyzing EEG data.
%
% IMPORTANT: Before you run this tutorial, you must add EEGLAB to the MATLAB
% path. In the practice scripts, this is done like this:
%
% addpath('eeglab2021.1')
% eeglab;
% close;
%
% The first command adds the EEGLAB folder to the path, the second starts
% EEGLAB (which loads all important functions), and the third closes the GUI
% window again (we work only with scripts, not with the GUI).
%
% These tutorials are designed so that you don't have to memorize everything.
% Rather, it's about developing a basic understanding of how EEGLAB works. You
% will have many opportunities to apply what you've learned later in the
% block course.

%% 1. Overview: What is EEGLAB?
% EEGLAB is a MATLAB toolbox for analyzing EEG data. It offers:
% - a graphical user interface (GUI)
% - many convenience functions for loading, preprocessing, and analyzing EEG
% - a data structure (EEG struct) that contains all relevant information
%
% In this tutorial, we use EEGLAB functions mainly in scripts, not via the
% GUI. This has the advantage that you know exactly which steps you performed,
% and you can repeat the analysis later.

%% 1.1 The EEG structure
% In EEGLAB, all EEG data is stored in a large structure called `EEG`. This
% structure contains many different fields that store different information.
% The most important fields are:
%
% - `EEG.data`      : The actual EEG data (channels × time points × trials)
% - `EEG.srate`     : Sampling rate in Hz
% - `EEG.nbchan`    : Number of channels
% - `EEG.pnts`      : Number of time points per trial (points)
% - `EEG.trials`    : Number of trials (1 for continuous data)
% - `EEG.times`     : Time vector (in ms)
% - `EEG.chanlocs`  : Channel information (channel locations: Name, Position, etc.)
% - `EEG.event`     : Event information (Trigger, Response, etc.)
%
% When you later work with real EEG data in the block course, you will use
% this structure very frequently. It's worth familiarizing yourself with it.

%% 2. Loading and inspecting data
% Before you can begin the analysis, you must load the data. In the practice
% scripts, the data is usually loaded like this:
%
% Path to data (placeholder, adjust!)
% pathToData = 'data/preprocessed_data';
% load([pathToData '/gip_sub-002.mat']);
%
% After loading, you should have a variable `EEG` in the workspace. You can
% look at the structure by simply typing `EEG` or clicking on it in the
% workspace.

%% 2.1 Displaying basic information
% When an EEG dataset is loaded, you can look at the most important
% information:
%
% EEG          % Displays the entire structure
% EEG.srate    % Sampling rate
% EEG.nbchan   % Number of channels
% size(EEG.data)  % Dimensions of the data matrix
%
% The function `size` shows you the dimensions of the data matrix. For
% continuous data (no epochs), this is normally:
% [Number of channels, Number of time points]
%
% For epoched data (with epochs), this is:
% [Number of channels, Number of time points per epoch, Number of epochs]

%% 2.1.1 Listing and loading multiple files
% Often you want to load several datasets one after another, e.g., for all
% participants. For this, you can use the function `dir` to list all files
% in a folder:
%
% Example: List all files with "sub" in the name
% pathToData = 'data/preprocessed_data';
% d = dir([pathToData, filesep, '*sub*']);
%
% The function `dir` returns a structure that contains information about the
% files. `filesep` is a platform-independent variable that uses the correct
% separator for paths (e.g., `/` on Mac/Linux, `\` on Windows). The wildcard
% `*sub*` finds all files that have "sub" in the name.
%
% You can then iterate over the files:
%
% for sub = 1:length(d)
%     filename = d(sub).name;
%     fullpath = fullfile(d(sub).folder, filename);
%     load(fullpath);
%     % Here you would then perform the analysis
% end
%
% The function `fullfile` creates a complete path that works on every
% operating system. `d(sub).folder` returns the folder path, `d(sub).name`
% returns the filename.
%
% IMPORTANT NOTE: `dir` also returns folders (e.g., `.` and `..`). If you
% only want files, you can check whether `d(sub).isdir` is false, or you use
% a more specific wildcard pattern like `'*sub*.mat'`.

%% 2.2 Visualizing raw signal with eegplot
% The function `eegplot` shows you the entire EEG signal in an interactive
% window. You can scroll through the data and view all channels simultaneously.
%
% eegplot(EEG.data)
%
% If your data contains events (e.g., triggers, markers), you can also
% display them:
%
% eegplot(EEG.data, 'events', EEG.event)
%
% This shows you the events as vertical lines in the plot. This is very
% useful for seeing when certain events occurred (e.g., when a stimulus was
% presented).
%
% IMPORTANT NOTE: `eegplot` opens an interactive window. You can scroll
% through the data, zoom, and select individual channels. The window stays
% open until you close it. If you create many plots, you should close the
% window after viewing it so it doesn't get too cluttered.

%% 2.3 Plotting individual channels
% Sometimes you want to look at only one or a few channels in more detail.
% You can do this with normal MATLAB plot functions:
%
% Example: Plot first 500 data points of channel 1 and channel 50
% nChannelA = 1;
% nChannelB = 50;
% minPnt = 1;
% maxPnt = 500;
%
% figure;
% plot(EEG.times(minPnt:maxPnt), EEG.data(nChannelA, minPnt:maxPnt), 'color', 'r')
% hold on
% plot(EEG.times(minPnt:maxPnt), EEG.data(nChannelB, minPnt:maxPnt), 'color', 'y')
% legend('Channel A', 'Channel B')
% title('Timecourse of two EEG channels')
% xlabel('time [ms]')
% ylabel('signal [\muV]')
%
% Here you see how to access individual channels and time points:
% - `EEG.data(nChannelA, minPnt:maxPnt)` gives you the data from channel
%   `nChannelA` for the time points from `minPnt` to `maxPnt`
% - `EEG.times(minPnt:maxPnt)` gives you the corresponding time points in ms
%
% IMPORTANT NOTE: The dimensions of `EEG.data` are [channels, time points].
% The first argument is thus the channel index, the second is the time point
% index. If you swap these, you get an error or incorrect data.

%% 2.4 Visualizing channel positions with pop_chanedit
% The function `pop_chanedit` shows you where the electrodes are positioned
% on the head. This is important for understanding which channels measured
% where.
%
% pop_chanedit(EEG)
%
% This opens a window that shows the channel locations. You see a 2D
% representation of the head from above, with the positions of all
% electrodes. This helps you understand which channels are frontal, central,
% parietal, etc.

%% 2.4.1 Finding channels by name
% Often you want to use a specific channel, but you don't know its index,
% only its name (e.g., "EEG065" or "Cz"). You can find the index with `find`
% and `ismember`:
%
% Example: Find channel "EEG065"
% channelname = 'EEG065';
% i65 = find(ismember({EEG.chanlocs.labels}, channelname));
%
% The function `ismember` checks whether an element is contained in an array.
% `{EEG.chanlocs.labels}` converts the channel names into a cell array so
% that `ismember` can compare them. `find` then returns the index at which
% the channel name was found.
%
% You can then use this index to access the data:
%
% EEG.data(i65, :)  % All data from channel "EEG065"
%
% IMPORTANT NOTE: If the channel name is not found, `find` returns an empty
% vector. You should check whether `i65` is not empty before using it:
%
% i65 = find(ismember({EEG.chanlocs.labels}, channelname));
% if ~isempty(i65)
%     % Channel found, use i65
% else
%     warning('Channel %s not found!', channelname);
% end

%% 2.5 Plotting topographies with topoplot
% A topography shows you how the electrical activity is distributed over the
% head at a specific time point. It's like a "map" of brain activity.
%
% Example: Topography for data point 500
% timePnt = 500;
% figure;
% topoplot(EEG.data(:, timePnt), EEG.chanlocs)
% colorbar;
% title('Data at timepoint 500')
%
% The function `topoplot` takes as input:
% - a vector with values for each channel (here: `EEG.data(:, timePnt)`)
% - the channel positions (here: `EEG.chanlocs`)
%
% The result is a colored representation of the head from above, where the
% colors show the amplitude at each electrode. Red might, e.g., mean positive
% values, blue negative values.
%
% IMPORTANT NOTE: `EEG.data(:, timePnt)` gives you a column vector with the
% values of all channels at time point `timePnt`. The colon `:` means "all
% channels". This is important for `topoplot`, which expects a vector with
% one value per channel.

%% 2.5.1 topoplot options
% `topoplot` has many options to customize the display:
%
% Example: Show electrodes
% figure;
% topoplot(EEG.data(:, timePnt), EEG.chanlocs, 'electrodes', 'on')
% colorbar;
% title('Topography with electrodes')
%
% The option `'electrodes', 'on'` shows the positions of the electrodes as
% points. You can also use `'electrodes', 'labels'` to display the channel
% names:
%
% figure;
% topoplot([], EEG.chanlocs, 'style', 'blank', 'electrodes', 'labels')
% title('Blank topography with channel labels')
%
% Here you use `[]` as the first parameter (no data) and `'style', 'blank'`
% to create an empty topography that only shows the channel positions. This
% is useful for seeing which channels are where.
%
% Further useful options:
% - `'electrodes', 'on'`: Shows electrodes as points
% - `'electrodes', 'labels'`: Shows channel names
% - `'electrodes', 'off'`: Hides electrodes (default)
% - `'style', 'blank'`: Empty topography (only electrodes, no data)
%
% IMPORTANT NOTE: The options are passed as name-value pairs (e.g.,
% `'electrodes', 'on'`). The order is important: first the option name (as a
% string), then the value.

%% 3. Events and epochs
% Most EEG experiments work event-related. This means that certain events
% were marked during recording, e.g., when a stimulus was presented or when
% a person responded.

%% 3.1 Inspecting events
% Events are stored in `EEG.event`. You can look at the first events:
%
% EEG.event(1:5)
%
% Typical fields in `EEG.event` are:
% - `type`: Event type (e.g., a stimulus code like "5", "6", "7" or a text
%   label like "Stimulus")
% - `latency`: Time point in the dataset (in data points, not in ms!)
%
% IMPORTANT NOTE: `latency` is given in data points, not in milliseconds! If
% you want to know when an event occurred in ms, you must divide `latency`
% by the sampling rate and multiply by 1000, or you use `EEG.times(latency)`.

%% 3.1.1 Filtering and finding events
% Often you want to use only certain event types. You can filter events by
% checking which events have a specific type:
%
% Example: Find all events of type "5"
% event_types = {EEG.event.type};  % Convert to cell array
% events_type5 = strcmp(event_types, '5');  % Or: events_type5 = [EEG.event.type] == 5
% indices_type5 = find(events_type5);
%
% If the event types are numbers (not strings), you can compare them directly:
%
% event_types_num = [EEG.event.type];  % Convert to numeric array
% indices_type5 = find(event_types_num == 5);
%
% You can then use these indices to use only certain events, e.g., for
% `pop_epoch`:
%
% EEGC1 = pop_epoch(EEG, {5, 6, 7}, [-0.2 0.8]);  % Epochs for events 5, 6, 7
%
% IMPORTANT NOTE: Event types can be both numbers and strings. If they are
% numbers, you can compare them directly (`==`). If they are strings, you
% must use `strcmp`. In the practice scripts, numbers are usually used
% (e.g., 5, 6, 7 for one condition, 13, 14, 15 for another).

%% 3.2 Defining epochs with pop_epoch
% Epochs are time windows around specific events. For example, you might want
% to analyze 200 ms before a stimulus to 800 ms after the stimulus.
%
% Example: Epochs from -200 ms to 800 ms relative to event types 5, 6, 7
% EEGC1 = pop_epoch(EEG, {5, 6, 7}, [-0.2 0.8]);
%
% The function `pop_epoch` takes as input:
% - the EEG structure
% - a cell array with event types (here: {5, 6, 7})
% - a time window in seconds (here: [-0.2 0.8] means -200 ms to 800 ms)
%
% The result is a new EEG structure with epochs. The dimensions of
% `EEGC1.data` are now [channels, time points per epoch, number of epochs].
%
% IMPORTANT NOTE: The time window is specified in seconds, not in
% milliseconds! -0.2 means -200 ms, 0.8 means 800 ms. This is a common error
% – make sure you have the units correct.

%% 3.3 Baseline correction with pop_rmbase
% Baseline correction subtracts the mean of a time window (usually before
% the stimulus) from all time points. This removes slow drifts and makes the
% data more comparable.
%
% Example: Baseline correction for the time window -200 ms to 0 ms
% EEGC1 = pop_rmbase(EEGC1, [-200 0]);
%
% The function `pop_rmbase` takes as input:
% - the EEG structure (with epochs)
% - a time window in ms (here: [-200 0] means -200 ms to 0 ms)
%
% IMPORTANT NOTE: With `pop_rmbase`, the time window is specified in
% milliseconds, not in seconds as with `pop_epoch`! This is confusing, but
% that's how it is in EEGLAB. Make sure to use the correct units.
%
% After baseline correction, the mean in the baseline time window should be
% approximately 0. This makes it easier to recognize effects after the
% stimulus.

%% 4. Basics of preprocessing
% Preprocessing is important for cleaning the data and preparing it for
% analysis. Typical steps are:
% - Re-referencing (rereferencing)
% - Filtering
% - (Optional: ICA, channel interpolation, etc. – these are covered in other
%   tutorials)

%% 4.1 Re-referencing with reref
% In re-referencing, the reference of the EEG data is changed. The original
% reference might, e.g., be the nose or an ear, and you want to switch to
% another reference (e.g., average reference).
%
% Example: Re-referencing to average reference
% averageRefData = reref(EEG.data);
%
% The function `reref` takes as input:
% - the data matrix (here: `EEG.data`)
% - optional: an index of a reference channel (if not specified, average
%   reference is used)
%
% The result is a new data matrix with the new reference. You can then
% insert this back into the EEG structure:
%
% EEG.data = averageRefData;
%
% Example: Re-referencing to a specific channel (e.g., channel 13)
% chlLeftEar = 13;
% leftEarData = reref(EEG.data, chlLeftEar);
%
% IMPORTANT NOTE: Re-referencing changes the absolute amplitudes of the data,
% but not the relative differences between channels. The choice of reference
% can influence the interpretation of the data, especially in topographic
% displays.

%% 4.2 Filtering with pop_eegfiltnew
% Filtering removes unwanted frequency components from the data. Typically,
% one uses:
% - High-pass filter: removes slow drifts (e.g., < 1 Hz)
% - Low-pass filter: removes high frequencies and noise (e.g., > 40 Hz)
%
% Example: High-pass filter at 1 Hz
% EEG = pop_eegfiltnew(EEG, 1, []);
%
% The function `pop_eegfiltnew` takes as input:
% - the EEG structure
% - the lower cutoff frequency (high-pass cutoff) in Hz (here: 1)
% - the upper cutoff frequency (low-pass cutoff) in Hz (here: [] means "no
%   low-pass filter")
%
% Example: Low-pass filter at 40 Hz (after the high-pass filter)
% EEG = pop_eegfiltnew(EEG, [], 40);
%
% Here only the low-pass filter is applied (the first cutoff frequency is [],
% so no high-pass filter).
%
% Example: Band-pass filter (both limits set)
% EEG = pop_eegfiltnew(EEG, 1, 40);
%
% This filters the data so that only frequencies between 1 Hz and 40 Hz
% remain.
%
% IMPORTANT NOTE: The order of filtering is important! Normally you filter
% first with a high-pass filter (to remove slow drifts) and then with a
% low-pass filter (to remove high frequencies). If you want to apply both
% filters simultaneously, you can also set both limits in one call.

%% 4.3 Cutting data with pop_select
% Sometimes you want to analyze only a part of the data, e.g., the first
% two minutes or a specific time range.
%
% Example: Cut first two minutes (120 seconds)
% EEG = pop_select(EEG, 'time', [1, 121]);
%
% The function `pop_select` is very flexible and can select data according
% to various criteria:
% - `'time'`: Time range in seconds
% - `'channel'`: Specific channels
% - `'trial'`: Specific epochs (if data is already epoched)
%
% IMPORTANT NOTE: The time window is specified in seconds, not in
% milliseconds! [1, 121] means from second 1 to second 121 (i.e., 120
% seconds of data).

%% 5. Simple ERPs
% Event-Related Potentials (ERPs) arise from averaging over several trials
% that contain the same event. This reduces noise and makes the
% event-related signals visible.

%% 5.1 Calculating ERP
% If you already have epochs, you can calculate an ERP simply by averaging
% over the third dimension (trials):
%
% Example: Calculate ERP for one condition
% ERP1 = mean(EEGC1.data, 3);
%
% The function `mean` with the third argument `3` averages over the third
% dimension, i.e., over the trials. The result `ERP1` now has the dimensions
% [channels, time points].
%
% IMPORTANT NOTE: The dimensions of epoched data are [channels, time points,
% trials]. If you average over trials (dimension 3), a matrix with
% [channels, time points] remains.

%% 5.2 Plotting ERP
% You can plot an ERP for a specific channel:
%
% Example: Plot ERP for channel 61
% channel_index = 61;
% figure;
% plot(EEGC1.times, ERP1(channel_index, :))
% xlabel('Time (ms)')
% ylabel('Voltage (\muV)')
% title('ERP at channel 61')
% grid on
%
% Here you see the averaged waveform for this channel. Typical ERP components
% are, e.g., the N170 (a negative wave at about 170 ms) or the P300 (a
% positive wave at about 300 ms), depending on the experiment.
%
% IMPORTANT NOTE: `EEGC1.times` gives you the time points in ms for the
% epochs. These are normally relative to the event (e.g., -200 ms to 800 ms),
% not absolute.

%% 5.3 Comparison between conditions
% In a real experiment, there are usually several conditions (e.g., congruent
% vs. incongruent). You can calculate a separate ERP for each condition and
% then compare:
%
% Example: Calculate and plot ERP for two conditions
% EEGC1 = pop_epoch(EEG, {5, 6, 7}, [-0.2 0.8]);  % Condition 1
% EEGC2 = pop_epoch(EEG, {13, 14, 15}, [-0.2 0.8]); % Condition 2
%
% EEGC1 = pop_rmbase(EEGC1, [-200 0]);
% EEGC2 = pop_rmbase(EEGC2, [-200 0]);
%
% ERP1 = mean(EEGC1.data, 3);
% ERP2 = mean(EEGC2.data, 3);
%
% channel_index = 61;
% figure;
% plot(EEGC1.times, ERP1(channel_index, :), 'LineWidth', 2, 'Color', 'red')
% hold on
% plot(EEGC2.times, ERP2(channel_index, :), 'LineWidth', 2, 'Color', 'blue')
% xlabel('Time (ms)')
% ylabel('Voltage (\muV)')
% legend('Condition 1', 'Condition 2')
% grid on
%
% This way you can directly compare the ERPs of the two conditions. The
% difference between the conditions shows you where the conditions differ.

%% 5.4 Finding time points
% Often you want to find a specific time point in the time vector, e.g., to
% define a time window for a topography. You can use `find`:
%
% Example: Find time point 152 ms
% a = find(EEGC1.times == 152, 1);
%
% The function `find` returns all indices at which the condition is
% satisfied. The `, 1` at the end returns only the first index (in case there
% were several, which normally isn't the case for exact time points).
%
% IMPORTANT NOTE: `find(EEGC1.times == 152, 1)` finds the exact time point
% 152 ms. If this time point doesn't exist (e.g., because the sampling rate
% doesn't allow exactly 152 ms), `find` returns an empty vector. You can
% also search for the next time point:
%
% a = find(EEGC1.times >= 152, 1);  % First time point >= 152 ms

%% 5.5 Topographies for ERPs
% You can also create topographies for specific time windows in the ERP:
%
% Example: Topography for time window 152-212 ms (e.g., around N170 peak)
% a = find(EEGC1.times == 152, 1);  % Find time point 152 ms
% b = find(EEGC1.times == 212, 1);  % Find time point 212 ms
%
% figure;
% topoplot(mean(ERP1(:, a:b), 2), EEGC1.chanlocs, 'electrodes', 'on')
% colorbar;
% title('ERP topography: 152-212 ms')
%
% Here you average over the time window (dimension 2 in `mean(ERP1(:, a:b),
% 2)`) and get one value per channel. This is then displayed in the
% topography.
%
% IMPORTANT NOTE: `mean(ERP1(:, a:b), 2)` averages over the columns (time
% points), not over the rows (channels). The second argument `2` specifies
% the dimension over which to average. The result is a column vector with
% one value per channel.

%% 5.6 Calculating grand average
% If you have data from several participants, you often want to calculate a
% grand average (GA) – the mean over all participants. This reduces noise and
% shows the average response over all VPs.
%
% Example: Grand average over several subjects
% Suppose you have stored an ERP for each VP:
% ERP1(sub, :, :) = mean(EEGC1.data(:, :, :), 3);  % For each VP
%
% Calculate grand average:
% GM1 = squeeze(mean(ERP1, 1));
%
% The function `squeeze` removes dimensions of size 1. `mean(ERP1, 1)`
% averages over the first dimension (subjects), which gives a matrix with
% dimensions [1, channels, time points]. `squeeze` removes the first
% dimension so that you get a matrix with [channels, time points].
%
% IMPORTANT NOTE: `squeeze` is important when you average over a dimension
% that afterwards has size 1. Without `squeeze`, you would have a 3D matrix
% with one dimension of size 1, which can cause problems with many functions.

%% 5.7 Plot formatting for publications
% When you create plots for publications or presentations, you often want to
% format them professionally. Here are some useful commands:
%
% Example: Professionally formatted plot
% figure;
% plot(EEGC1.times, ERP1(channel_index, :), 'LineWidth', 2, 'Color', 'red')
% hold on
% plot(EEGC1.times, ERP2(channel_index, :), 'LineWidth', 2, 'Color', 'blue')
% xlabel('Time (ms)')
% ylabel('Voltage (\muV)')
% legend('Condition 1', 'Condition 2')
% set(gca, 'FontSize', 16)      % Larger font for axes
% set(gcf, 'Color', 'w')         % White background
% grid on
%
% The function `set` changes properties of graphics:
% - `gca` (get current axes): refers to the current axes
% - `gcf` (get current figure): refers to the current figure
%
% Useful properties:
% - `'FontSize', 16`: Larger font for better readability
% - `'Color', 'w'`: White background (instead of gray)
% - `'LineWidth', 2`: Thicker lines for better visibility
%
% For multiple subplots, you can also use `sgtitle`:
%
% figure;
% subplot(3, 1, 1)
% plot(EEGC1.times, ERP1_65)
% title('Familiar')
% subplot(3, 1, 2)
% plot(EEGC1.times, ERP2_65)
% title('Unfamiliar')
% subplot(3, 1, 3)
% plot(EEGC1.times, ERP3_65)
% title('Scrambled')
% sgtitle('Variability between subjects across conditions')
%
% `sgtitle` adds an overall title over all subplots.
%
% IMPORTANT NOTE: `set(gca, ...)` and `set(gcf, ...)` must be called after
% the plot for them to take effect. You can also combine them:
% `set(gca, 'FontSize', 16, 'FontName', 'Arial')`.

%% Summary
% In this tutorial, you have learned:
%
% 1. **The EEG structure**: How EEG data is organized in EEGLAB (fields like
%    `EEG.data`, `EEG.srate`, `EEG.chanlocs`, etc.)
%
% 2. **Loading and inspecting data**: How you load data and visualize it
%    with `eegplot`, `topoplot`, and normal plot functions
%
% 3. **Events and epochs**: How you inspect events and create epochs with
%    `pop_epoch`, and how you perform baseline correction with `pop_rmbase`
%
% 4. **Preprocessing**: How you re-reference with `reref` and filter with
%    `pop_eegfiltnew`, and how you cut data with `pop_select`
%
% 5. **ERPs**: How you calculate ERPs (by averaging over trials) and
%    visualize them for individual channels or as topographies
%
% These functions you will use frequently later in the block course when
% working with real EEG data. It's worth familiarizing yourself with them.

EXCURSUS Further preprocessing steps: In the practice scripts, you will also
learn about other preprocessing steps that were not covered here:
- ICA (Independent Component Analysis) with `pop_runica` and `pop_subcomp`
- Automatic artifact detection with `clean_artifacts` and `iclabel`
- Channel interpolation with `eeg_interp`
These are more complex and are covered in the practice parts of the block
course.
