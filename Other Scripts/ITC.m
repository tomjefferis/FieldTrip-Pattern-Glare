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
%time_window = [3.09, 3.18; ];
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
frequency_range = [8 13]; % start and end frequency for stat tests
%% Plotting config
clust_volume = false; % cluter volume over time
topograpic_map_plot = true; % make topographic maps
plot_erps = false; % plotting ERPs for each condition and PGI
median_split_plots = false; % plots the median split across time window for factors
gfp_plot = false; % plots GFP as well as GFP with windows of analysis. Only generated when aggregated_roi set to true
plot_designs = false; %plots design matrix for partitions ONLY
plot_partitions_erps = false; % 10x2 figure of median split partitions for factor
generate_ci = true; % do we want confidence intervals !!BREAKS MEDIAN SPLIT PLOTS AND PARTITION SPLIT IF FALSE!!
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

filename_precomposed = strcat(string(wavelet_width), "-cyc-for-", onsets_part, "-decomposed_dat.mat");

output = "fourier";

data = [];
order = [];

for index = 1:n_participants
    fprintf('LOADING %d/%d \n', index, n_participants);
    participant_main_path = strcat(main_path, int2str(index));

    if exist(participant_main_path, 'dir')
        cd(participant_main_path);

        if isfile(filename_precomposed)
            order(end + 1) = index;
            temp = load(filename_precomposed);
            data{end+1} = temp.decomposed;

        elseif isfile(single_trial_freq_filename)
            order(end + 1) = index;
            datas = load(single_trial_freq_filename).data;
            datas.trialinfo = [1];
            datas.dimord = 'chan_time';
            datas.time = datas.time{1};
            
            temp = freq_fourier_decomposition(datas, wavelet_width, filename_precomposed, time_window);
            decomposed = compute_itc(temp);

            

            save(filename_precomposed, "decomposed", '-v7.3');
            data{index} = decomposed;
        end

    end

end

%[design_matrix, data] = get_design_matrix(factor, data, order);

%[low, high] = median_split(data, order, design_matrix);

%low = average_itc(low.data);
%high = average_itc(high.data);
%elec = [];
%elec.label = 'A26';
%plot_med_split_itc(low, high,elec);

%[data,order] = load_freq_decomp(main_path, single_trial_freq_filename, filename_precomposed, n_participants, wavelet_width,time_window);

tab = freq_analysis(single_trial_freq_filename, time_window, n_participants, baseline_period, ...
        spatial_roi, posneg, stat_run, wavelet_width, frequency_range, clust_volume, topograpic_map_plot, ...
        median_split_plots, spect_plot, statistic, plot_designs, factor_scores, ...
        onsets_part, type_of_effect, testing)