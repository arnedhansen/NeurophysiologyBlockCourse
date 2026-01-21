%% Tutorial 7 – Signals, Filters, and Time-Frequency Analysis (Basics)
% This optional tutorial deepens the fundamentals of digital signal processing
% for EEG signals. You will learn concepts here that are important for
% understanding EEG analyses.
%
% Contents:
% 
% - 0. Introduction
% - 1. Signals in the time domain
%   - 1.1 What is a signal? Examples from EEG
%   - 1.2 Discrete vs. continuous signals
%   - 1.3 Sampling rate and Nyquist frequency
% - 2. Understanding aliasing
%   - 2.1 Intuition: sampling too infrequently
%   - 2.2 Aliasing simulation in MATLAB
%   - 2.3 Practical consequences for EEG recordings
% - 3. Signals in the frequency domain
%   - 3.1 Sinusoidal waves and frequencies
%   - 3.2 Fourier Transform in MATLAB (fft)
%   - 3.3 Amplitude and power spectra
% - 4. Filtering signals
%   - 4.1 Why do we filter EEG?
%   - 4.2 High-pass, low-pass, band-pass filters
%   - 4.3 Simple filter examples in MATLAB
%   - 4.4 Visualization: Signal before and after filtering
% - 5. Brief introduction to time-frequency analysis
%   - 5.1 Idea of the Short-Time Fourier Transform (STFT)
%   - 5.2 Window length and time-frequency trade-off
%   - 5.3 First time-frequency plots

%% 0. Introduction
% In this tutorial, you deepen your understanding of digital signals and their
% processing. You have already learned the basics in Tutorial 2 (sinusoidal
% waves, frequency, amplitude, phase). Here we focus on practical aspects
% that are important when working with real EEG data:
% - How are signals sampled?
% - What happens when the sampling rate is too low (aliasing)?
% - How do you analyze signals in the frequency domain?
% - How do you filter signals to isolate specific frequency ranges?
% - How do you analyze signals simultaneously in time and frequency?
%
% These tutorials are designed so that you don't have to memorize everything.
% Rather, it's about developing a basic understanding of how digital signals
% work. You will have many opportunities to apply what you've learned later
% in the block course.

%% 1. Signals in the time domain
% In the time domain, we consider how a signal changes over time. For EEG,
% this is, e.g., the voltage change in µV over time in milliseconds.

%% 1.1 What is a signal? Examples from EEG
% A signal is a function that describes a physical quantity over time. For
% EEG, this is the electrical voltage measured at the electrodes.
%
% Example: Simple sinusoid signal
fs  = 250;          % Sampling rate in Hz
t   = 0:1/fs:2;     % Time vector: 2 seconds in steps of 1/fs
sig = sin(2*pi*10*t);  % 10-Hz sinusoidal wave

figure;
plot(t, sig);
xlabel('Time (s)');
ylabel('Amplitude');
title('10-Hz sinusoid signal in the time domain');
grid on;

% This signal shows a sinusoidal wave with a frequency of 10 Hz. In 2
% seconds, you see 20 complete cycles (2 seconds × 10 Hz = 20 cycles).
%
% Examples of signals in EEG analysis:
% - **Raw EEG**: The measured voltage at one channel over several seconds
% - **ERPs**: Averaged signals over many trials (Event-Related Potentials)
% - **Frequency band power**: Time courses of specific frequency bands (e.g.,
%   alpha power over time)

%% 1.2 Discrete vs. continuous signals
% There is an important difference between continuous and discrete signals:
%
% **Continuous**: The signal is defined at every time point (theoretically
% infinitely fine). In reality, there are no truly continuous signals, but
% you can imagine them as smooth curves.
%
% **Discrete**: The signal is only defined at specific time points. For EEG,
% e.g., a value is measured every 4 ms (at a sampling rate of 250 Hz).
% Between these time points, we don't know what the signal does – we must
% estimate it from the measured values.
%
% Example: Comparison continuous vs. discrete
t_continuous = 0:0.001:1;  % Very fine sampling (1000 Hz)
t_discrete   = 0:1/250:1;   % Discretization at 250 Hz

sig_cont = sin(2*pi*10*t_continuous);
sig_disc = sin(2*pi*10*t_discrete);

figure;
plot(t_continuous, sig_cont, 'b-', 'LineWidth', 1);
hold on;
stem(t_discrete, sig_disc, 'r', 'MarkerSize', 4);
hold off;
xlabel('Time (s)');
ylabel('Amplitude');
title('Continuous (blue) vs. discrete (red)');
legend('Continuous', 'Discrete', 'Location', 'best');
grid on;

% The blue line shows the "continuous" signal (very finely sampled), the red
% points show the discrete sampling points at 250 Hz. You see that the
% discrete points represent the signal well, but between the points we don't
% know exactly what happens.
%
% IMPORTANT NOTE: In MATLAB, we always work with discrete signals, even when
% we plot them as continuous lines. The "continuity" comes from MATLAB
% connecting the points with lines.

%% 1.3 Sampling rate and Nyquist frequency
% The sampling rate (`fs`) indicates how many measurement points per second
% are recorded. At a sampling rate of 250 Hz, 250 values per second are
% measured, i.e., one value every 4 ms.

fs1 = 100;          % 100 Hz sampling rate
nyquist1 = fs1/2   % Nyquist frequency = 50 Hz

fs2 = 500;          % 500 Hz sampling rate
nyquist2 = fs2/2   % Nyquist frequency = 250 Hz

% The **Nyquist frequency** is `fs/2` and is the maximum frequency that can
% be correctly represented without aliasing. This means:
% - At a sampling rate of 100 Hz, you can correctly represent frequencies
%   up to 50 Hz
% - At a sampling rate of 500 Hz, you can correctly represent frequencies
%   up to 250 Hz
%
% IMPORTANT NOTE: The Nyquist frequency is the theoretical upper limit. In
% practice, the highest frequency in the signal should be well below the
% Nyquist frequency to ensure that no aliasing effects occur. That's why EEG
% data is often filtered with a low-pass filter at 40 Hz, even if the
% sampling rate is 250 Hz (Nyquist = 125 Hz).

EXCURSUS Nyquist-Shannon sampling theorem: The Nyquist-Shannon sampling
theorem states that a signal containing frequencies up to f_max must be
sampled at a rate of at least 2×f_max to be able to reconstruct it without
information loss. The Nyquist frequency (fs/2) is thus the maximum frequency
that can be correctly represented. If the signal contains frequencies above
the Nyquist frequency, aliasing occurs (see next section).

%% 2. Understanding aliasing
% Aliasing occurs when the sampling rate is too low to correctly represent
% the high frequencies contained in the signal. High frequencies then appear
% as lower frequencies.

%% 2.1 Intuition: sampling too infrequently
% Imagine you're filming a rotating wheel with a camera. If the wheel rotates
% very quickly and the camera takes pictures too slowly, it can look as if
% the wheel is rotating backwards or not at all. That's aliasing.
%
% The same happens with signals: If a high frequency is sampled too
% infrequently, it appears as a lower frequency.
%
% Example: 30-Hz signal with different sampling rates
f_sig = 30;   % Signal frequency 30 Hz

fs_low  = 40;                 % too low sampling rate (Nyquist = 20 Hz)
t_low   = 0:1/fs_low:1;
sig_low = sin(2*pi*f_sig*t_low);

fs_high  = 200;               % sufficiently high sampling rate (Nyquist = 100 Hz)
t_high   = 0:1/fs_high:1;
sig_high = sin(2*pi*f_sig*t_high);

figure;
subplot(2,1,1);
stem(t_low, sig_low, 'filled');
hold on;
plot(t_high, sig_high, 'r:', 'LineWidth', 2);
hold off;
xlabel('Time (s)');
ylabel('Amplitude');
title('30 Hz at fs = 40 Hz (aliasing risk)');
legend('sampled points', '"true" signal', 'Location', 'best');
grid on;

subplot(2,1,2);
plot(t_high, sig_high);
xlabel('Time (s)');
ylabel('Amplitude');
title('30 Hz at fs = 200 Hz (well sampled)');
grid on;

% In the upper plot, you see that at a sampling rate of 40 Hz (Nyquist =
% 20 Hz), the 30-Hz signal cannot be correctly sampled. The red points
% show a different pattern than the blue line (the "true" signal). In the
% lower plot, you see that at 200 Hz sampling rate, the signal is correctly
% sampled.
%
% IMPORTANT NOTE: At a sampling rate of 40 Hz, a 30-Hz signal cannot be
% correctly represented because 30 Hz > 20 Hz (Nyquist). The signal is
% "aliased" and appears as a lower frequency (here: 10 Hz, because 30 Hz -
% 20 Hz = 10 Hz).

%% 2.2 Aliasing simulation in MATLAB
% We now explicitly simulate how a high frequency appears as a lower
% frequency at too low a sampling rate:

fs_alias = 100;  % Sampling rate 100 Hz (Nyquist = 50 Hz)
f_high   = 80;   % Signal with 80 Hz (higher than Nyquist!)
t_alias  = 0:1/fs_alias:1;
sig_alias = sin(2*pi*f_high*t_alias);

figure;
stem(t_alias, sig_alias, 'filled');
xlabel('Time (s)');
ylabel('Amplitude');
title('80 Hz at fs = 100 Hz (appears as 20 Hz due to aliasing)');
grid on;

% If you look at the points, you see a pattern that corresponds to a 20-Hz
% wave, not an 80-Hz wave! This is because 80 Hz > 50 Hz (Nyquist). The
% frequency is "folded" and appears as 80 - 100 = -20 Hz, which is
% equivalent to 20 Hz.
%
% IMPORTANT NOTE: The "folded" frequency is calculated as: f_aliased =
% |f_signal - n×fs|, where n is an integer chosen so that f_aliased lies
% between 0 and fs/2. Here: |80 - 100| = 20 Hz.

%% 2.3 Practical consequences for EEG recordings
% For EEG recordings, it's important that the sampling rate is high enough
% to correctly sample all relevant frequencies. Typical EEG frequency bands
% are:
% - Delta: 0.5–4 Hz
% - Theta: 4–8 Hz
% - Alpha: 8–13 Hz
% - Beta: 13–30 Hz
% - Gamma: 30–100 Hz (less frequently analyzed)
%
% At a sampling rate of 250 Hz (Nyquist = 125 Hz), all these frequencies
% can theoretically be correctly sampled. But: If there are interference
% signals containing higher frequencies (e.g., line noise at 50 Hz or muscle
% artifacts at >100 Hz), these can appear as lower frequencies through
% aliasing and interfere with the analysis.
%
% That's why one normally uses:
% 1. **Anti-aliasing filter** before digitization (hardware-side)
% 2. **Low-pass filter** in software (e.g., at 40 Hz) to remove high
%    frequencies before they can be aliased

EXCURSUS Anti-aliasing filter: Before a signal is digitized, it should be
passed through an anti-aliasing filter (low-pass filter) that removes all
frequencies above the Nyquist frequency. This filter is usually built into
the EEG system on the hardware side. In software, one then additionally uses
low-pass filters (e.g., at 40 Hz) to ensure that no high frequencies
interfere with the analysis.

%% 3. Signals in the frequency domain
% In the frequency domain, we consider which frequencies are contained in a
% signal and how strongly they are expressed. This is very useful for
% identifying, e.g., alpha oscillations.

%% 3.1 Sinusoidal waves and frequencies
% A sinusoid signal consists of a single frequency. If you calculate a
% frequency spectrum, you see a peak at this frequency.
%
% Example: 10-Hz sinusoid signal
fs = 250;
t = 0:1/fs:2;  % 2 seconds
sig_10hz = sin(2*pi*10*t);

figure;
subplot(2,1,1);
plot(t, sig_10hz);
xlabel('Time (s)');
ylabel('Amplitude');
title('10-Hz sinusoid signal in the time domain');
grid on;

% In the time domain, you see a sinusoidal wave. In the frequency domain (see
% next section), you would see a peak at 10 Hz.

%% 3.2 Fourier Transform in MATLAB (fft)
% The Fourier Transform decomposes a signal into its frequency components. In
% MATLAB, you use the function `fft` for this:
%
% Calculate FFT
fft_res = fft(sig_10hz);
fft_res = fft_res(1:length(fft_res)/2);  % Only first half (symmetry)
%
% Create frequency axis
frequencies = (0:length(fft_res)-1) * fs / length(sig_10hz);

figure;
subplot(2,1,2);
plot(frequencies, abs(fft_res));
xlabel('Frequency (Hz)');
ylabel('Amplitude');
title('Frequency spectrum (FFT)');
xlim([0 50]);  % Show only up to 50 Hz
grid on;

% The function `fft` calculates the Fast Fourier Transform (FFT). `abs` gives
% you the amplitude (without phase information). The frequency axis is
% calculated as: `f = (0:N-1) * fs / N`, where N is the number of data points.
%
% You see a peak at 10 Hz – exactly the frequency contained in the signal!
%
% IMPORTANT NOTE: The frequency resolution of the FFT is `fs / N`, where N is
% the number of data points. With 2 seconds of data at 250 Hz, you have N =
% 500 data points, so a frequency resolution of 250/500 = 0.5 Hz. This means
% you can distinguish frequencies in steps of 0.5 Hz.

EXCURSUS Complex numbers and FFT: The FFT returns complex numbers that
contain both amplitude and phase. `abs(fft_res)` gives you the magnitude
(amplitude), `angle(fft_res)` would give you the phase. For most
applications, we're mainly interested in the amplitude (power). The phase is
important for phase analyses (e.g., phase coherence between channels), which
are not covered here.

%% 3.3 Amplitude and power spectra
% There are two types of spectra:
% - **Amplitude spectrum**: shows the amplitude of each frequency component
% - **Power spectrum**: shows the power of each frequency component (amplitude²)
%
% Amplitude spectrum
amplitude_spectrum = abs(fft_res);
%
% Power spectrum (Power = Amplitude²)
power_spectrum = abs(fft_res).^2;

figure;
subplot(2,1,1);
plot(frequencies, amplitude_spectrum);
xlabel('Frequency (Hz)');
ylabel('Amplitude');
title('Amplitude spectrum');
xlim([0 50]);
grid on;

subplot(2,1,2);
plot(frequencies, power_spectrum);
xlabel('Frequency (Hz)');
ylabel('Power');
title('Power spectrum');
xlim([0 50]);
grid on;

% The amplitude spectrum shows the amplitude of each frequency component. The
% power spectrum shows the power (amplitude²). Power is often more useful
% because it better represents the "strength" of a frequency component.
%
% IMPORTANT NOTE: In EEG analysis, one often uses the power spectrum because
% it better correlates with the actual electrical power. Power is often
% displayed in dB (decibels) to better visualize large differences.

%% 4. Filtering signals
% Filtering removes unwanted frequency components from a signal. This is
% important to remove, e.g., slow drifts or high noise.

%% 4.1 Why do we filter EEG?
% EEG signals contain many different frequency components:
% - **Low-frequency drifts** (< 1 Hz): Slow changes in baseline, often
%   caused by movement artifacts or electrode drift
% - **Low-frequency oscillations** (1–4 Hz): Delta band, often during sleep
% - **Alpha/Beta/Gamma** (8–100 Hz): The actual oscillations of interest
% - **High noise** (> 40 Hz): Muscle artifacts, line noise, etc.
%
% Through filtering, we can:
% - Remove slow drifts (high-pass filter)
% - Remove high noise (low-pass filter)
% - Isolate specific frequency bands (band-pass filter)

%% 4.2 High-pass, low-pass, band-pass filters
% There are three main types of filters:
%
% **High-pass filter**: Lets only high frequencies through, removes low
% frequencies. Example: Filter at 1 Hz removes everything < 1 Hz (slow
% drifts).
%
% **Low-pass filter**: Lets only low frequencies through, removes high
% frequencies. Example: Filter at 40 Hz removes everything > 40 Hz (high
% noise).
%
% **Band-pass filter**: Lets only frequencies in a specific range through.
% Example: Filter from 8–13 Hz isolates the alpha band.

%% 4.3 Simple filter examples in MATLAB
% In MATLAB, you can create filters with the function `designfilt` and then
% apply them with `filtfilt`:
%
% Example: High-pass filter at 1 Hz
d_high = designfilt('highpassiir', 'FilterOrder', 4, ...
    'HalfPowerFrequency', 1, 'SampleRate', fs);
sig_filtered_high = filtfilt(d_high, sig_10hz);
%
% Example: Low-pass filter at 40 Hz
d_low = designfilt('lowpassiir', 'FilterOrder', 4, ...
    'HalfPowerFrequency', 40, 'SampleRate', fs);
sig_filtered_low = filtfilt(d_low, sig_10hz);
%
% Example: Band-pass filter for alpha band (8–13 Hz)
d_band = designfilt('bandpassiir', 'FilterOrder', 4, ...
    'HalfPowerFrequency1', 8, 'HalfPowerFrequency2', 13, 'SampleRate', fs);
sig_filtered_band = filtfilt(d_band, sig_10hz);
%
% The function `designfilt` creates a filter with specific properties:
% - `'highpassiir'`, `'lowpassiir'`, `'bandpassiir'`: Filter type
% - `'FilterOrder'`: Order of the filter (higher = steeper, but more
%   distortions)
% - `'HalfPowerFrequency'`: Cutoff frequency (at which power is reduced to
%   half)
% - `'SampleRate'`: Sampling rate
%
% `filtfilt` applies the filter. `filtfilt` (not `filter`!) applies the
% filter forward and backward, which avoids phase distortions.
%
% IMPORTANT NOTE: In EEGLAB, you normally use `pop_eegfiltnew`, not
% `designfilt`/`filtfilt`. But `designfilt`/`filtfilt` are useful for
% understanding how filters work and for simple examples.

%% 4.4 Visualization: Signal before and after filtering
% You can compare the signal before and after filtering:
%
% Create a signal with multiple frequencies
sig_mixed = sin(2*pi*10*t) + 0.5*sin(2*pi*50*t) + 0.2*randn(size(t));
%
% High-pass filter at 5 Hz (removes < 5 Hz)
d_hp = designfilt('highpassiir', 'FilterOrder', 4, ...
    'HalfPowerFrequency', 5, 'SampleRate', fs);
sig_hp = filtfilt(d_hp, sig_mixed);

figure;
subplot(3,1,1);
plot(t, sig_mixed);
xlabel('Time (s)');
ylabel('Amplitude');
title('Original: 10 Hz + 50 Hz + noise');
grid on;

subplot(3,1,2);
plot(t, sig_hp);
xlabel('Time (s)');
ylabel('Amplitude');
title('After high-pass filter (5 Hz): 10 Hz + 50 Hz remain');
grid on;

% Compare frequency spectra
fft_orig = abs(fft(sig_mixed));
fft_hp   = abs(fft(sig_hp));
freqs = (0:length(fft_orig)/2-1) * fs / length(sig_mixed);

subplot(3,1,3);
plot(freqs, fft_orig(1:length(freqs)), 'b-', 'LineWidth', 1);
hold on;
plot(freqs, fft_hp(1:length(freqs)), 'r-', 'LineWidth', 1);
hold off;
xlabel('Frequency (Hz)');
ylabel('Amplitude');
title('Frequency spectra: Original (blue) vs. filtered (red)');
xlim([0 60]);
legend('Original', 'Filtered', 'Location', 'best');
grid on;

% In the upper plot, you see the original signal with multiple frequencies
% and noise. In the middle plot, you see the signal after the high-pass
% filter – the low frequencies (< 5 Hz) were removed. In the lower plot, you
% see the frequency spectra: In the filtered signal (red), the low
% frequencies are clearly reduced.

EXCURSUS Filter types: There are various filter types (Butterworth,
Chebyshev, Elliptic, etc.) that differ in their properties. Butterworth
filters have a flat passband characteristic, Chebyshev filters have a
steeper transition but more ripple. For most EEG applications, Butterworth
filters are a good choice. The filter order determines how steep the
transition is: higher order = steeper, but more distortions and longer
settling time.

%% 5. Brief introduction to time-frequency analysis
% Time-frequency analysis shows you how the frequency components of a signal
% change over time. This is important for analyzing, e.g., alpha
% desynchronization.

%% 5.1 Idea of the Short-Time Fourier Transform (STFT)
% The STFT calculates Fourier spectra in sliding time windows. Each window
% provides a spectrum, and together they form a time-frequency representation.
%
% Example: Signal with changing frequency
fs_stft = 250;
t_stft = 0:1/fs_stft:5;  % 5 seconds
sig1 = sin(2*pi*10*t_stft(1:round(length(t_stft)*0.5)));  % 10 Hz for first half
sig2 = sin(2*pi*20*t_stft(round(length(t_stft)*0.5)+1:end));  % 20 Hz for second half
signal_tf = [sig1, sig2];
%
% STFT with spectrogram
win_length = round(0.5*fs_stft);  % 500 ms window
overlap    = round(0.4*fs_stft);   % 400 ms overlap
nfft       = 512;
%
% [S, F, T, P] = spectrogram(signal_tf, win_length, overlap, nfft, fs_stft);
%
% figure;
% imagesc(T, F, 10*log10(P));
% axis xy;
% xlabel('Time (s)');
% ylabel('Frequency (Hz)');
% title('Time-frequency representation (STFT)');
% colorbar;
% ylim([1 30]);
%
% The function `spectrogram` calculates the STFT. The parameters are:
% - `signal_tf`: the signal
% - `win_length`: window length in data points
% - `overlap`: overlap between windows
% - `nfft`: number of FFT points
% - `fs_stft`: sampling rate
%
% The result is a matrix `P` with dimensions [frequencies × time windows].
% The colors show the power: Red = high power, Blue = low power.
%
% You see that in the first half of the time, the power at 10 Hz is high, in
% the second half at 20 Hz. This shows you how frequencies change over time!

%% 5.2 Window length and time-frequency trade-off
% There is an important trade-off between time and frequency resolution:
%
% - **Longer windows**: good frequency resolution, but poor time resolution
%   (you don't see exactly when something happens)
% - **Shorter windows**: good time resolution, but poor frequency resolution
%   (you can't distinguish between close frequencies)
%
% Comparison: 250 ms vs. 1 s windows
win_short = round(0.25*fs_stft);  % 250 ms
win_long  = round(1.0*fs_stft);   % 1 s
%
% [S_short, F_short, T_short, P_short] = spectrogram(signal_tf, win_short, ...
%     round(0.2*win_short), nfft, fs_stft);
% [S_long, F_long, T_long, P_long] = spectrogram(signal_tf, win_long, ...
%     round(0.8*win_long), nfft, fs_stft);
%
% figure;
% subplot(2,1,1);
% imagesc(T_short, F_short, 10*log10(P_short));
% axis xy;
% xlabel('Time (s)');
% ylabel('Frequency (Hz)');
% title('STFT with 250 ms windows (good time resolution)');
% colorbar;
% ylim([1 30]);
%
% subplot(2,1,2);
% imagesc(T_long, F_long, 10*log10(P_long));
% axis xy;
% xlabel('Time (s)');
% ylabel('Frequency (Hz)');
% title('STFT with 1 s windows (good frequency resolution)');
% colorbar;
% ylim([1 30]);
%
% In the upper plot (short windows), you see good time resolution – you can
% see exactly when the change from 10 Hz to 20 Hz happens. But the frequency
% resolution is worse – the bands are wider.
%
% In the lower plot (long windows), you see good frequency resolution – the
% bands are narrower. But the time resolution is worse – you see fewer
% details in time.
%
% IMPORTANT NOTE: The frequency resolution is 1/T, where T is the window
% length in seconds. With 250 ms windows, the frequency resolution is 4 Hz,
% with 1 s windows it's 1 Hz (better). But the time resolution is
% correspondingly worse.

%% 5.3 First time-frequency plots
% You can also create time-frequency plots for more complex signals:
%
% Example: Signal with alpha band (10 Hz) that decreases after 2 seconds
t_alpha = 0:1/fs_stft:4;
alpha_signal = sin(2*pi*10*t_alpha);
modulation = ones(size(t_alpha));
modulation(t_alpha >= 2) = 0.3;  % After 2 s, amplitude is reduced
signal_alpha_mod = alpha_signal .* modulation;
%
% STFT
% [S_alpha, F_alpha, T_alpha, P_alpha] = spectrogram(signal_alpha_mod, ...
%     win_length, overlap, nfft, fs_stft);
%
% figure;
% subplot(2,1,1);
% plot(t_alpha, signal_alpha_mod);
% xlabel('Time (s)');
% ylabel('Amplitude');
% title('Alpha signal with modulation (desynchronization after 2 s)');
% grid on;
%
% subplot(2,1,2);
% imagesc(T_alpha, F_alpha, 10*log10(P_alpha));
% axis xy;
% xlabel('Time (s)');
% ylabel('Frequency (Hz)');
% title('Time-frequency representation');
% colorbar;
% ylim([1 30]);
%
% In the upper plot, you see the signal: Before 2 seconds, the amplitude is
% high, afterwards low (alpha desynchronization). In the lower plot, you see
% the time-frequency representation: Before 2 seconds, the power at 10 Hz
% is high (red), afterwards low (blue). This shows you exactly when and in
% which frequency band the change happens!

%% Summary
% In this tutorial, you have learned:
%
% 1. **Signals in the time domain**: How signals are represented over time,
%    and the difference between continuous and discrete signals
%
% 2. **Sampling rate and Nyquist frequency**: How the sampling rate
%    determines the maximum representable frequency (Nyquist = fs/2)
%
% 3. **Aliasing**: What happens when the sampling rate is too low (high
%    frequencies appear as lower frequencies)
%
% 4. **Frequency domain**: How the Fourier Transform decomposes a signal
%    into its frequency components, and the difference between amplitude and
%    power spectrum
%
% 5. **Filtering**: How high-pass, low-pass, and band-pass filters work,
%    and why we filter EEG data (to remove drifts and noise)
%
% 6. **Time-frequency analysis**: How the STFT shows how frequencies change
%    over time, and the trade-off between time and frequency resolution
%
% These concepts are fundamental for understanding EEG analyses. You will use
% them frequently later in the block course when working with real EEG data.
