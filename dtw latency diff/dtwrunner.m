%% EEG pattern glare analysis - Author: Tom Jefferis
%% This file is used for running DTW on the EEG data
%% setting up paths to plugins and default folder
clear all;
restoredefaultpath;

% parameters of synthetic signal
desired_time = 0.5; % in seconds
desired_fs = 500; % sample rate in Hz
desired_noise_level = 0.35; % SNR ratio
desired_trials = 1; % number of trials per participant to generate
desired_participants = 1; % number of participants to generate
desired_jitter = 0; % jitter in ± ms 
desired_peak_fs = 5; % frequency of peak in Hz
%Controls where the peak is placed in seconds
desired_peak_loc_1 = 0.1; % in seconds
desired_peak_loc_2 = 0.2; % in seconds

figure;

signals1 = generate_data(desired_time, desired_fs, desired_noise_level, desired_trials, ...
    desired_participants, desired_jitter, desired_peak_fs,desired_peak_loc_1);

figure;

signals2 = generate_data(desired_time, desired_fs, desired_noise_level, desired_trials, ...
    desired_participants, desired_jitter, desired_peak_fs,desired_peak_loc_2);

figure;

%% DTW
dynamictimewarper(signals1,signals2,desired_fs)
peaklatency(signals1,signals2, desired_fs)
fracpeaklatency(signals1,signals2, desired_fs)


%% TODO
% Implement mean dtw latency
% Implement 95th percentile latency
% Implement permutation style test 1-10k simulations 
% Add statistical analysis for this simulated data
% Plot results and warp path example
%% TODO AFTER
% Make it ramp noise levels from 0.1 - 1
% Plot distributions for noise levels
% plot performance for noice levels on a graph
