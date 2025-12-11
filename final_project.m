%% Parameters
clear; clc; close all;
filename = 'comb_filter.csv';
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
subplot(3,1,1);
plot(t, pulse);
xlabel('Time (s)');
ylabel('Value (V)');
title('Pulse Train Output');
grid on;

subplot(3,1,2);
plot(t, butterworth);
xlabel('Time (s)');
ylabel('Value (V)');
title('Butterworth Filter Output');
grid on

subplot(3,1,3);
plot(t, filter);
xlabel('Time (s)');
ylabel('Value (V)');
title('Filtered Data');
grid on;

%% FFT computation
Xp = fft(pulse);
Xb = fft(butterworth);
Xf = fft(filter);

% Single-sided amplitude spectrum
f = (0:N-1) * (Fs / N);       % frequency vector (0 to Fs - Fs/N)
idx = 1:floor(N/2)+1;         % indices for 0..Fs/2

Ap = 2 * abs(Xp(idx)) / N;    % pulse amplitude spectrum
Ab = 2 * abs(Xb(idx)) / N;    % butterworth amplitude spectrum
Af = 2 * abs(Xf(idx)) / N;    % filter amplitude spectrum

f_half = f(idx);

%% Frequency-domain plots
figure;

subplot(3,1,1);
plot(f_half, Ap);
xlabel('Frequency (Hz)');
ylabel('|X_{pulse}(f)|');
title('Pulse - Single-Sided Amplitude Spectrum');
grid on;

subplot(3,1,2);
plot(f_half, Ab);
xlabel('Frequency (Hz)');
ylabel('|X_{butter}(f)|');
title('Butterworth Output - Single-Sided Amplitude Spectrum');
grid on;

subplot(3,1,3);
plot(f_half, Af);
xlabel('Frequency (Hz)');
ylabel('|X_{filter}(f)|');
title('Filtered Data - Single-Sided Amplitude Spectrum');
grid on;
