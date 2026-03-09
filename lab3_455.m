%lab 3

D = 1600;       % total distance between the two stations
n = 4;          % path loss exponent
stdev = 6;      % standard deviation in dB
d0 = 1;         % close in distance
pr_d0 = 0;      % receiver power
pr_min = -118;  % min usable signal
pr_ho = -112;   % handoff threshold

% Create array of distances from station 1
d1_array = 10:1:1590;  % distances from 1m to 1599m (NOT 1600!)
d2_array = D - d1_array;  % corresponding distances from station 2 (1599m to 1m)

% Calculate mean received power for each distance
mean_pr_d1 = pr_d0 - 10*n*log10(d1_array/d0);
mean_pr_d2 = pr_d0 - 10*n*log10(d2_array/d0);

% Calculate probabilities
prob_pr_d1 = 1 - qfunc((pr_ho - mean_pr_d1) / stdev);  % P(Pr1 > pr_ho)
prob_pr_d2 = 1 - qfunc((pr_min - mean_pr_d2) / stdev);  % P(Pr2 > pr_min)
prob_both = prob_pr_d1 .* prob_pr_d2;  % combined prob

% Find d_ho for 95 percent handoff probability
t_prob = 0.95;
[~, idx] = min(abs(prob_both - t_prob));
d_ho = d1_array(idx); % issues incountedred with trying to use interp1 

fprintf('Distance for 95%% handoff probability: d_HO = %.2f meters\n', d_ho);


% Plot 1 (parts a-c) but with the ref line 

figure;
hold on;
plot(d1_array, prob_pr_d1, 'r-', 'LineWidth', 2, 'DisplayName', 'P(Pr_1 > pr_{ho})');
plot(d1_array, prob_pr_d2, 'b-', 'LineWidth', 2, 'DisplayName', 'P(Pr_2 > pr_{min})');
plot(d1_array, prob_both, 'g-', 'LineWidth', 2, 'DisplayName', 'P(both)');

% Add reference line at 95%
yline(0.95, '--k', 'P = 0.95', 'LineWidth', 1.5);

xlabel('Distance from Station 1 (m)');
ylabel('Probability');
title('Probability of Received Power vs Distance');
legend show;
grid on;
hold off;

% Use Data Cursor or ginput to read the value
fprintf('Use the data cursor (click on graph toolbar) to find where green line crosses P=0.95\n');