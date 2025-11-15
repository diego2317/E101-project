load HW9.mat;
%% 1) Find the amplitude A and mean value 𝑎0 of the sampled pulse train 
% data. Estimate the period of the signal T0 (in CT) by inspecting the 
% time domain samples. Note that this is a rough estimate, since the true 
% period may not be an integer multiple of the sampling rate.

A = max(x) - min(x); % find amplitude
a0 = mean(x); % find mean

Ts = 0.01;           % sampling period (s)
Fs = 1/Ts;
% Result: estimate is 9-10 samples, so 90-100 ms

%% 2) Choose a section of 1000 consecutive data points in the time domain 
% for the fft analysis. For simplicity, you can use fdomain.m provided, 
% i.e. [X,f]=fdomain(x,Fs)and plot magnitude |𝑋| vs. f in Hz. Also include
% a plot of |X| vs. k (-500 to 499), the DFT index
N1 = 1;
N2 = N1 + 999;
x_selected = x(N1:N2);
[X,f] = fdomain(x_selected,1./Ts);
figure('Name','Sampled Data Plots');
subplot(2,1,1);
plot(f, abs(X));
xlabel('Frequency (Hz)');
ylabel('|X|');
title('Plot of |X| vs frequency for samples 200:1200');
fontsize(16,"points")
subplot(2,1,2);
k = -500:499;
plot(k, abs(X));
xlabel('DFT Index K');
ylabel('|X|');
title('Plot of |X| vs k');
fontsize(16,'points');

%% 3) Determine the fundamental frequency 𝑓0 of the pulse train from the 
% spectrum graph in step 2. Determine the fundamental period T0 from 𝑓0. Is 
% this result close to the result in step 1? Explain why these may be 
% different, and which should be trusted more.

% By visual inspection, the fundamental frequency f0 is 10.7 Hz
% Then T0 = 1/f0
f0 = 10.7; % Hz
T0 = 1/f0; % s

% We can probably trust this more, because the time-domain data has
% alternating fundamental periods, which means Ts might not have been low
% enough. So, the fundamental period we get from inspection of the data
% might be inaccurate. 

%% 4) Apply a 1000-point Hanning window to the sampled signal and determine
% the spectrum 𝑋ℎ𝑎𝑛𝑛of the windowed signal. Plot the magnitude |𝑋ℎ𝑎𝑛𝑛| of 
% the spectrum vs. f in Hz, and also plot |𝑋ℎ𝑎𝑛𝑛| vs. k (-500 to 499)

% Create the Hanning window
w = hann(1000);

% Apply hanning window to data
x_hann = w .* x_selected;
% FFT that shit
[X_hann, f] = fdomain(x_hann, Fs);
figure('Name','Hanning Window Plots');
subplot(2,1,1);
hold on
%plot(f, abs(X), 'r', 'LineWidth',1);
plot(f, abs(X_hann), 'b');
xlabel('Frequency (Hz)');
ylabel('|X_{hann}|');
title('Plot of |X_{hann}| vs frequency');
%legend('Selected Data','Windowed Data','Location','best')
fontsize(16,"points")

subplot(2,1,2);
hold on
%plot(k, abs(X), 'r', 'LineWidth',1.5);
plot(k, abs(X_hann), 'b');
xlabel('DFT Index K');
ylabel('|X_{hann}|');
title('Plot of |X_{hann}| vs k');
%legend('Selected Data','Windowed Data','Location','best')
fontsize(16,'points');

%% 5) Calculate the Discrete Time Fourier Series (DTFS) coefficients for 
% one period of the sample data.
% Will use the first period
period = x(1:9);

% Formula: |a_k| = | (A * sin(k * pi * d)) ./ (N_0 * sin(k * pi / N0))|
% d = N1/N0 = a0/A
% N1 = T1/10ms
% N0 = T0/10ms
N1 = 5;
N0 = 4;
d = N1./N0;

a = @(k) abs((A * sin(k * pi * d)) ./ (N_0 * sin(k * pi / N0)));
a_11 = a(1);
a_21 = a(2);
a_31 = a(3);
a_41 = a(4);

% calculate the magnitude of the first 4 DTFS coefficients when estimated
% off the entire data stream
d = a0/A;
% calculate N0 by dividing total data length by number of 0->A transitions
differences = diff(x);
changes = sum((differences >= 4.9));
N0 = length(x)./changes;
a = @(k) abs((A * sin(k * pi * d)) ./ (N_0 * sin(k * pi / N0)));

a_12 = a(1);
a_22 = a(2);
a_32 = a(3);
a_42 = a(4);