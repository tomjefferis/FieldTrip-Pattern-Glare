%% EEG pattern glare analysis - Author: Tom Jefferis
%% This file is used for running DTW on the EEG data
%% setting up paths to plugins and default folder
clear all;
restoredefaultpath;

% parameters of synthetic signal
desired_time = 0.5; % in seconds
desired_fs = 500; % sample rate in Hz
desired_noise_level = 0.8; % SNR ratio
desired_trials = 1; % number of trials per participant to generate
desired_participants = 1; % number of participants to generate
desired_jitter = 0; % jitter in ± ms 
desired_peak_fs = 5; % frequency of peak in Hz
%Controls where the peak is placed in seconds
desired_peak_loc_1 = 0.1; % in seconds
desired_peak_loc_2 = 0.2; % in seconds
num_permutations = 100; % number of times to generate signal and get latencies 

median_dtw_distances = zeros(num_permutations,1);
mean_dtw_distances = zeros(num_permutations,1);
mode_dtw_distances = zeros(num_permutations,1);
max_dtw_distances = zeros(num_permutations,1);
max95_dtw_distances = zeros(num_permutations,1);
peak_latency = zeros(num_permutations,1);
frac_peak_latency = zeros(num_permutations,1);

for i = 1:num_permutations
    signals1 = generate_data(desired_time, desired_fs, desired_noise_level, desired_trials, ...
        desired_participants, desired_jitter, desired_peak_fs,desired_peak_loc_1);
    
    
    signals2 = generate_data(desired_time, desired_fs, desired_noise_level, desired_trials, ...
        desired_participants, desired_jitter, desired_peak_fs,desired_peak_loc_2);

     
    [mean_dtw_distances(i),median_dtw_distances(i),mode_dtw_distances(i),max_dtw_distances(i),max95_dtw_distances(i)] = dynamictimewarper(signals1,signals2,desired_fs);
    [peak_latency(i)] = peaklatency(signals1,signals2, desired_fs);
    [frac_peak_latency(i)] = fracpeaklatency(signals1,signals2, desired_fs);

end



%% Plotting the results, subplots for each metric, histogran for each metric
figure(1)
subplot(2,4,1)
histogram(mean_dtw_distances)
title('Mean DTW distance')
subtitle(['Middle point: ', num2str(median(mean_dtw_distances)),'s'])
subplot(2,4,2)
histogram(median_dtw_distances)
title('Median DTW distance')
subtitle(['Middle point: ', num2str(median(median_dtw_distances)),'s'])
subplot(2,4,3)
histogram(mode_dtw_distances)
title('Mode DTW distance')
subtitle(['Middle point: ', num2str(median(mode_dtw_distances)),'s'])
subplot(2,4,4)
histogram(max_dtw_distances)
title('Max DTW absoloute distance')
subtitle(['Middle point: ', num2str(median(max_dtw_distances)),'s'])
subplot(2,4,5)
histogram(max95_dtw_distances)
title('Max 95% absoloute DTW distance')
subtitle(['Middle point: ', num2str(median(max95_dtw_distances)),'s'])
subplot(2,4,6)
histogram(peak_latency)
title('Peak latency')
subtitle(['Middle point: ', num2str(median(peak_latency)),'s'])
subplot(2,4,7)
histogram(frac_peak_latency)
title('Fractional peak latency')
subtitle(['Middle point: ', num2str(median(frac_peak_latency)),'s'])


set(gcf,'Units','pixels');
set(gcf,'Position',[0 0 2560 1080]);



%% TODO
% Make it ramp noise levels from 0.1 - 1
% Plot distributions for noise levels
% plot performance for noice levels on a graph
