%% Parameters
clear; clc; close all;
filename = 'data.csv';
Ts = 0.01;           % 10 ms sampling period
Fs = 1 / Ts;         % Sampling frequency = 100 Hz



%% Read semicolon-delimited CSV
opts = detectImportOptions(filename, 'Delimiter', ';');

% Keep only the first three columns
opts.SelectedVariableNames = opts.VariableNames(1:3);
T = readtable(filename, opts);

% Extract and scale signals
pulse       = T{:,1} .* 5.0 ./ 1023;
butterworth = T{:,2} .* 5.0 ./ 1023;
filter      = T{:,3} .* 5.0 ./ 1023;

% Time vector
N = height(T);                % number of samples
t = (0:N-1)' * Ts;            % time vector in seconds

%% Time-domain plot
figure;
t1 = tiledlayout(3,1);
nexttile;
plot(t, pulse);
xlabel('Time (s)');
ylabel('Value (V)');
title('Pulse Train Output');
grid on;
set(gca,'FontSize',15);

nexttile;
plot(t, butterworth);
xlabel('Time (s)');
ylabel('Value (V)');
title('Butterworth Filter Output');
grid on
set(gca,'FontSize',15);

nexttile;
plot(t, filter);
xlabel('Time (s)');
ylabel('Value (V)');
title('Filtered Data');
grid on;
set(gca,'FontSize',15);
% set(gca, 'YTick', linspace(-2, 2, 5));

t1.Padding = 'compact';
t1.TileSpacing = 'compact';

%% FFT computation
N  = length(pulse);      % ensure N is defined
Xp = fft(pulse);
Xb = fft(butterworth);
Xf = fft(filter);

% Double-sided frequency vector: -Fs/2 ... Fs/2 - Fs/N
f = (-N/2 : N/2-1) * (Fs / N);

% Shift zero frequency to center
Xp_shift = fftshift(Xp);
Xb_shift = fftshift(Xb);
Xf_shift = fftshift(Xf);

% Double-sided amplitude spectra (no factor 2)
Ap = abs(Xp_shift) / N;
Ab = abs(Xb_shift) / N;
Af = abs(Xf_shift) / N;

%% Frequency-domain plots (double-sided)
figure;
t2 = tiledlayout(3,1);

nexttile
plot(f, Ap);
xlabel('Frequency (Hz)');
ylabel('|X_{pulse}(f)|');
title('Pulse - Double-Sided Amplitude Spectrum');
grid on;
set(gca,'FontSize',15);

nexttile
plot(f, Ab);
xlabel('Frequency (Hz)');
ylabel('|X_{butter}(f)|');
title('Butterworth Output - Double-Sided Amplitude Spectrum');
grid on;
set(gca,'FontSize',15);

nexttile
plot(f, Af);
xlabel('Frequency (Hz)');
ylabel('|X_{filter}(f)|');
title('Filtered Data - Double-Sided Amplitude Spectrum');
grid on;
set(gca,'FontSize',15);

t2.Padding = 'compact';
t2.TileSpacing = 'compact';
