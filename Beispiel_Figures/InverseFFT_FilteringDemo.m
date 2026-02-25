%% Inverse FFT filtering demo from power spectrum
% This script demonstrates how to:
% 1) compute a signal's power spectrum
% 2) define a frequency-domain filter mask
% 3) reconstruct the filtered signal with inverse FFT

clear;
close all;
clc;

%% 1) Create synthetic signal (clean oscillation + noise + line noise)
fs = 500;                    % sampling rate [Hz]
duration = 2;                % seconds
t = 0:1/fs:duration-1/fs;    % time vector
N = numel(t);

% Useful component around 10 Hz + slower drift + line noise + random noise
x_clean = 1.0*sin(2*pi*10*t);
x_drift = 0.4*sin(2*pi*2*t);
x_line = 0.5*sin(2*pi*50*t);
x_noise = 0.35*randn(size(t));
x = x_clean + x_drift + x_line + x_noise;

%% 2) FFT and power spectrum
X = fft(x);
P2 = abs(X).^2 / N;          % two-sided power spectrum

f = (0:N-1)*(fs/N);          % frequency axis for two-sided FFT
halfIdx = 1:floor(N/2)+1;    % one-sided view for plotting
f_one = f(halfIdx);
P_one = P2(halfIdx);

%% 3) Build frequency-domain filter mask
% Keep only 8-14 Hz (alpha-like band) and suppress everything else.
% Because FFT is symmetric for real signals, we also keep mirrored bins.
passBand = [8 14];
mask = (f >= passBand(1) & f <= passBand(2)) | ...
       (f >= fs-passBand(2) & f <= fs-passBand(1));

% Apply mask in Fourier domain
X_filt = X .* mask;
P2_filt = abs(X_filt).^2 / N;
P_one_filt = P2_filt(halfIdx);

%% 4) Inverse FFT to reconstruct filtered time series
x_filt = ifft(X_filt, 'symmetric');

%% 5) Visualization
close all

% Panel A: original signal
figure('Position', [0 0 1512 982/2], 'Color', 'W');
plot(t, x, 'k', 'LineWidth', 1.0);
xlabel('Time [s]');
ylabel('Amplitude');
title('Original signal (time domain)');
xlim([0 duration]);
saveas(gcf, '/Users/Arne/Documents/GitHub/NeurophysiologyBlockCourse/Beispiel_Figures/InverseFFT_Filter/Blockkurs_InverseFFT_Filter_origSignal.png')

% Panel B: original power spectrum + selected passband
figure('Position', [0 0 1512/2 982], 'Color', 'W');
plot(f_one, P_one, 'k', 'LineWidth', 1.2);
hold on;
yl = ylim;
patch([passBand(1) passBand(2) passBand(2) passBand(1)], ...
      [yl(1) yl(1) yl(2) yl(2)], ...
      [0.2 0.6 1.0], ...
      'FaceAlpha', 0.18, ...
      'EdgeColor', 'none');
plot(f_one, P_one, 'k', 'LineWidth', 1.2); % redraw on top
xlabel('Frequency [Hz]');
ylabel('Power');
title('Power spectrum with filter band (8-14 Hz)');
xlim([0 80]);
saveas(gcf, '/Users/Arne/Documents/GitHub/NeurophysiologyBlockCourse/Beispiel_Figures/InverseFFT_Filter/Blockkurs_InverseFFT_Filter_powSpectrm.png')

% Panel C: filtered power spectrum
figure('Position', [0 0 1512/2 982], 'Color', 'W');
plot(f_one, P_one_filt, 'b', 'LineWidth', 1.2);
xlabel('Frequency [Hz]');
ylabel('Power');
title('Power spectrum after frequency masking');
xlim([0 80]);
saveas(gcf, '/Users/Arne/Documents/GitHub/NeurophysiologyBlockCourse/Beispiel_Figures/InverseFFT_Filter/Blockkurs_InverseFFT_Filter_powSpectrmFilt.png')

% Panel D: reconstructed filtered signal (via IFFT)
figure('Position', [0 0 1512 982/2], 'Color', 'W');
plot(t, x, 'Color', [0.75 0.75 0.75], 'LineWidth', 1.0);
hold on;
plot(t, x_filt, 'b', 'LineWidth', 1.8);
xlabel('Time [s]');
ylabel('Amplitude');
title('Reconstructed signal using inverse FFT');
legend({'Original', 'Filtered (IFFT)'}, 'Location', 'best');
xlim([0 duration]);
saveas(gcf, '/Users/Arne/Documents/GitHub/NeurophysiologyBlockCourse/Beispiel_Figures/InverseFFT_Filter/Blockkurs_InverseFFT_Filter_reconstructedSignal.png')