load HW9.mat;
%% 1) Find the amplitude A and mean value 𝑎0 of the sampled pulse train data. Estimate the
% period of the signal T0 (in CT) by inspecting the time domain samples. Note that this is a
% rough estimate, since the true period may not be an integer multiple of the sampling rate.

A = max(x) - min(x); % find amplitude
a0 = mean(x); % find mean

Ts = 0.01;           % sampling period (s)
N = 100;             % number of samples to plot

t = (0:N-1) * Ts;    % time vector of length N

% Plot to determine T0
figure;
plot(t, x(1:N), 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('x[n]');
title('First 200 Samples of x');
grid on;

%% 2) Choose a section of 1000 consecutive data points in the time domain for the fft analysis.
% For simplicity, you can use fdomain.m provided, i.e. [X,f]=fdomain(x,Fs)and plot magnitude
% |𝑋| vs. f in Hz. Also include a plot of |X| vs. k (-500 to 499), the DFT index
N1 = 200;
N2 = N1 + 999;
x_selected = x(N1:N2);
[X,f] = fdomain(x_selected,1./Ts);
figure;
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