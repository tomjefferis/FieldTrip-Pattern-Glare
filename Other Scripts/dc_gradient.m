%% EEG pattern glare analysis - Author: Tom Jefferis
%% setting up paths to plugins and default folder
clear all;
restoredefaultpath;
addpath('./methods');
grand_avg_filename = 'time_domain_mean_intercept_onsets_2_3_4_5_6_7_8_grand-average.mat'; % file name within folder that has participant data
single_trial_filename = 'time_domain_mean_intercept_onsets_2_3_4_5_6_7_8_trial-level.mat'; % file name for single trial data

%% Experiment parameters
% ROI window
%time_window = [3.08, 3.99; 3.09, 3.18; 3.18, 3.45; 3.45, 3.83];
time_window = [-0.2, 0; ];
n_participants = 40;
baseline_period = [2.8 3.0];
onsets_part = 'onsets'; % options: onsets, partitions, onsets-23-45-67, eyes, partition1
grad_stat = false; % this measure is a permutation test of thin medium and thick gradients

[results_dir, main_path] = getFolderPath();
[datas, orders] = load_data(main_path, grand_avg_filename, n_participants, onsets_part);


datas_grad = [];
for index = 1:numel(datas)
    temp = datas{index};
    temp.avg = gradient(temp.avg);
    temp.thin = gradient(temp.thin);
    temp.med = gradient(temp.med);
    temp.thick = gradient(temp.thick);
    datas_grad{index} = temp;
end



if grad_stat
    [thin, med, thick] = split_data(datas);
    grads = [];

    start_t = interp1(datas{1}.time, 1:length(datas{1}.time), time_window(1), 'nearest');
    end_t = interp1(datas{1}.time, 1:length(datas{1}.time), time_window(2), 'nearest');

 n
    for index = 1:numel(datas)
        for jndex = 1:size(datas{1}.label)
            gee = polyfit(datas{index}.time(start_t:end_t),datas{index}.avg(jndex,start_t:end_t),1);
            grads(index,jndex) = gee(1);
        end
    end

    stat = [];

    for index = 1:size(grads,2)
        stat(index) = ttest(grads(:,index));
    end

    stat;



else


    
    significant_electrode.electrode = 'A23';
    
    significant_electrode.time = 3.99;
    significant_electrode.t_value = 0;
    %generate_erp_plot(results_dir, 0, 3.9, datas, significant_electrode, "none", false, "negative");
    ft_plot_baseline(datas, baseline_period,time_window, significant_electrode)
    

end
