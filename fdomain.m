function [X,f]=fdomain(x,Fs)
% FDOMAIN computes the Fourier coefficients from vector x
%         and the corresponding frequencies (two-sided)
% usage: [X,f]=fdomain(x,Fs)

N=length(x); % Total number of samples in the data sequence in x

if mod(N,2)==0
    k=-N/2:N/2-1; % N even
else
    k=-(N-1)/2:(N-1)/2; % N odd
end

T=N/Fs; %T: duration of the sequence in time (second), so 1/T is the frequency resolution df. For example if N=100, fs=50Hz, that means total data taken over T=2 second duration, and frequency resolution is df=1/T=0.5Hz.
f=k/T; %create a vector for two sided frequencies (for the given resolution) % This is the frequency range indexed properly. For example, if N=100, the index k=-50 to 49, and the frequency vector is from -25Hz to 24.5Hz.
X=fft(x)/N;
X=fftshift(X); %Rearranged, so now X output corresponds to the coefficients related to the corresponding frequency vector.

