addpath('../methods');
addpath('C:\Users\tomje\AppData\Roaming\MathWorks\MATLAB Add-Ons\Collections\Image Manipulation Toolbox\MIMT')

electrode = 'A23'; % Oz

[results_dir, main_path] = getFolderPath();
single_trial_freq_filename = 'frequency_domain_mean_intercept_onsets_2_3_4_5_6_7_8_trial-level.mat'; % file name for single trial data

[data, orders] = load_data(main_path, single_trial_freq_filename, 40, 'onsets');

% for all data only for Oz
for i = 1:length(data)
    temp_dat = data{i};
    % find temp_data.label == electrode
    idx = find(strcmp(temp_dat.label, electrode));
    
    data{i} = temp_dat;
end

[data] = freq_power_decopmosition(data, 5, 250, 'alldata_OZ_pow-onsets', [-0.2 4], [8 80], [-0.2 0], electrode);
[thin, med, thick] = split_data(data,true);
data = [thin, med, thick];
% freq grand average
cfg = [];
cfg.keepindividual = 'no';
cfg.channel = electrode;
cfg.parameter = 'powspctrm';

data = ft_freqgrandaverage(cfg, data{:});

cfg = [];
cfg.baseline = [-0.2 0];
%cfg.baselinetype = 'db';

data = ft_freqbaseline(cfg, data);


xyz = squeeze(data.powspctrm);

% surf plot view(2)
figure;
surf(data.time, data.freq, xyz, 'EdgeColor', 'none');
view(2);
% colorbar
colorbar;
title('Oz power spectrum');
xlabel('Time (s)');
ylabel('Frequency (Hz)');

% add y lines for freq bands at [8,13],[20, 30],[30,45],[45,60],[60,80]
hold on;
y = [8, 13];
yline(y(1), 'r', 'LineWidth', 2);
yline(y(2), 'r', 'LineWidth', 2);

y = [20, 29.8];
yline(y(1), 'g', 'LineWidth', 2);
yline(y(2), 'g', 'LineWidth', 2);

y = [30.2, 44.8];
yline(y(1), 'b', 'LineWidth', 2);
yline(y(2), 'b', 'LineWidth', 2);

y = [45.2, 59.8];
yline(y(1), 'y', 'LineWidth', 2);
yline(y(2), 'y', 'LineWidth', 2);

y = [60.2, 80];
yline(y(1), 'm', 'LineWidth', 2);
yline(y(2), 'm', 'LineWidth', 2);

ylim([8 80]);
xlim([-0.2 4]);
legend([{'power'},{'8 Hz'}, {'13 Hz'}, {'20 Hz'}, {'30 Hz'}, {'30 Hz'}, {'45 Hz'}, {'45 Hz'}, {'60 Hz'}, {'60 Hz'}, {'80 Hz'}]);
% legend outside right
legend('Location', 'eastoutside');

% save figure
saveas(gcf, fullfile(results_dir, 'Oz_power_spectrum_surf_plot.png'));