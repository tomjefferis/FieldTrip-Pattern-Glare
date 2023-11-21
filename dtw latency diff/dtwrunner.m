%% EEG pattern glare analysis - Author: Tom Jefferis
%% This file is used for running DTW on the EEG data
%% setting up paths to plugins and default folder
clear all;
restoredefaultpath;

desired_time = 2; % in seconds
desired_fs = 500;
desired_noise_level = 0.1;
desired_trials = 50;
desired_participants = 1;
desired_jitter = 50;
desired_peak_fs = 50;

signals = generate_data(desired_time, desired_fs, desired_noise_level, desired_trials, ...
    desired_participants, desired_jitter, desired_peak_fs);


%% DTW
dynamictimewarper(signals,desired_fs)


