function [freqShifted, sgnFFT_shifted] = fftWrapper(signal, Fs)
% We will use Fourier Transform multiple times.
% Thus, writing a function is more concise and convenient.
% =========================================================================
% Length of the signal
% Note: sgn is short for signal not the signum function.
sgnLen = length(signal);
% =========================================================================
% Fourier transform of the signal
sgnFFT = fft(signal);
sgnFFT = abs(sgnFFT/sgnLen);
sgnFFT_shifted = fftshift(sgnFFT);
freqShifted = (-sgnLen/2:sgnLen/2-1) * (Fs/sgnLen);
end

% NOTE:
% The result of fft(signal) operation is a complex-valued signal.
% We take absolute value of that result by using abs() to obtain
% the magnitude.