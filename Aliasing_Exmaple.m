%% Aliasing Example for Block Course Intro Slides
clc
clear
close all

%set(gcf, "Position", [0, 0, 1800, 1200])

% Parameters
f_signal = 50; % Frequency of the signal (Hz)
T_signal = 1 / f_signal; % Period of the signal (seconds)
f_sampling1 = 150; % Sampling rate 1 (Hz) - Aliasing will occur
f_sampling2 = 200; % Sampling rate 2 (Hz) - No aliasing
t_signal = 0:1/1000:5*T_signal; % Time vector for a couple of periods of the signal

% Generate the signal
signal = sin(2 * pi * f_signal * t_signal);

% Sampling time vectors
t_sampling1 = 0:1/f_sampling1:5*T_signal; % Sampling time vector for first rate
t_sampling2 = 0:1/f_sampling2:5*T_signal; % Sampling time vector for second rate

% Sample the signal
signal_sampled1 = sin(2 * pi * f_signal * t_sampling1); % Sampled signal at f_sampling1
signal_sampled2 = sin(2 * pi * f_signal * t_sampling2); % Sampled signal at f_sampling2

% Plot the results
figure;
set(gcf, "Position", [0, 0, 1800, 1200])

% Plot the continuous signal and aliased sampled signal
plot(t_signal, signal, 'b', 'LineWidth', 1.5); 
hold on;
plot(t_sampling1, signal_sampled1, 'r', 'LineWidth', 2);
plot(t_signal, signal, 'b', 'LineWidth', 1.5); hold on;
plot(t_sampling2, signal_sampled2, 'g', 'LineWidth', 2);
title('Aliased Signal (Sampling Rate = 100 Hz)', "FontSize", 20);
xlabel('Time [s]', "FontSize", 20);
ylabel('Amplitude', "FontSize", 20);
legend('Original Signal', 'Aliased Sampled Signal (100Hz)', 'Aliased Sampled Signal (200Hz)', "FontSize", 20);



