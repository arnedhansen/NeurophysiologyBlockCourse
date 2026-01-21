%% Tutorial 6 – Time-Frequency Analysis
% This optional tutorial introduces you to time-frequency analysis of EEG
% signals. You will learn how to analyze both the temporal and
% frequency-specific dynamics of EEG data.
%
% Contents:
% 
% - 0. Introduction
% - 1. Motivation: Why time-frequency?
% - 2. Fourier Transform and power spectrum
%   - 2.1 FFT by hand
%   - 2.2 Power spectrum with spectopo
%   - 2.3 Power spectrum for all channels
% - 3. Time-frequency analysis: STFT by hand
%   - 3.1 STFT with spectopo by hand
%   - 3.2 Visualizing the time-frequency representation
%   - 3.3 Time-frequency trade-off
% - 4. Time-frequency analysis with EEGLAB
%   - 4.1 Preparation: Create epochs
%   - 4.2 STFT with pop_newtimef
%   - 4.3 Wavelet analysis with pop_newtimef
% - 5. Hilbert Transform for frequency band power
%   - 5.1 Filtering data
%   - 5.2 Hilbert Transform
%   - 5.3 Visualization

%% 0. Introduction
% So far, you have learned how to calculate ERPs (Event-Related Potentials)
% by averaging over trials. ERPs show well what happens on average over
% trials, but they mask temporally varying oscillations. For example, the
% alpha power (8–12 Hz) might briefly decrease after a stimulus
% (alpha desynchronization), or the theta power (4–8 Hz) might increase.
%
% Time-frequency analysis allows you to consider both the temporal and
% frequency-specific dynamics. So you see not only when something happens,
% but also in which frequency bands it happens.
%
% These tutorials are designed so that you don't have to memorize everything.
% Rather, it's about developing a basic understanding of how time-frequency
% analyses work. You will have many opportunities to apply what you've
% learned later in the block course.

%% 1. Motivation: Why time-frequency?
% ERPs show you the averaged electrical activity over time. This is very
% useful for identifying, e.g., the N170 or P300 component. But ERPs don't
% show you how the power in different frequency bands changes over time.
%
% Example: Imagine you present a visual stimulus. After the stimulus, the
% alpha power (8–12 Hz) might briefly decrease (desynchronization), while
% simultaneously the gamma power (30–100 Hz) increases. This information is
% lost in a normal ERP because you average over all frequencies.
%
% Time-frequency analysis shows you this dynamics: You see a "map" of brain
% activity that shows both time (x-axis) and frequency (y-axis). The colors
% show you the power in each time-frequency region.

%% 2. Fourier Transform and power spectrum
% Before we get to time-frequency analysis, let's look again at the Fourier
% Transform, which you already know from Tutorial 2.

%% 2.1 FFT by hand
% You can use the FFT (Fast Fourier Transform) directly in MATLAB:
%
% Example: FFT for one channel, first 1000 data points (4 seconds at 250 Hz)
% channel = 60;
% fft_res = abs(fft(EEG.data(channel, 1:1000)));
% fft_res = fft_res(1:length(fft_res)/2);  % Only first half (symmetry)
%
% The function `fft` calculates the Fourier Transform. `abs` gives you the
% amplitude (without phase information). The second line takes only the first
% half of the result because the FFT is symmetric.
%
% IMPORTANT NOTE: The FFT gives you a spectrum for the entire time window,
% but no information about when which frequencies occur. If you want to know
% how frequencies change over time, you need a time-frequency analysis.

%% 2.2 Power spectrum with spectopo
% EEGLAB offers the function `spectopo`, which calculates a power spectrum.
% This is more practical than the FFT by hand because it automatically does
% the correct scaling and display.
%
% Example: Power spectrum for one channel
% channel = 60;
% [spec, freq] = spectopo(EEG.data(channel, 1:1000), 0, EEG.srate);
%
% The function `spectopo` takes as input:
% - the data (here: first 1000 data points from channel 60)
% - the number of frames (0 means: all data points)
% - the sampling rate in Hz
%
% The output is:
% - `spec`: the power spectrum in dB
% - `freq`: the frequencies for which the spectrum was calculated
%
% `spectopo` internally uses a Welch spectrum: The data is divided into
% several segments, an FFT is calculated for each segment, and the results
% are averaged. This gives a smoother, less noisy spectrum than a simple FFT.
%
% IMPORTANT NOTE: `spectopo` returns the spectrum in dB (decibels), not in
% absolute values. dB is a logarithmic scale that better represents large
% differences. A difference of 10 dB corresponds to a 10-fold change in power.

%% 2.3 Power spectrum for all channels
% You can also use `spectopo` for all channels simultaneously:
%
% [spec, freq] = spectopo(EEG.data, 0, EEG.srate);
%
% Now `spec` is a matrix with dimensions [channels × frequencies]. You can
% look at the spectrum for a specific channel:
%
% figure;
% plot(freq, spec(60, :))
% xlabel('Frequency (Hz)')
% ylabel('Power (dB)')
% title('Power spectrum for channel 60')
%
% IMPORTANT NOTE: The dimensions of `spec` are [channels, frequencies]. The
% first argument is the channel index, the second is the frequency.
% `spec(60, :)` gives you the spectrum for channel 60 for all frequencies.

EXCURSUS Welch spectrum: The Welch spectrum is a method for estimating the
power spectrum that divides the data into overlapping segments and calculates
an FFT for each segment. The results are then averaged. This reduces noise
in the spectrum but worsens frequency resolution. The frequency resolution is
1/T, where T is the length of a segment in seconds. If you use segments of 1
second, the frequency resolution is 1 Hz. If you use segments of 2 seconds,
the frequency resolution is 0.5 Hz (better), but you have fewer segments
to average (more noise).

%% 3. Time-frequency analysis: STFT by hand
% The STFT (Short-Time Fourier Transform) calculates Fourier spectra in
% sliding time windows. Each window provides a spectrum, and together they
% form a time-frequency representation.

%% 3.1 STFT with spectopo by hand
% You can do the STFT "by hand" by calling `spectopo` for different time
% windows:
%
% Example: STFT for the first 20 seconds with 1-second windows
% channel = 60;
% winSize1s = 250;  % 250 time points = 1 second at 250 Hz
% spec_tf = [];
% freq_tf = [];
%
% for i = 1:20
%     start = i * winSize1s;     % Start at second i
%     stop  = start + winSize1s; % End 1 second later
%     [spec_tf(:, i), freq_tf] = spectopo(EEG.data(channel, start:stop), 0, ...
%         EEG.srate, 'plot', 'off', 'winsize', winSize1s);
% end
%
% Here you iterate over 20 seconds and calculate a power spectrum for each
% second. The result `spec_tf` is a matrix with dimensions [frequencies ×
% time windows]. Each column is a spectrum for one time window.
%
% IMPORTANT NOTE: The frequency resolution depends on the window length. With
% 1-second windows, the frequency resolution is 1 Hz. With 2-second windows,
% the frequency resolution would be 0.5 Hz (better), but the time resolution
% would be worse (you see fewer details in time).

%% 3.2 Visualizing the time-frequency representation
% You can visualize the time-frequency representation with `imagesc`:
%
% Example: Show only frequencies from 2–30 Hz
% freq1 = find(freq_tf == 2);   % Index for 2 Hz
% freq2 = find(freq_tf == 30); % Index for 30 Hz
%
% figure;
% imagesc(spec_tf(freq1:freq2, :), [-30 30])
% colormap('turbo')
% colorbar
% xlabel('Time [s]')
% ylabel('Frequencies [Hz]')
% title('TFR: Segments of 1 second')
% set(gca, 'YDir', 'normal')
% set(gca, 'FontSize', 25)
%
% The function `imagesc` displays a matrix as a colored image. The colors
% show the power: Red might mean high power, blue low power. The values
% `[-30 30]` limit the color range (in dB).
%
% IMPORTANT NOTE: `set(gca, 'YDir', 'normal')` ensures that the y-axis goes
% from bottom to top (low frequencies at bottom, high at top). Without this
% setting, the y-axis might be inverted.

%% 3.3 Time-frequency trade-off
% There is an important trade-off between time and frequency resolution:
%
% - **Longer windows**: good frequency resolution, but poor time resolution
%   (you don't see exactly when something happens)
% - **Shorter windows**: good time resolution, but poor frequency resolution
%   (you can't distinguish between close frequencies)
%
% Example: Comparison between 1-second and 2-second windows
% With 2-second windows, you have better frequency resolution (0.5 Hz instead
% of 1 Hz), but you see fewer details in time (only every 2 seconds a value
% instead of every second).

%% 4. Time-frequency analysis with EEGLAB
% EEGLAB offers the function `pop_newtimef`, which automatically performs
% time-frequency analyses. This is much more practical than the STFT by hand.

%% 4.1 Preparation: Create epochs
% For time-frequency analysis, you normally need epoched data:
%
% Example: Epochs from -400 ms to 2600 ms around events
% EEGC_all = pop_epoch(EEG, {4, 5, 6, 13, 14, 15, 17, 18, 19}, [-0.4, 2.6]);
%
% Here you create epochs from -400 ms to 2600 ms relative to events 4–19.
% This gives you a time window of 3 seconds per epoch.

%% 4.2 STFT with pop_newtimef
% The function `pop_newtimef` performs a time-frequency analysis:
%
% Example: STFT for channel 60
% channel = 60;
% nCycles0 = 0;  % 0 means: STFT (no wavelets)
%
% [ersp, ~, ~, times, freqs] = pop_newtimef(EEGC_all, 1, channel, ...
%     [-400, 2600], nCycles0, 'freqs', [3 30], ...
%     'plotphasesign', 'off', 'plotitc', 'off');
%
% The function `pop_newtimef` takes as input:
% - the EEG structure with epochs
% - the type of display (1 = standard)
% - the channel index
% - the time window in ms (here: -400 to 2600 ms)
% - the number of cycles (0 = STFT, >0 = wavelets)
% - the frequency range (here: 3–30 Hz)
% - further options (e.g., whether phases or ITC should be plotted)
%
% The output is:
% - `ersp`: Event-Related Spectral Perturbation (matrix: frequencies × time points)
% - `times`: Time points in ms
% - `freqs`: Frequencies in Hz
%
% IMPORTANT NOTE: `ersp` shows the change in power relative to a baseline.
% Positive values mean an increase in power, negative values a decrease. The
% baseline is automatically calculated from the time window before the
% stimulus (e.g., -400 to 0 ms).

%% 4.3 Wavelet analysis with pop_newtimef
% You can also perform a wavelet analysis by setting the number of cycles to
% a value >0:
%
% Example: Wavelet analysis with 3 cycles
% nCycles5 = 3;  % Wavelets with 3 cycles
%
% [erspWave, ~, ~, timesWave, freqsWave] = pop_newtimef(EEGC_all, 1, channel, ...
%     [-400, 2600], nCycles5, 'freqs', [3 30], ...
%     'plotphasesign', 'off', 'plotitc', 'off');
%
% With wavelets, the time-frequency resolution is frequency-dependent:
% - **High frequencies** (e.g., 20–30 Hz): good time resolution, but poor
%   frequency resolution (you don't see exactly which frequency it is)
% - **Low frequencies** (e.g., 3–5 Hz): good frequency resolution, but poor
%   time resolution (you don't see exactly when something happens)
%
% This is different from STFT, where the resolution is the same for all
% frequencies. Wavelets are often better for analyzing oscillations because
% they better match the nature of oscillations (low frequencies change
% slowly, high frequencies quickly).

EXCURSUS Wavelets vs. STFT: Wavelets use frequency-dependent windows: For
low frequencies, the windows are longer (better frequency resolution), for
high frequencies shorter (better time resolution). This better matches the
nature of oscillations: Alpha (8–12 Hz) changes slowly, Gamma (30–100 Hz)
quickly. The number of cycles determines how long the window is: With 3
cycles at 3 Hz, the window is 1 second long, with 3 cycles at 30 Hz only 0.1
seconds. STFT uses the same window length for all frequencies, which is
simpler but not optimal for all frequencies.

%% 5. Hilbert Transform for frequency band power
% Another method for analyzing frequency band power is the Hilbert Transform.
% You filter the data in a specific frequency band and then use the Hilbert
% Transform to extract the envelope, which represents the power.

%% 5.1 Filtering data
% First, you filter the data in a specific frequency band:
%
% Example: Filter alpha band (8–13 Hz)
% EEG_short = pop_select(EEG, 'time', [0 10]);  % First 10 seconds
% EEG_short_filt = pop_eegfiltnew(EEG_short, 8, 13);  % Band-pass filter 8–13 Hz
%
% Here you cut out the first 10 seconds and then filter in the alpha band
% (8–13 Hz). The result is a signal that mainly contains alpha oscillations.

%% 5.2 Hilbert Transform
% The Hilbert Transform extracts the envelope of the filtered signal, which
% represents the power in the frequency band:
%
% channel = 60;
% alphapow = abs(hilbert(EEG_short_filt.data(channel, :)));
%
% The function `hilbert` calculates the analytical representation of the
% signal (complex numbers). `abs` gives you the magnitude, which is the
% envelope. This envelope shows you how the alpha power changes over time.
%
% IMPORTANT NOTE: The Hilbert Transform only works well when the signal
% mainly consists of one frequency component. That's why you filter first in
% the desired frequency band. If you apply the Hilbert Transform to
% unfiltered data, you don't get a meaningful power estimate.

%% 5.3 Visualization
% You can visualize the filtered data and the Hilbert-transformed power:
%
% figure;
% plot(EEG_short_filt.times, EEG_short_filt.data(channel, :), 'LineWidth', 2)
% hold on
% plot(EEG_short_filt.times, alphapow, 'LineWidth', 2)
% yline(0)
% legend('Data in alpha frequency band (8–13 Hz)', ...
%     'Hilbert-transformed alpha power')
% ylabel('Amplitude [\muV]')
% xlabel('Time [ms]')
% set(gca, 'FontSize', 25)
%
% The blue line shows the filtered signal (alpha oscillations), the red line
% shows the envelope (alpha power). You see how the power varies over time:
% Sometimes it's high (strong alpha oscillations), sometimes low (weak alpha
% oscillations).

EXCURSUS Analytical signals and Hilbert Transform: The Hilbert Transform
creates an "analytical signal" from a real signal. An analytical signal is a
complex number whose real part is the original signal and whose imaginary
part is the Hilbert-transformed signal. The magnitude (abs) of this complex
signal is the envelope, which shows the instantaneous amplitude (and thus the
power). The phase shows the instantaneous phase of the oscillation. For
frequency band power, we're mainly interested in the envelope (the magnitude).

%% Summary
% In this tutorial, you have learned:
%
% 1. **Why time-frequency analysis**: It shows you how power in different
%    frequency bands changes over time, which is lost in ERPs.
%
% 2. **Power spectrum**: How you calculate a power spectrum with `spectopo`
%    that shows you which frequencies are present in the signal.
%
% 3. **STFT by hand**: How you do the STFT "by hand" by calling `spectopo`
%    for different time windows, and how you visualize the results with
%    `imagesc`.
%
% 4. **Time-frequency analysis with EEGLAB**: How you use `pop_newtimef` to
%    automatically perform time-frequency analyses, both with STFT and with
%    wavelets.
%
% 5. **Hilbert Transform**: How you use the Hilbert Transform to extract the
%    power in a specific frequency band.
%
% These methods you will use frequently later in the block course when
% analyzing oscillations (e.g., alpha desynchronization, theta power
% increase). It's worth familiarizing yourself with them.
