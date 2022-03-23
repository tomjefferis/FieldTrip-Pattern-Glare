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
%time_window = [2.5, 3.998];
time_window = [2.8, 3.45;];
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
wavelet_width = 3;
frequency_range = [8 13]; % start and end frequency for stat tests
%% generate experiment design
statistic = 'ft_statfun_diff_itc'; % "freq" (default) or defined statistic from fieldtrip
factor_scores = {'discomfort'}; % options: none, headache, visual-stress, discomfort, all
onsets_part = 'onsets'; % options: onsets, partitions, onsets-23-45-67, eyes, partition1
type_of_effect = {'habituation'}; % habituation or sensitization
%% plotting function
clust_volume = false;
topograpic_map_plot = false;
median_split_plots = false;
spect_plot = true; %does nothing atm
plot_designs = true; %does nothing atm

%% disable this when wanting to run for real results
testing = false;
%% End of config

tab = freq_analysis(single_trial_freq_filename, time_window, n_participants, baseline_period, ...
        spatial_roi, posneg, stat_run, wavelet_width, frequency_range, clust_volume, topograpic_map_plot, ...
        median_split_plots, spect_plot, statistic, plot_designs, factor_scores, ...
        onsets_part, type_of_effect, "itc", testing)

%[data,order] = load_freq_decomp(main_path, single_trial_freq_filename, filename_precomposed, n_participants, wavelet_width,time_window);