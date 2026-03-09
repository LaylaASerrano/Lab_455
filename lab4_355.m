%% ============================================================
%  ESET 455 – Lab 4
%  Lloyd's Mirror & Double Slit Interference
%  MATLAB Section
% =============================================================

clc; clear; close all;

%% ============================================================
%% PART I – Two-Ray Ground Reflection (Lloyd's Mirror)
%% ============================================================

% Given frequency
freq = 10.525e9;          % 10.525 GHz
c = 3e8;                  % speed of light
lambda = c/freq;          % theoretical wavelength

% Distance between TX and RX (replace if needed)
d = 0.52;                  % meters

% Reflector height range (1 cm to 20 cm)
h = 0.01:0.001:0.20;      % meters

% Path difference (ht = hr = h)
delta = sqrt((2*h).^2 + d^2) - d;

% Phase difference
phase_diff = (2*pi*delta) ./ lambda;

% Normalized total electric field
E_tot = abs(sin(phase_diff/2));

%% ---- Plot Calculated Field ----
figure;
plot(h*100, E_tot, 'LineWidth', 2);
xlabel('Reflector Height h (cm)');
ylabel('|E_{TOT}(h)| (Normalized)');
title('Two-Ray Ground Reflection Model');
grid on;
hold on;

% Find theoretical minima
[minVals, minLocs] = findpeaks(-E_tot,'MinPeakDistance',20);
minVals = -minVals;

plot(h(minLocs)*100, minVals, 'ro', 'MarkerFaceColor','r');

% Measured minima (from lab)
measured_min = [17 22];  % cm

% Plot measured minima on curve
plot(measured_min, interp1(h*100,E_tot,measured_min), ...
     'ks','MarkerFaceColor','k');

legend('Calculated Field','Calculated Minima','Measured Minima');

hold off;

%% ============================================================
%% PART II – Double Slit Interference
%% ============================================================

angle = 0:5:85;

meter = [1, 0.46, 0.3, 0.74, 0.95, 0.78, 0.39, 0, ...
         0.6, 0.68, 0, 0.45, 0.26, 0.18, 1, ...
         0.11, 0.1, 0.05];

%% ---- Plot Measured Data ----
figure;
plot(angle, meter, '-o','LineWidth',1.5);
grid on;
hold on;
xlabel('Angle (degrees)');
ylabel('Meter Reading');
title('Double Slit Interference Pattern');

% Find measured maxima and minima
[maxVals,maxLocs] = findpeaks(meter);
[minVals,minLocs] = findpeaks(-meter);
minVals = -minVals;

plot(angle(maxLocs),maxVals,'ro','MarkerFaceColor','r');
plot(angle(minLocs),minVals,'bo','MarkerFaceColor','b');

%% ---- Theoretical Intensity ----

theta = 0:1:85;
theta_rad = deg2rad(theta);

% Use theoretical wavelength again
lambda = 3e8/10.525e9;

% Replace these with your actual slit spacing values if known
d_slit = 0.05;     % slit separation (meters)
b_slit = 0.015;    % slit width (~1.5 cm)

eps_val = eps;

cos_term = cos(pi*d_slit*sin(theta_rad)/lambda).^2;

sinc_term = (sin(pi*b_slit*sin(theta_rad)/lambda + eps_val) ...
            ./ (pi*b_slit*sin(theta_rad)/lambda + eps_val)).^2;

I_theory = cos_term .* sinc_term;

% Normalize for comparison
I_theory = I_theory ./ max(I_theory);

plot(theta, I_theory, 'g','LineWidth',2);

legend('Measured','Maxima','Minima','Theoretical');

hold off;

