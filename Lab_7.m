%% Section-1: Return a list of available SDR devices
sdr_list = sdrdev;
%% Section-2: Create a radio object for the ADALM-PLUTO radio
dev = sdrdev(sdr_list{1});
%% Section-3: Configure ADALM-PLUTO radio
is_chip_AD9364 = configurePlutoRadio("AD9364");

if ~is_chip_AD9364
    fprintf(['Device could not be configured.\n', ...
        'Not using the extended LO tuning range, and the bandwidth.\n']);
else
    fprintf('Device has been successfully configured.\n');
end
%% Section-4: Declare and initialize the center frequency and 
% baseband sampling rate
fc = 90.9e6; % center frequency, (unit: Hz)
bb_Fs = 20*48e3; % baseband sampling rate, (unit: Hz)
%% Section-5: Create FM Broadcast Demodulator system object
fmDemod = comm.FMBroadcastDemodulator(SampleRate=bb_Fs, ...
    AudioSampleRate=48e3, ...
    PlaySound=true);

% Get the AudioDecimationFactor of the FM Broadcast Demodulator system
% object
fmDemod_info = info(fmDemod);
audioDecimationFactor = fmDemod_info.AudioDecimationFactor;
%% Section-6: Declare and initialize the number of samples per frame
samples_per_frame = 200*audioDecimationFactor;
%% Section-7: Create receiver system object
rxPluto = sdrrx(sdr_list{1}, ...
    RadioID=dev.RadioID, ...
    CenterFrequency=fc, ...
    GainSource='AGC Slow Attack', ...
    BasebandSampleRate=bb_Fs, ...
    SamplesPerFrame=samples_per_frame, ...
    OutputDataType='double');

% designCustomFilter(rxPluto); % This is used to control the RF bandwidth
                             % that we receive by controlling the design
                             % of the lowpass filters in the receive chain
%% Section-8: Create spectrum analyzer system object
scope = spectrumAnalyzer(SpectrumType='power', ...
    ViewType='spectrum-and-spectrogram', ...
    SampleRate=bb_Fs, ...
    PlotAsTwoSidedSpectrum=true, ...
    FrequencyOffset=fc, ...
    AveragingMethod="exponential", ...
    ForgettingFactor=0.9);
%% Section-9: Main loop to receive and display data
disp('Receiving and analyzing data...');
while true
    % Receive baseband samples
    receivedData = rxPluto();

    % Send data to spectrum analyzer
    scope(receivedData);

    % Demodulate and play signal
    demodData = fmDemod(receivedData);

end
%% Section-10: Release the system objects
release(rxPluto);
release(scope);