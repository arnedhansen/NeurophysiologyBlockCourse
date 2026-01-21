%% Block Course Tutorial 2: Digital Signal Processing

% 1. Important Concepts of Digital Signals
%     1.1 Sinusoidal Waves
%     1.2 Frequency
%     1.3 Amplitude
%     1.4 Phase
%     1.5 Interactive Visualization

% 1. Important Concepts of Digital Signals
% This tutorial covers the basics of digital signal processing, starting
% with the fundamental concepts of digital signals. We will learn what the
% frequency, amplitude, and phase of a signal are using sinusoidal waves.
% You don't need to memorize equations or learn anything by heart. Simply
% try to understand the core concepts of digital signal processing
% mentioned above using the examples.

% 1.1 Sinusoidal Waves
% A sinusoidal wave is a fundamental signal form described by the equation
% y(t) = A * sin(2 * pi * f * t + phase). Here:
%     A is the amplitude,
%     f is the frequency,
%     phase is the phase, and
%     t is time.
%
% This may look very complicated at first. But you absolutely don't need to
% memorize this; it's more about understanding what components such a wave
% consists of. We will therefore deal with the components of this equation
% in the following.

% Visualization of a sinusoidal wave
t = 0:0.001:1; % Time vector from 0 to 1 second in steps of 1ms (0.001s)
f = 5; % Frequency of the sinusoidal wave in Hz
A = 1; % Amplitude

% Calculate sinusoidal wave
y = A * sin(2 * pi * f * t);

figure;
plot(t, y, 'LineWidth', 2);
title('Sinusoidal wave (Frequency = 5Hz, Amplitude = 1)');
xlabel('Time (s)');
ylabel('Amplitude');

% The diagram shows a periodic waveform that starts at an amplitude
% (y-axis) of 0 and moves between +1 and -1. The wave completes five full
% cycles within one second, which corresponds to a frequency of 5 Hz. A
% cycle is defined as the complete movement of the wave from 0 upward,
% back down, and again to 0. The number of cycles per second is given in
% Hertz (Hz).
%
% Don't worry, we'll look at all of this step by step now.

% 1.2 Frequency
% The frequency of a signal describes how often an oscillation (cycle)
% occurs per second. It is measured in Hertz (Hz, "oscillations per
% second").

% Visualization of a sinusoidal wave with 2 Hz
t = 0:0.001:1; % Time vector from 0 to 1 second in steps of 1ms (0.001s)
f = 2; % Frequency (Hz)
A = 1; % Amplitude

% Calculate sinusoidal wave
y = A * sin(2 * pi * f * t);

% Plot first sinusoidal wave
figure;
plot(t, y, 'LineWidth', 2);
xlabel('Time [s]');
ylabel('Amplitude');
title('Sinusoidal wave (Frequency = 2Hz, Amplitude = 1)');

% The sinusoidal wave with a frequency of 2 Hz thus has 2 cycles in one
% second. Let's look at this again with a frequency of 10 Hz.

% Visualization of a sinusoidal wave with 10 Hz
t = 0:0.001:1; % Time vector from 0 to 1 second in steps of 1ms (0.001s)
f = 10; % Frequency (Hz)
A = 1; % Amplitude

% Calculate sinusoidal wave
y = A * sin(2 * pi * f * t);

% Plot first sinusoidal wave
figure;
plot(t, y, 'LineWidth', 2);
xlabel('Time [s]');
ylabel('Amplitude');
title('Sinusoidal wave (Frequency = 10Hz, Amplitude = 1)');

% 1.3 Amplitude
% The amplitude (y-axis) of a signal indicates the maximum expression of
% the signal. It determines how "strong" the signal is. To make amplitude
% differences visible, three sinusoidal waves with the same frequency but
% different amplitudes are plotted here in one figure.

% Visualization of signals with different amplitudes
t = 0:0.001:1; % Time vector from 0 to 1 second in steps of 1ms (0.001s)
f = 10; % Frequency (Hz)
A1 = 1; % Amplitude of first wave: 1
A2 = 5; % Amplitude of second wave: 5
A3 = 10; % Amplitude of third wave: 10

y1 = A1 * sin(2 * pi * f * t);
y2 = A2 * sin(2 * pi * f * t);
y3 = A3 * sin(2 * pi * f * t);

figure;
plot(t, y1, 'b', 'LineWidth', 2); % 'b' for blue line
title('Three sinusoidal waves (Frequency = 10Hz, Amplitude = 1 (blue), 5 (black), or 10 (red))');
xlabel('Time (s)');
ylabel('Amplitude');
hold on; % Allows us to display multiple signals in the same plot
plot(t, y2, 'k', 'LineWidth', 2); % 'k' for black line
plot(t, y3, 'r', 'LineWidth', 2); % 'r' for red line

% So we see here that our three sinusoidal waves have the same number of
% peaks and valleys – they have the same frequency – but they differ in
% the extent of the deflections upward and downward: the amplitude.

% 1.4 Phase
% The phase of a signal does not describe the frequency or amplitude of a
% signal, but rather where exactly we are on the cycle of a wave (for
% example, right at a "peak" or in a "valley"). Moreover, two signals can
% have identical amplitude and frequency but start at time 0s with a
% different "phase". This is called phase shift. In the following, the
% phase itself and phase shift are explained using π and radians. You don't
% necessarily need to understand this mathematically, but simply understand
% the concepts of phase/phase shift.

% Visualization of signals with different phases
f = 3; % Frequency (Hz)
phase1 = 0; % Phase 0
phase2 = pi/2; % Phase pi/2 = 180°/2 = 90°

y1 = sin(2 * pi * f * t + phase1);
y2 = sin(2 * pi * f * t - phase2);

figure;
plot(t, y1, 'b', 'LineWidth', 2);
hold on
plot(t, y2, 'r', 'LineWidth', 2);
title('Two sinusoidal waves (Frequency = 3Hz, Phase = 0 (blue) or 90° (red))');
xlabel('Time (s)');
ylabel('Amplitude');

% In this example, we have two identical sinusoidal waves (in terms of
% frequency and amplitude). The blue wave starts with phase 0 (thus at the
% exact midpoint of the oscillation), but the red wave is phase-shifted
% (here in the example by π/2 or 90°). In the visualization, this is shown
% by a shift of the red wave compared to the blue wave.
%
% You can think of it like two people sitting on a swing: If both swing at
% exactly the same time, they are always in exactly the same phase. If one
% person starts later, they are phase-shifted.
%
% In mathematics, this shift is measured with an angle in radians (a unit
% for angles). A complete oscillation cycle of a sinusoidal wave corresponds
% to 2π (360°) radians. A phase shift of π/2 (90°), as in our example,
% means that the second wave starts exactly one quarter of the oscillation
% later. In the plot, you can see this by the fact that the red wave always
% rises 25% later than the blue wave.

% 1.5 Interactive Visualization
% With the sliders in the code below, you are welcome to experiment a bit
% for a deeper understanding to see how the waves change depending on which
% values the parameters Amplitude, Frequency, or Phase take.

% Interactive visualization of a sinusoidal wave
t = 0:0.001:1; % Time vector from 0 to 1 second in steps of 1ms (0.001s)
Frequency  = 4;  % Frequency in Hz (0-100)
Amplitude = 4;   % Amplitude (0-25)
Phase     = 180; % Phase (0-360)

% Calculate sinusoidal wave
y = Amplitude * sin(2 * pi * Frequency * t + Phase);

% Plot sinusoidal wave
figure;
plot(t, y, 'LineWidth', 2);
xlabel('Time [s]');
ylabel('Amplitude');
title(['Sinusoidal wave (Frequency = ', num2str(Frequency) , 'Hz, Amplitude = ', num2str(Amplitude) ', Phase = ', num2str(Phase) ')']);
