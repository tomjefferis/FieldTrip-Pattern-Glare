%% EEG pattern glare analysis - Author: Tom Jefferis
%% This file is used for running all the statistics for onsets, partitions and onsets 2,3vs4,5,vs 6,7
%% setting up paths to plugins and default folder
clear all;
restoredefaultpath;
addpath('./methods');

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
time_window = [3.08, 3.99];
%time_window = [0.5 3.0];
n_participants = 40;
%baseline_period = [-0.2 0];
baseline_period = [2.8 3.0];
aggregated_roi = false; % uses aggregated average approach to find the ROI
max_windows = 4; % maximum amount of windows the roi finder finds
spatial_roi = false; % generate a spatial region of interest - not useful for most of these analysis ----- NEED TO FIX FOR FREQ
posneg = false; %true = positive side of roi false = negative
%% Time Domain config
% if need statistical test without plotting
stat_run = true;
%% frequency config
wavelet_width = 3;
frequency_ranges = {[8 13], [20 35], [30 45], [45 60], [60 80]}; % start and end frequency for stat tests
power_itc = 'pow'; %looking at power ot itc options: pow, itc
%% Plotting config
clust_volume = false; % cluter volume over time
topograpic_map_plot = false; % make topographic maps
plot_erps = false; % plotting ERPs for each condition and PGI
median_split_plots = false; % plots the median split across time window for factors
tfr_plots = false; % frequency spectrum plots
gfp_plot = false; % plots GFP as well as GFP with windows of analysis. Only generated when aggregated_roi set to true
plot_designs = false; %plots design matrix for partitions ONLY
plot_partitions_erps = true; % 10x2 figure of median split partitions for factor
generate_ci = false; % do we want confidence intervals !!BREAKS MEDIAN SPLIT PLOTS AND PARTITION SPLIT IF FALSE!!
%% generate experiment dsign
time_freq = 'frequency'; % time or frequency domain options: time or frequency
factor_scores = {'all'}; % options: none, headache, visual-stress, discomfort, all
onsets_parts = {'partitions'}; % options: onsets, partitions, onsets-23-45-67, eyes, partition1, partitions-vs-onsets
type_of_effects = {'habituation', 'sensitization'}; % habituation or sensitization
three_way_type = {'habituation'}; % same as previous but only used when making the 3 way comparison
partitions = 'orthog'; % orthogonolize design matrix for partitions (zero center), options: normal, orthog
%% disable this when wanting to run for real results
testing = true;
%% End of config

%% parfor loop running pgi analysis for all onsets_parts

if contains(time_freq, "time")

    for j = 1:numel(partitionss)
        partitions = partitionss{j};

        parfor i = 1:numel(onsets_parts)

            onsets_part = onsets_parts{i};

            tab = pgi_analysis(grand_avg_filename, single_trial_freq_filename, grand_avg_partitions_filename, time_window, n_participants, baseline_period, ...
                aggregated_roi, max_windows, spatial_roi, posneg, stat_run, wavelet_width, frequency_range, power_itc, tfr_plots, clust_volume, topograpic_map_plot, ...
                plot_erps, median_split_plots, gfp_plot, plot_designs, plot_partitions_erps, generate_ci, time_freq, factor_scores, ...
                onsets_part, type_of_effect, three_way_type, partitions, testing);

        end

    end

else

    for i = 1:numel(onsets_parts)

        onsets_part = onsets_parts{i};

        for k = 1:numel(frequency_ranges)

            frequency_range = frequency_ranges{k};

            for j = 1:numel(type_of_effects)
                type_of_effect = type_of_effects(j);

                tab = pgi_analysis(grand_avg_filename, single_trial_freq_filename, grand_avg_partitions_filename, single_trial_freq_partitions_filename, time_window, n_participants, baseline_period, ...
                    aggregated_roi, max_windows, spatial_roi, posneg, stat_run, wavelet_width, frequency_range, power_itc, tfr_plots, clust_volume, topograpic_map_plot, ...
                    plot_erps, median_split_plots, gfp_plot, plot_designs, plot_partitions_erps, generate_ci, time_freq, factor_scores, ...
                    onsets_part, type_of_effect, three_way_type, partitions, testing);

            end

        end

    end

end
