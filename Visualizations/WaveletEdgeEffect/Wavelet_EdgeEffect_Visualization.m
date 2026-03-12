%% Wavelet/Sliding Window Edge Effect Visualization
% This script demonstrates why time-frequency analysis results in
% temporally shorter output data. When using a sliding window, the first 
% and last portions of the data cannot be fully analyzed because the 
% window would extend beyond the data boundaries.

clc
clear
close all

%% Parameters - ADJUST THESE TO EXPLORE
window_width_ms = 500;       % Window width [ms] - try different values!
step_size_ms = 50;           % Step size between windows [ms] - small for smooth animation

fs = 500;                    % Sampling rate [Hz]
duration = 2;                % Signal duration [s]

% Video settings
video_filename = 'Wavelet_EdgeEffect.mp4';
target_fps = 30;             % Frames per second

% Convert to samples
window_width = window_width_ms / 1000 * fs;
step_size = step_size_ms / 1000 * fs;
half_window = window_width / 2;

%% Generate signal
t = 0:1/fs:duration-1/fs;
n_samples = length(t);

% Alpha oscillation with amplitude modulation
signal = sin(2*pi*10*t) .* (0.5 + 0.5*sin(2*pi*0.5*t)) + 0.1*randn(size(t));

%% Calculate valid output range
first_valid_sample = half_window;
last_valid_sample = n_samples - half_window;
first_valid_time = first_valid_sample / fs;
last_valid_time = last_valid_sample / fs;

% Window center positions
center_positions = first_valid_sample:step_size:last_valid_sample;
n_windows = length(center_positions);

fprintf('Window: %d ms  |  Output: %.0f ms of %.0f ms (%.0f%% kept)\n', ...
    window_width_ms, (last_valid_time-first_valid_time)*1000, duration*1000, ...
    (last_valid_time-first_valid_time)/duration*100);
fprintf('Video: %d frames @ %d fps = ~%.0f s\n', n_windows, target_fps, n_windows / target_fps);

%% Helper function: create curly brace curve
% Creates a brace from (x1,y1) to (x2,y2) with tip at (xm,ym)
function [bx, by] = curly_brace(x1, y1, x2, y2, xm, ym, n_points)
    if nargin < 7, n_points = 50; end
    
    % Left arm: from (x1,y1) to (xm,ym)
    t_left = linspace(0, 1, n_points)';
    % Quadratic bezier with control point for nice curve
    cx1 = x1 + 0.3*(xm - x1);  % control point x
    cy1 = y1 + 0.7*(ym - y1);  % control point y
    bx_left = (1-t_left).^2 * x1 + 2*(1-t_left).*t_left * cx1 + t_left.^2 * xm;
    by_left = (1-t_left).^2 * y1 + 2*(1-t_left).*t_left * cy1 + t_left.^2 * ym;
    
    % Right arm: from (xm,ym) to (x2,y2)
    t_right = linspace(0, 1, n_points)';
    cx2 = xm + 0.7*(x2 - xm);  % control point x
    cy2 = ym + 0.3*(y2 - ym);  % control point y
    bx_right = (1-t_right).^2 * xm + 2*(1-t_right).*t_right * cx2 + t_right.^2 * x2;
    by_right = (1-t_right).^2 * ym + 2*(1-t_right).*t_right * cy2 + t_right.^2 * y2;
    
    % Combine (skip duplicate middle point)
    bx = [bx_left; bx_right(2:end)];
    by = [by_left; by_right(2:end)];
end

%% Create figure
fig = figure('Color', 'w', 'Position', [100 100 1200 700]);

%% TOP: Input signal with sliding window
ax1 = subplot(2, 1, 1);
hold on

% Plot signal in black
plot(t, signal, 'k', 'LineWidth', 1.5)

% Add vertical line at t=0
xline(0, '--', 'LineWidth', 1.5)

% Initialize window rectangle (light blue, transparent)
h_window = fill([0 0 0 0], [-2 2 2 -2], [0.3 0.6 1], ...
    'FaceAlpha', 0.3, 'EdgeColor', [0 0.4 0.8], 'LineWidth', 2);

% Center marker (red dot)
h_center = plot(0, 0, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');

xlabel('Time [s]', 'FontSize', 14)
ylabel('Amplitude', 'FontSize', 14)
title('Input Signal with Sliding Analysis Window', 'FontSize', 16)
ylim([-2 2])
xlim([0 duration])
hold off

%% BOTTOM: Output time series (shorter!)
ax2 = subplot(2, 1, 2);
hold on

% Shade the "missing" regions in light red
fill([0 first_valid_time first_valid_time 0], [-1 -1 1 1], ...
    [1 0.7 0.7], 'EdgeColor', 'none')
fill([last_valid_time duration duration last_valid_time], [-1 -1 1 1], ...
    [1 0.7 0.7], 'EdgeColor', 'none')

% Add vertical line at t=0
xline(0, '--', 'LineWidth', 1.5)

% Output signal line (builds up during animation)
h_output = plot(nan, nan, 'k', 'LineWidth', 1.5);

% Current output point marker
h_output_dot = plot(nan, nan, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');

% Curly brace (initially hidden)
h_brace = plot(nan, nan, 'r-', 'LineWidth', 2.5, 'Visible', 'off');

xlabel('Time [s]', 'FontSize', 14)
ylabel('Amplitude', 'FontSize', 14)
title(sprintf('Output Time Series (shortened by %d ms at each edge)', window_width_ms/2), 'FontSize', 16)
ylim([-1 1])
xlim([0 duration])

% Labels for missing regions
text(first_valid_time/2, 0.75, 'No data', 'HorizontalAlignment', 'center', ...
    'FontSize', 12, 'Color', [0.7 0 0], 'FontWeight', 'bold')
text((last_valid_time + duration)/2, 0.75, 'No data', 'HorizontalAlignment', 'center', ...
    'FontSize', 12, 'Color', [0.7 0 0], 'FontWeight', 'bold')

hold off

%% Storage for output
output_times = [];
output_values = [];

%% Setup video writer
vw = VideoWriter(video_filename, 'MPEG-4');
vw.FrameRate = target_fps;
open(vw);

disp('Creating video...')

%% INTRO: Show first window with curly brace (pause for 3 seconds)
center_sample = center_positions(1);
center_time = center_sample / fs;
window_start = (center_sample - half_window) / fs;
window_end = (center_sample + half_window) / fs;
center_value = signal(round(center_sample));

% Set up first position
set(h_window, 'XData', [window_start window_start window_end window_end]);
set(h_center, 'XData', center_time, 'YData', center_value);
set(h_output_dot, 'XData', center_time, 'YData', center_value);

% Create and show curly brace
[bx, by] = curly_brace(window_start, 1, window_end, 1, center_time, center_value, 50);
set(h_brace, 'XData', bx, 'YData', by, 'Visible', 'on');

drawnow

% Write intro frames (3 seconds)
frame = getframe(fig);
for f = 1:(3 * target_fps)
    writeVideo(vw, frame);
end
disp('Intro done (3s pause)')

% Hide brace for main animation
set(h_brace, 'Visible', 'off');

%% MAIN ANIMATION
for i = 1:n_windows
    % Current window position
    center_sample = center_positions(i);
    center_time = center_sample / fs;
    window_start = (center_sample - half_window) / fs;
    window_end = (center_sample + half_window) / fs;
    
    % Signal value at center
    center_value = signal(round(center_sample));
    
    % Store output
    output_times(end+1) = center_time;
    output_values(end+1) = center_value;
    
    % Update window rectangle
    set(h_window, 'XData', [window_start window_start window_end window_end]);
    
    % Update center dot in top plot
    set(h_center, 'XData', center_time, 'YData', center_value);
    
    % Update output line and dot in bottom plot
    set(h_output, 'XData', output_times, 'YData', output_values);
    set(h_output_dot, 'XData', center_time, 'YData', center_value);
    
    drawnow
    
    % Write frame
    frame = getframe(fig);
    writeVideo(vw, frame);
    
    % Progress indicator
    if mod(i, 50) == 0
        fprintf('Frame %d/%d\n', i, n_windows);
    end
end

%% OUTRO: Show last window with curly brace (pause for 3 seconds)
% Update and show curly brace at final position
[bx, by] = curly_brace(window_start, 1, window_end, 1, center_time, center_value, 50);
set(h_brace, 'XData', bx, 'YData', by, 'Visible', 'on');

% Update final title
title(ax2, sprintf('Output: %.0f ms  (Input was %.0f ms, lost %.0f ms total)', ...
    (last_valid_time-first_valid_time)*1000, duration*1000, window_width_ms), 'FontSize', 16)

drawnow

% Write outro frames (3 seconds)
frame = getframe(fig);
for f = 1:(3 * target_fps)
    writeVideo(vw, frame);
end
disp('Outro done (3s pause)')

%% Close video
close(vw);

fprintf('\nDone! Video saved to: %s\n', video_filename);
fprintf('Key insight: %d ms window = %d ms cut from start + %d ms cut from end\n', ...
    window_width_ms, window_width_ms/2, window_width_ms/2);
