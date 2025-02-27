%% Aliasing Example for Block Course Intro Slides
clc
clear
close all

% Parameters
f_signal = 10; % Frequency of the signal (Hz)
T_signal = 1 / f_signal; % Period of the signal (seconds)
f_sampling1 = 15;
f_sampling2 = 20;
f_sampling3 = 20;
f_sampling4 = 250;
t_signal = 0:1/1000:1; % Time vector for a full second

% Generate the signal
signal = sin(2 * pi * f_signal * t_signal);

% Sampling time vectors
t_sampling1 = 0:1/f_sampling1:1; 
t_sampling2 = 0.025:1/f_sampling2:1.025; 
%t_sampling3 = 0.0025:1/f_sampling3:1.0025;
t_sampling3 = 0:1/f_sampling2:1; 
t_sampling4 = 0:1/f_sampling4:1;

% Sample the signal
signal_sampled1 = sin(2 * pi * f_signal * t_sampling1);
signal_sampled2 = sin(2 * pi * f_signal * t_sampling2);
signal_sampled3 = sin(2 * pi * f_signal * t_sampling3);
signal_sampled4 = sin(2 * pi * f_signal * t_sampling4);

% Plot the results
figure;
set(gcf, "Position", [0, 0, 1000, 1200], 'Color', 'W')

% Plot signal and aliased sample points
subplot(4, 1, 1)
plot(t_signal, signal, 'b', 'LineWidth', 1.5);
hold on
xlabel('Time [s]', "FontSize", 20);
ylabel('Amplitude', "FontSize", 20);
title('Original Signal (10 Hz) with Aliased Data Points', "FontSize", 20);
scatter(t_sampling1, signal_sampled1, 100, 'r', 'filled', 'o'); 
scatter(t_sampling2, signal_sampled2, 100, 'k', 'filled', 'o');
scatter(t_sampling3, signal_sampled3, 100, 'g', 'filled', 'o');
ylim([-1.05 1.05])
xlim([0 1])
yline(0, '--')
% legend([alias1, alias2], {'Aliased Sampled Signal (15 Hz)', 'Aliased Sampled Signal (20 Hz)'}, "FontSize", 20, 'Location','bestoutside');


% Aliased signal 1
subplot(4, 1, 2)
plot(t_sampling1, signal_sampled1, 'r', 'LineWidth', 2.5);
title('Aliased Signal (15 Hz)', "FontSize", 20);
ylim([-1.05 1.05])
yline(0, '--')

% Aliased signal 2
subplot(4, 1, 3)
plot(t_sampling2, signal_sampled2, 'k', 'LineWidth', 2.5);
title('NON-Aliased Signal (20 Hz)', "FontSize", 20);
ylim([-1.05 1.05])
yline(0, '--')
xlim([0 1])

% Aliased signal 3
subplot(4, 1, 4)
plot(t_sampling3, signal_sampled3, 'g', 'LineWidth', 2.5);
title('Aliased Signal (20 Hz)', "FontSize", 20);
ylim([-1.05 1.05])
xlim([0 1])
%yline(0, '--')

% Aliased signal 4
% subplot(5, 1, 5)
% plot(t_sampling4, signal_sampled4, 'magenta', 'LineWidth', 2.5);
% title('NON-Aliased Signal (250 Hz)', "FontSize", 20);
% ylim([-1.05 1.05])
% yline(0, '--')
