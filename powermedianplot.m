%% The usual Config

%% EEG pattern glare analysis - Author: Tom Jefferis
%% setting up paths to plugins and default folder
clear all;
restoredefaultpath;
addpath('.\methods');

grand_avg_filename = 'time_domain_mean_intercept_onsets_2_3_4_5_6_7_8_grand-average.mat'; % file name within folder that has participant data
single_trial_filename = 'time_domain_mean_intercept_onsets_2_3_4_5_6_7_8_trial-level.mat'; % file name for single trial data

grand_avg_partitions_filename = 'time_domain_partitions_partitioned_onsets_2_3_4_5_6_7_8_grand-average.mat'; % file name within folder that has participant data
single_trial_partitions_filename = 'time_domain_partitions_partitioned_onsets_2_3_4_5_6_7_8_trial-level.mat'; % file name for single trial data

grand_avg_freq_filename = 'frequency_domain_mean_intercept_onsets_2_3_4_5_6_7_8_grand-average.mat'; % file name within folder that has participant data
single_trial_freq_filename = 'frequency_domain_mean_intercept_onsets_2_3_4_5_6_7_8_trial-level.mat'; % file name for single trial data

grand_avg_freq_partitions_filename = 'frequency_domain_partitions_partitioned_onsets_2_3_4_5_6_7_8_grand-average.mat'; % file name within folder that has participant data
single_trial_freq_partitions_filename = 'frequency_domain_partitions_partitioned_onsets_2_3_4_5_6_7_8_trial-level.mat'; % file name for single trial data

grand_avg_eyes = 'time_domain_eye_confound_onsets_2_3_4_5_6_7_8_grand-average.mat';

%% Experiment parameters
% ROI window
time_window = [2.5, 3.998];
%time_window = [3.09, 3.18;];
n_participants = 40;
baseline_period = [2.8 3.0];
aggregated_roi = false; % uses aggregated average approach to find the ROI
max_windows = 4; % maximum amount of windows the roi finder finds
spatial_roi = false; % generate a spatial region of interest - not useful for most of these analysis ----- NEED TO FIX FOR FREQ
posneg = true; %true = positive side of roi false = negative
%% Time Domain config
% if need statistical test without plotting
stat_run = true;
%% frequency config
wavelet_width = 5;
frequency_range = [60 80]; % start and end frequency for stat tests
%% generate experiment design
time_freq = 'frequency'; % time or frequency domain options: time or frequency
factor = 'discomfort'; % options: none, headache, visual-stress, discomfort, all
onsets_part = 'onsets'; % options: onsets, partitions, onsets-23-45-67, eyes, partition1
type_of_effect = {'habituation'}; % habituation or sensitization
%% disable this when wanting to run for real results
testing = false;
%% End of config

[results_dir, main_path] = getFolderPath();
results_dir = strcat(results_dir, "/", time_freq);

filename_precomposed = strcat(string(wavelet_width), "-cyc-pow-", onsets_part, "-decomposed_dat.mat");



[data,order] = load_freq_decomp(main_path, single_trial_freq_filename, filename_precomposed, n_participants, wavelet_width,time_window);


[design_matrix, data] = get_design_matrix(factor, data, order);

[low, high] = median_split(data, order, design_matrix);

low = average_power(low.data, frequency_range);
high = average_power(high.data, frequency_range);
elec = [];
elec.electrode = 'D16';
plot_median_split_power(low, high,elec);

%[data,order] = load_freq_decomp(main_path, single_trial_freq_filename, filename_precomposed, n_participants, wavelet_width,time_window);