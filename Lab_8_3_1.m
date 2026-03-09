%% Section-1: Declare and initialize the required variables
fc= 500e3; % carrier signal frequency (unit: Hz)
Ac = 1; % carrier signal amplitude (unit: V)
overSampRate = 20; % unitless
Fs = overSampRate * fc; % sampling frequency (unit: Hz)
%% Section-2: Generate a multi-tone message (modulating) signal
fm = 1000; % message signal frequency (unit: Hz)
nCycle = 5; % number of periods of message signal
t = 0:1/Fs:nCycle/fm; % time vector (unit: second)
%t = 0:0.001:1;
Am = 3; % message signal amplitude (unit: V)

% Approximate a square wave using the first seven Fourier series
% components. This will be our message signal.
m = 0; % message signal
for n = 1:2:13
    m = m + (1/n)*sin(2*pi*n*fm*t);
end

m = (4*Am/pi)*m;

%% Section-3: Generate the carrier signal
c = Ac*cos(2*pi*fc*t); % carrier signal
%% Section-4: Apply DSB-LC amplitude modulation
mod_indx = 0.8; % modulation index, unitless, 0 < mod_indx <= 1,
                % specifies % of modulation to be applied
                % 0 = 0%, 1 = 100% modulation.

% Apply min-max scaling to the message signal
% such that its maximum amplitude is 1 and minimum is -1
% to prevent overmodulation.
m_n = (m - min(m)) / (max(m) - min(m)) * 2 - 1; % Min-max scaling to range [-1, 1]


s = (1 + mod_indx*m_n) .* c; % DSB-LC amplitude modulated signal
%% Section-5: Plot m, c, m_n, and s in time-domain
% Pay attention to the limits of the time axis
% Remember to properly label all the axes
figure
plot(t, m, LineWidth=1.5);
xlabel('t (s)'); ylabel('Amplitude (V)');
title('Message signal amplitude vs. time');
grid on


figure
plot(t, m_n, LineWidth=1.5);
xlabel('t (s)'); ylabel('Amplitude (V)');
title('Scaled message signal amplitude vs. time');
grid on


figure
plot(t, c, LineWidth=1.5);
xlim([0 10/fc]);
xlabel('t (s)'); ylabel('Amplitude (V)');
title('Carrier signal amplitude vs. time');
grid on


figure
plot(t, s, LineWidth=1.5);
xlabel('t (s)'); ylabel('Amplitude (V)');
title('DSB-LC amplitude modulated signal amplitude vs. time');
grid on

%% Section-6: Frequency domain analysis of message signal and 
% DSB-LC AM signal

[freq_vect_m, mag_vect_m] = fftWrapper(m, Fs); % FFT for message signal
[freq_vect_s, mag_vect_s] = fftWrapper(s, Fs); % FFT for DSB-LC AM signal

% Plot the magnitude spectrum of m
figure
stem(freq_vect_m, mag_vect_m);
xlabel('f (Hz)'); ylabel('Magnitude (V)');
title('Magnitude spectrum of the message signal');
grid on

% Plot the magnitude spectrum of s
figure
stem(freq_vect_s, mag_vect_s);
xlabel('f (Hz)'); ylabel('Magnitude (V)');
title('Magnitude spectrum of the DSB-LC amplitude modulated signal');
grid on
%% Section-7: Demodulate the signal
s_demod = s .* c; % demodulated signal at baseband
s_baseband = lowpass(s_demod, 10e3, Fs); % filtered signal
s_baseband = s_baseband - sum(s_baseband)/(length(s_baseband)); % remove
                                                                % the DC
                                                                % bias
% Amplify the baseband signal
gain = 2;
s_baseband = s_baseband*gain;

% Plot the demodulated signal on top of the original signal in time domain
figure
plot(t, m, LineWidth=1.5);
hold on
plot(t, s_baseband, LineWidth=1.5);
hold off
grid on
legend('Original signal', 'Demodulated signal')
%% Section-8: Frequency domain analysis of demodulated signal
[freq_vect_s_baseband, mag_vect_s_baseband] = fftWrapper(s_baseband,Fs );

% Plot the magnitude spectrum of s_baseband
figure
stem(freq_vect_s_baseband, mag_vect_s_baseband);
xlabel('f (Hz)'); ylabel('Magnitude (V)');
title('Magnitude spectrum of the demodulated signal');
grid on