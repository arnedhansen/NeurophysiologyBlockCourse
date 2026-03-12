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
t_sampling3 = 0:1/f_sampling2:1; 
t_sampling4 = 0:1/f_sampling4:1;

% Sample the signal
signal_sampled1 = sin(2 * pi * f_signal * t_sampling1);
signal_sampled2 = sin(2 * pi * f_signal * t_sampling2);
signal_sampled3 = sin(2 * pi * f_signal * t_sampling3);
signal_sampled4 = sin(2 * pi * f_signal * t_sampling4); % New sampled signal    

% Fit a sinusoid to the aliased signals
ft1 = fit(t_sampling1(:), signal_sampled1(:), 'sin1');
sinModel = fittype('a*sin(2*pi*10*x + b)', 'independent', 'x', 'coefficients', {'a', 'b'});
ft2 = fit(t_sampling2(:), signal_sampled2(:), sinModel, 'StartPoint', [1, 0]); % Initial guess: amplitude = 1, phase = 0
ft3 = fit(t_sampling3(:), signal_sampled3(:), 'sin1'); 
ft4 = fit(t_sampling4(:), signal_sampled4(:), 'sin1'); % Fit for 250 Hz

% Evaluate the fitted model at the desired fine time points (e.g., t_signal)
signal_fitted1 = feval(ft1, t_signal);
signal_fitted2 = feval(ft2, t_signal);
signal_fitted3 = feval(ft3, t_signal);
signal_fitted4 = feval(ft4, t_signal);

% Plot the results
figure;
set(gcf, "Position", [0, 0, 1000, 1200], 'Color', 'W')

% Plot original signal
subplot(5, 1, 1)
plot(t_signal, signal, 'b', 'LineWidth', 1.5);
hold on
xlabel('Time [s]', "FontSize", 20);
ylabel('Amplitude', "FontSize", 20);
title('Original Signal (Frequency: 10 Hz)', "FontSize", 20);
ylim([-1.05 1.05])
xlim([0 1])
yline(0, '--')
saveas(gcf, '/Users/Arne/UZH/PhD/Teaching/25FS Blockkurs Neurophys Exp/Aliasing_Examples/Blockkurs_Aliasing_Original_Signal.png')

% Plot original signal with sampled data points
subplot(5, 1, 1)
plot(t_signal, signal, 'b', 'LineWidth', 1.5);
hold on
scatter(t_sampling1, signal_sampled1, 100, 'r', 'filled', 'o'); 
scatter(t_sampling2, signal_sampled2, 100, 'k', 'filled', 'o');
scatter(t_sampling3, signal_sampled3, 100, 'g', 'filled', 'o');
xlabel('Time [s]', "FontSize", 20);
ylabel('Amplitude', "FontSize", 20);
title('Original Signal (Frequency: 10 Hz) with Sampled Data Points', "FontSize", 20);
ylim([-1.05 1.05])
xlim([0 1])
yline(0, '--')
saveas(gcf, '/Users/Arne/UZH/PhD/Teaching/25FS Blockkurs Neurophys Exp/Aliasing_Examples/Blockkurs_Aliasing_Original_Signal_Sampled_Data_Points.png')

% Fitted signal 1 (15 Hz sampling)
subplot(5, 1, 2)
plot(t_sampling1, signal_sampled1, 'r--', 'LineWidth', 1.5);
hold on
scatter(t_sampling1, signal_sampled1, 100, 'r', 'filled', 'o'); 
plot(t_signal, signal_fitted1, 'r', 'LineWidth', 3); % Plot the fitted sinusoid
title('Fitted Sinusoid (Sampling Rate: 15 Hz)', "FontSize", 20);
ylim([-1.05 1.05])
yline(0, '--')
saveas(gcf, '/Users/Arne/UZH/PhD/Teaching/25FS Blockkurs Neurophys Exp/Aliasing_Examples/Blockkurs_Aliasing_Subplots12.png')

% Fitted signal 2 (20 Hz sampling)
subplot(5, 1, 3)
plot(t_sampling2, signal_sampled2, 'k--', 'LineWidth', 1.5);
hold on
scatter(t_sampling2, signal_sampled2, 100, 'k', 'filled', 'o');
plot(t_signal, signal_fitted2, 'k', 'LineWidth', 3);
title('Fitted Sinusoid (Sampling Rate: 20 Hz)', "FontSize", 20);
ylim([-1.05 1.05])
xlim([0 1])
yline(0, '--')
saveas(gcf, '/Users/Arne/UZH/PhD/Teaching/25FS Blockkurs Neurophys Exp/Aliasing_Examples/Blockkurs_Aliasing_Subplots123.png')

% Fitted signal 3 (20 Hz sampling)
subplot(5, 1, 4)
plot(t_sampling3, signal_sampled3, 'g--', 'LineWidth', 1.5);
hold on
scatter(t_sampling3, signal_sampled3, 100, 'g', 'filled', 'o');
plot(t_signal, signal_fitted3, 'g', 'LineWidth', 3);
title('Fitted Sinusoid (Sampling Rate: 20 Hz)', "FontSize", 20);
ylim([-1.05 1.05])
xlim([0 1])
saveas(gcf, '/Users/Arne/UZH/PhD/Teaching/25FS Blockkurs Neurophys Exp/Aliasing_Examples/Blockkurs_Aliasing_Subplots1234.png')

% Fitted signal 4 (250 Hz sampling)
subplot(5, 1, 5)
plot(t_sampling4, signal_sampled4, 'm--', 'LineWidth', 0.5);
hold on
scatter(t_sampling4, signal_sampled4, 20, 'm', 'filled', 'o');
plot(t_signal, signal_fitted4, 'm', 'LineWidth', 0.5);
title('Fitted Sinusoid (Sampling Rate: 250 Hz)', "FontSize", 20);
ylim([-1.05 1.05])
xlim([0 1])
yline(0, '--')
saveas(gcf, '/Users/Arne/UZH/PhD/Teaching/25FS Blockkurs Neurophys Exp/Aliasing_Examples/Blockkurs_Aliasing_Subplots12345.png')

