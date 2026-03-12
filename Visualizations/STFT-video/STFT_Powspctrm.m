%% STFT → TFR build-up video with live power spectrum (top) + 3D TFR (bottom)

%% IDEAS
% make powscptrm narrower so it resembles the form the students know already
% do it once with 2D powscptrm only showing time and freq and then as actual 3 D plot
% make the simulated bursts more easily understandable (alpha increase andsome beta or something like that)

%%

clear; clc; close all;

%% 0) Parameters (tweak as you like)
fs       = 500;          % sampling rate [Hz]
dur      = 10.0;         % duration [s]
nperseg  = 512;          % STFT window length (samples)
overlap  = 384;          % STFT overlap (samples)
maxFreq  = 80;           % show up to this frequency [Hz]
outFile  = 'stft_tfr_build_dual.mp4';   % output video path
saveGIF  = false;        % set true to also export animated GIF

% Video duration control (the script will aim for ~targetDuration seconds)
targetDuration = 12;     % seconds (aim)
minDuration    = 10;     % seconds (lower bound)
maxDuration    = 15;     % seconds (upper bound)
minFPS         = 10;     % practical lower fps for smooth playback
maxFPS         = 60;     % practical upper fps for common players

%% 1A) Synthetic EEG-like signal with frequency bursts
t = (0:1/fs:dur-1/fs)';
burst = @(f, t0, t1, ph) ...
    ( (t>=t0) & (t<t1) ) .* 0.5 .* (1 - cos(2*pi*(t - t0)/(t1 - t0))) .* sin(2*pi*f*t + ph);
x = 0.7*burst(8,  1.0, 3.0, 0)   + ...
    0.6*burst(20, 3.0, 5.0, 0.3) + ...
    0.5*burst(40, 5.0, 7.0, 1.2) + ...
    0.4*burst(30, 7.0, 9.5, 0.6) + ...
    0.05*randn(size(t));  %#ok<RAND>

%% 2) Short-Time Fourier Transform
win = hann(nperseg, 'periodic');
[S, F, T] = spectrogram(x, win, overlap, nperseg, fs);  % S: freq x time (complex)

% Power in dB
P   = abs(S).^2;
Pdb = 10*log10(P + 1e-12);

% Restrict to plotting band
idxF = F <= maxFreq;
F    = F(idxF);
Pdb  = Pdb(idxF, :);

% Meshgrid for surf
[TT, FF] = meshgrid(T, F);

% Fixed colour scaling (percentiles to avoid outliers)
pLo  = 5; 
pHi  = 99.5;
zmin = prctile(Pdb(:), pLo);
zmax = prctile(Pdb(:), pHi);

% Number of time slices
nSlices = size(Pdb, 2);

%% 3) Figure & axes initialisation (top: power spectrum; bottom: 3D TFR)
fig = figure('Color','w','Position',[100 100 2000 1200]);

% Use a tiled layout to keep things tidy
tl = tiledlayout(fig, 2, 1, 'TileSpacing','compact', 'Padding','compact');

% -- Top: current power spectrum
axPS = nexttile(tl, 1);
hold(axPS, 'on');
psLine = plot(axPS, F, Pdb(:,1), 'LineWidth', 2);
xlabel(axPS, 'Frequency [Hz]');
ylabel(axPS, 'Power [dB]');
title(axPS, 'Current Power Spectrum (per STFT slice)');
xlim(axPS, [F(1) F(end)]);
ylim(axPS, [zmin zmax]);
grid(axPS, 'on');
set(axPS, 'FontSize', 18);

% -- Bottom: 3D TFR being built slice by slice
ax3 = nexttile(tl, 2);
colormap(ax3, turbo);           % built-in; vivid and perceptually ordered
shading(ax3, 'interp');

Z = nan(size(Pdb));             % start hidden; reveal one column per frame
Z(:,1) = Pdb(:,1);

hs = surf(ax3, TT, FF, Z, 'EdgeColor','none');
caxis(ax3, [zmin zmax]);
cb = colorbar(ax3);
ylabel(cb, 'Power [dB]');

xlabel(ax3, 'Time [s]'); ylabel(ax3, 'Frequency [Hz]'); zlabel(ax3, 'Power [dB]');
title(ax3, 'STFT \rightarrow TFR (building one slice per segment)');
xlim(ax3, [T(1) T(end)]);
ylim(ax3, [F(1) F(end)]);
zlim(ax3, [zmin zmax]);
view(ax3, [-30 45]);
grid(ax3, 'on');
set(ax3, 'FontSize', 18);

drawnow;

%% 4) Video writer with adaptive duration control (aim ~10–15 s)
% First compute an "ideal" fps based on target duration, then clamp.
rawFPS = nSlices / targetDuration;
if rawFPS >= minFPS && rawFPS <= maxFPS
    fps = round(rawFPS);
    repEachSlice = 1;             % no repetition needed
    step = 1;                     % use all slices
elseif rawFPS < minFPS
    % Too few slices for the target duration → keep fps reasonable and repeat frames
    fps = minFPS;
    % Ensure at least minDuration by repeating each slice as needed
    repEachSlice = ceil(minDuration * fps / nSlices);
    step = 1;
else % rawFPS > maxFPS
    % Too many slices for the target duration → raise fps to max and skip slices
    fps = maxFPS;
    % Choose a step so total duration does not exceed maxDuration
    step = max(1, ceil(nSlices / (maxDuration * fps)));
    repEachSlice = 1;
end

% Reported duration (approx.)
approxFrames = repEachSlice * numel(1:step:nSlices);
approxDuration = approxFrames / fps;
disp(sprintf('Video settings: fps = %d, repeat = %d, step = %d, ~%.1f s total.', ...
    fps, repEachSlice, step, approxDuration));

vw = VideoWriter(outFile, 'MPEG-4');
vw.FrameRate = fps;
open(vw);

% Optional GIF
if saveGIF
    gifFile = [outFile(1:end-4) '.gif'];
end

set(fig, 'Renderer', 'opengl');  % better for smooth surf animation

%% 5) Animate: add one time-slice per frame + update top spectrum
for k = 1:step:nSlices
    % Reveal current slice in the 3D TFR
    Z(:,k) = Pdb(:,k);
    set(hs, 'ZData', Z, 'CData', Z);
    
    % Update the power spectrum line (top)
    set(psLine, 'XData', F, 'YData', Pdb(:,k));
    title(axPS, sprintf('Current Power Spectrum (slice %d/%d, t=%.2f s)', k, nSlices, T(k)));
    
    % Keep axes/limits stable
    xlim(ax3, [T(1) T(end)]); ylim(ax3, [F(1) F(end)]); zlim(ax3, [zmin zmax]); caxis(ax3, [zmin zmax]);
    xlim(axPS, [F(1) F(end)]); ylim(axPS, [zmin zmax]);
    
    drawnow;
    
    % Write one or more frames (repeat to stretch duration when needed)
    frameRGB = getframe(fig);
    for r = 1:repEachSlice
        writeVideo(vw, frameRGB);
        
        if saveGIF
            [A,map] = rgb2ind(frameRGB.cdata, 256, 'nodither');
            if k == 1 && r == 1
                imwrite(A, map, gifFile, 'gif', 'LoopCount', Inf, 'DelayTime', 1/vw.FrameRate);
            else
                imwrite(A, map, gifFile, 'gif', 'WriteMode', 'append', 'DelayTime', 1/vw.FrameRate);
            end
        end
    end
end

close(vw);
disp(['Saved video to: ' outFile]);
if saveGIF
    disp(['Saved GIF to:   ' gifFile]);
end

