%% STFT → TFR build-up video (surf)
% Creates a video showing each STFT segment adding one time-slice to a 3D TFR.
% Save this as stft_tfr_build.m and run.
% You can replace the synthetic signal with your own data (see Section 1B).

clear; clc; close all;

%% 0) Parameters
fs       = 500;        % sampling rate [Hz]
dur      = 10.0;       % duration [s]
nperseg  = 512;        % STFT window length (samples)
overlap  = 384;        % STFT overlap (samples)
maxFreq  = 80;         % show up to this frequency in the plot
fps      = 50;         % video frame rate
outFile  = 'stft_tfr_build.mp4';  % output video path
saveGIF  = false;      % set true to also export animated GIF

%% 1A) Synthetic EEG-like signal with frequency bursts
t = (0:1/fs:dur-1/fs)';
burst = @(f, t0, t1, ph) ...
    ( (t>=t0) & (t<t1) ) .* 0.5 .* (1 - cos(2*pi*(t - t0)/(t1 - t0))) .* sin(2*pi*f*t + ph);
x = 0.7*burst(8, 1.0, 3.0, 0) + ...
    0.6*burst(20,3.0, 5.0, 0.3) + ...
    0.5*burst(40,5.0, 7.0, 1.2) + ...
    0.4*burst(30,7.0, 9.5,0.6) + ...
    0.05*randn(size(t));  %#ok<RAND>

%% 1B) Use your own data (OPTIONAL)
% If you have your own vector x and sampling rate fs, comment out Section 1A above
% and set:
% x  = your_vector(:);
% fs = your_sampling_rate;

%% 2) Short-Time Fourier Transform
win = hann(nperseg, 'periodic');
[S, F, T] = spectrogram(x, win, overlap, nperseg, fs);  % S: freq x time (complex)

% Power in dB
P = abs(S).^2;
Pdb = 10*log10(P + 1e-12);

% Restrict to plotting band
idxF = F <= maxFreq;
F = F(idxF);
Pdb = Pdb(idxF, :);

% Meshgrid for surf
[TT, FF] = meshgrid(T, F);

% Fixed colour scaling (percentiles to avoid outliers)
pLo = 5; pHi = 99.5;
zmin = prctile(Pdb(:), pLo);
zmax = prctile(Pdb(:), pHi);

%% 3) Figure/SURF initialisation
fig = figure('Color','w','Position',[100 100 2000 1200]);
ax  = axes(fig, 'Projection','perspective');
colormap(ax, jet);              % blue → red
shading(ax, 'interp');

% Start with only the first slice; fill future with NaNs
Z = nan(size(Pdb));
Z(:,1) = Pdb(:,1);

hs = surf(ax, TT, FF, Z, 'EdgeColor','none');  % SURF object
caxis(ax, [zmin zmax]);
color_map = flipud(cbrewer('div', 'RdBu', 64));
colormap(color_map);
cb = colorbar(ax); 
ylabel(cb, 'Power [dB]');

xlabel(ax, 'Time [s]'); ylabel(ax, 'Frequency [Hz]'); zlabel(ax, 'Power [dB]');
title(ax, 'STFT \rightarrow TFR (building one slice per segment)');
xlim(ax, [T(1) T(end)]); 
ylim(ax, [F(1) F(end)]); 
zlimval = max([abs(zmin) abs(zmax)]);
zlim(ax, [-zlimval zlimval]);
clim(ax, [-zlimval zlimval]);
view(ax, [ -30 45 ]);    % azimuth, elevation similar to MATLAB's default surf look
grid(ax, 'on');
set(gca, "FontSize", 30);

drawnow;

%% 4) Video writer
vw = VideoWriter(outFile, 'MPEG-4');
vw.FrameRate = fps;
open(vw);

% Optional GIF
if saveGIF
    gifFile = [outFile(1:end-4) '.gif'];
end

%% 5) Animate: add one time-slice per frame
for k = 1:size(Pdb, 2)
    % Update Z to reveal current slice
    Z(:,k) = Pdb(:,k);
    set(hs, 'ZData', Z, 'CData', Z);  % update surface without re-plotting
    
    % Keep axes/limits stable for consistent colouring and scaling
    xlim(ax, [T(1) T(end)]); ylim(ax, [F(1) F(end)]); zlim(ax, [zmin zmax]);
    caxis(ax, [zmin zmax]);
    drawnow;
    
    % Write video frame
    writeVideo(vw, getframe(fig));
    
    % (Optional) also append to GIF
    if saveGIF
        frameRGB = getframe(fig);
        [A,map] = rgb2ind(frameRGB.cdata, 256, 'nodither');
        if k == 1
            imwrite(A, map, gifFile, 'gif', 'LoopCount', Inf, 'DelayTime', 1/vw.FrameRate);
        else
            imwrite(A, map, gifFile, 'gif', 'WriteMode', 'append', 'DelayTime', 1/vw.FrameRate);
        end
    end
end

close(vw);
disp(['Saved video to: ' outFile]);
if saveGIF
    disp(['Saved GIF to:   ' gifFile]);
end
