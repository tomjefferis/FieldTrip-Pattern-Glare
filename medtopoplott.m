%% EEG pattern glare analysis - Author: Tom Jefferis
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
%time_window = [3.08, 3.99; 3.09, 3.18; 3.18, 3.45; 3.45, 3.83];
time_window = [3.09, 3.18; ];
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
time_freq = 'time'; % time or frequency domain options: time or frequency
factor = 'discomfort'; % options: none, headache, visual-stress, discomfort, all
onsets_part = 'onsets'; % options: onsets, partitions, onsets-23-45-67, eyes, partition1
type_of_effect = {'habituation'}; % habituation or sensitization
%% disable this when wanting to run for real results
testing = false;
%% End of config

[results_dir, main_path] = getFolderPath();
results_dir = strcat(results_dir, "/", time_freq);

[datas, orders] = load_data(main_path, grand_avg_filename, n_participants, onsets_part);



[thin, med, thick] = split_data(datas);

stat.time = med{1}.time;
cfg = [];
cfg.channel = 'all';
cfg.latency = 'all';
med = ft_timelockgrandaverage(cfg,med{:});

difference = linspace(time_window(1), time_window(2), 13); %amount of subplots in this

for i = 1:12

    %finding time window from the closest times in the series to the inputs
    lower = interp1(stat.time, 1:length(stat.time), difference(i), 'nearest');
    upper = interp1(stat.time, 1:length(stat.time), difference(i + 1), 'nearest');

    if isnan(upper)
        upper = length(stat.time);
    end

    if isnan(lower)
        lower = length(stat.time) - 1;
    end

    %highlight = mean(clustermark(:, lower:upper), 2);
    %highlight = stat.label(highlight == 1);

    subplot(4, 3, i);
    % cfg for plot
    cfg = [];
    cfg.xlim = [difference(i), difference(i + 1)];
    cfg.layout = 'biosemi128';
%    cfg.highlightchannel = highlight;
    cfg.highlightcolor = [1 0 0];
    cfg.highlightsymbolseries = ['*', '*', '.', '.', '.'];
    cfg.highlightsize = 8;
    cfg.contournum = 0;
    cfg.alpha = 0.05;
    cfg.comment = 'xlim';
    cfg.parameter = 'avg';
    cfg.zlim = [-2 4];

    if i == 12
        cfg.colorbar = 'yes'; % adds to every plot usually disabled, uness need figure with bar
    end

    cfg.parameter = 'avg';
    ft_topoplotER(cfg, med);

end

if contains(factor, "habituation") || contains(factor, "sensitization")

    if contains(factor, "visual")
        results_fact = "visual-stress";
        imgname = "visual-stress partitions topomap.png";
    elseif contains(factor, "headache")
        results_fact = "headache";
        imgname = "headache partitions topomap.png";
    elseif contains(factor, "discomfort")
        results_fact = "discomfort";
        imgname = "discomfort partitions topomap.png";
    else
        results_fact = "none";
        imgname = strcat("none partitions topomap.png");
    end

else
    results_fact = factor;
    imgname = strcat(factor, " ", string(time_window(1)), " onsets topomap.png");
end

title_main = strcat("Topographic map of significant clusters ", results_fact);
sgtitle(title_main);
imgname = strcat(polarity, " ", imgname);
save_dir_full = strcat(results, "/", results_fact, "/", imgname);
saveas(gcf, save_dir_full);
hold off;
