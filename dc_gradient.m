%% EEG pattern glare analysis - Author: Tom Jefferis
%% setting up paths to plugins and default folder
clear all;
restoredefaultpath;
addpath('./methods');
addpath("C:\Users\Tom\AppData\Roaming\MathWorks\MATLAB Add-Ons\Functions\Patchline")
grand_avg_filename = 'time_domain_mean_intercept_onsets_2_3_4_5_6_7_8_grand-average.mat'; % file name within folder that has participant data
single_trial_filename = 'time_domain_mean_intercept_onsets_2_3_4_5_6_7_8_trial-level.mat'; % file name for single trial data

%% Experiment parameters
% ROI window
%time_window = [3.08, 3.99; 3.09, 3.18; 3.18, 3.45; 3.45, 3.83];
time_window = [0.25, 3; ];
n_participants = 40;
baseline_period = [-0.2 0];
onsets_part = 'onsets'; % options: onsets, partitions, onsets-23-45-67, eyes, partition1
grad_stat = false; % this measure is a permutation test of thin medium and thick gradients

[results_dir, main_path] = getFolderPath();
[datas, orders] = load_data(main_path, grand_avg_filename, n_participants, onsets_part);

if sum(baseline_period == [2.8 3.0]) < 2
    datas = rebaseline_data(datas, baseline_period);
end
datas_grad = [];
for index = 1:numel(datas)
    temp = datas{index};
    temp.avg = gradient(temp.avg);
    temp.thin = gradient(temp.thin);
    temp.med = gradient(temp.med);
    temp.thick = gradient(temp.thick);
    datas_grad{index} = temp;
end

[thin, med, thick] = split_data(datas);

if grad_stat

dm = [ones(1, numel(datas)), (2 * ones(1, numel(datas))), (3 * ones(1, numel(datas)))];

cfg = [];
cfg.feedback = 'no';
cfg.method = 'distance';
cfg.elec = datas{1}.elec;
neighbours = ft_prepare_neighbours(cfg);

cfg = [];
cfg.latency = time_window;
cfg.channel = 'all';
cfg.method = 'montecarlo';
cfg.correctm = 'cluster';
cfg.neighbours = neighbours;
cfg.clusteralpha = 0.025;
cfg.numrandomization = 5000;
cfg.design = dm;
cfg.computeprob = 'yes';
cfg.alpha = 0.05;

cfg.statistic = 'ft_statfun_indepsamplesregrT';
cfg.ivar = 1;
stat = ft_timelockstatistics(cfg, thin{:},med{:},thick{:});
else

    significant_electrode.electrode = 'A23';
    electrode_index = get_electrode_index(datas, significant_electrode);
    significant_electrode.time = 3.99;
    significant_electrode.t_value = 0;
    %generate_erp_plot(results_dir, 0, 3.9, datas, significant_electrode, "none", false, "negative");

    cfg = [];
    cfg.latency = time_window;
    %get grand average erps for conditions
    grandavgthin = ft_timelockgrandaverage(cfg, thin{:});
    grandavgmed = ft_timelockgrandaverage(cfg, med{:});
    grandavgthick = ft_timelockgrandaverage(cfg, thick{:});

    x = grandavgthin.time;
    y1 = polyval(polyfit(x,grandavgthin.avg(electrode_index, :),1),grandavgthin.time);%*mean(grandavgthin.avg(electrode_index, :));
    y2 = polyval(polyfit(x,grandavgmed.avg(electrode_index, :),1),grandavgthin.time);%*mean(grandavgmed.avg(electrode_index, :));
    y3 = polyval(polyfit(x,grandavgthick.avg(electrode_index, :),1),grandavgthin.time);%*mean(grandavgthick.avg(electrode_index, :));
    %x = datas{1}.time(103:1639);


    plot(x,y1, 'Color', '#0072BD', 'LineWidth', 2);
    hold on;
    plot(x,y2, 'Color', '#D95319', 'LineWidth', 2);
    plot(x,y3, 'Color', '#EDB120', 'LineWidth', 2);

    patchline(x,grandavgthin.avg(electrode_index,:), 'edgecolor', '#0072BD', 'LineWidth', 2,'edgealpha',0.3);
    patchline(x,grandavgmed.avg(electrode_index,:), 'edgecolor', '#D95319', 'LineWidth', 2,'edgealpha',0.3);
    patchline(x,grandavgthick.avg(electrode_index,:), 'edgecolor', '#EDB120', 'LineWidth', 2,'edgealpha',0.3);
    grid on;
    xlim(time_window);
    ylim([-2,4]);
    title(strcat("ERP with best fit at ",significant_electrode.electrode));
    legend(["Thin","Medium","Thick"]);
end
