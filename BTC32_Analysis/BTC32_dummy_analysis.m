% Dummy MATLAB script - analysis of 32BTC Puzzle private keys
%
% Donations could be sent here: 1QKjnfVsTT1KXzHgAFUbTy3QbJ2Hgy96WU
% ( i am poor Ukrainian student that will really appreciate your 
% donates - have no home, living in the dorm and trying to cope 
% for the smallest flat in the city - with no success at the moment,
% nearly 10% of desired amount)

%% Clear all: command window, workspace, figures
clc;
clear all;
close all;

%% Load and prepare the data
    % Read the private keys from the file - stored as decimal prefix
    % (there are two columns: 1) is the wallet index (unknown bits amount),
    % 2) priv key non-zero part in decimal.
data = dlmread('btc32_keys_dec.csv');
    % Evaluate the "reminder" of the non-zero priv key part - each priv key
    % has a form of 2^(n-1) + <reminder> where n is an amount of unknown bits
    % and <reminder> is actually unknown its part that lies in interval 
    % 2^(n-1) -- 2^n
rem_2 = vpa( data(:,2) - 2.^(data(:,1)-1) );
    % Compute the relative position of the priv key inside the 
    % 2^n -- 2^(n+1) interval - "describe the Private Keys in
	% dimensionless form"
alpha = rem_2 ./ vpa( 2.^(data(:,1)) - 2.^(data(:,1)-1));

%% Plot raw numbers/ histograms / autocorrelation function

    % raw numbers
fig = figure();
plot(data(:,1), double(alpha), 'o');
hold on;
xlabel('index');
ylabel('Place within interval');
plot([63.5 63.5],[0 1],'--r', 'LineWidth',2);
ylim([0 1]);
saveas(fig, 'raw_alpha.png');
close(fig);

    % histograms
        % All known priv keys
fig = figure();
subplot(2,1,1);
hist(double(alpha),10);
title('Histogram for all keys');
xlim([0 1]);
subplot(2,1,2);
hist(double(alpha),40);
title('(smaller bars)');
xlim([0 1]);
saveas(fig, 'hist_all.png');
close(fig);

        % 1-63 keys 
fig = figure();
subplot(2,1,1);
hist(double(alpha(1:(end-11))),10);
title('Histogram for 1-63 keys');
xlim([0 1]);
subplot(2,1,2);
hist(double(alpha(1:(end-11))),40);
title('(smaller bars)');
xlim([0 1]);
saveas(fig, 'hist_1_63.png');
close(fig);

        % all upper 5th keys 
fig = figure();
subplot(2,1,1);
hist(double(alpha((end-10):end)),10);
title('Histogram for 5th keys');
xlim([0 1]);
subplot(2,1,2);
hist(double(alpha((end-10):end)),40);
title('(smaller bars)');
xlim([0 1]);
saveas(fig, 'hist_upper_5th.png');
close(fig);

        % look more closely
fig = figure();
hist(double(alpha),100);
title('Histogram all keys: tiny bins');
xlim([0 1]);
saveas(fig, 'hist_all_tiny_bins.png');
close(fig);

        % even more closely 
fig = figure();
hist(double(alpha),2000)
title('Histogram all keys: very tiny bins');
xlim([0 1]);
saveas(fig, 'hist_all_very_tiny_bins.png');
close(fig);

    % Autocorrelation
        % 1-63 keys 
fig = figure();
plot(xcorr(double(alpha(1:(end-11))) - mean(double(alpha(1:(end-11))))), '--o');
title('Autocorrelation for 1-63 keys');
xlim([0 length(double(alpha(1:(end-11))))*2])
saveas(fig, 'autocorr_1_63.png');
close(fig);

        % all upper 5th keys 
fig = figure();
plot(xcorr(double(alpha((end-10):end)) - mean(double(alpha((end-10):end)))), '--o');
title('Autocorrelation for 5th keys');
xlim([0 length(double(alpha((end-10):end)))*2])
saveas(fig, 'autocorr_upper_5th.png');
close(fig);

    % Inspect those with alpha ~ 0.82
        % Get indecies of ~0.82 withing its alpha value
[data((double(alpha)<0.84) .* (double(alpha)>0.8)==1,1),alpha((double(alpha)<0.84) .* (double(alpha)>0.8)==1)]
