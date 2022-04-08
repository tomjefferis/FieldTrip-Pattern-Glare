[results_dir, main_path] = getFolderPath();
grand_avg_filename = 'time_domain_mean_intercept_onsets_2_3_4_5_6_7_8_grand-average.mat'; % file name within folder that has participant data
single_trial_filename = 'time_domain_mean_intercept_onsets_2_3_4_5_6_7_8_trial-level.mat'; % file name for single trial data

[data, orders] = load_data(main_path, grand_avg_filename, 40, "onsets");


data = rebaseline_data(data, [-0.2 0]);


    offset_lower = interp1(data{1}.time, 1:length(data{1}.time), 3, 'nearest');
    offset_upper = interp1(data{1}.time, 1:length(data{1}.time), 3.2, 'nearest');

    dc_lower = interp1(data{1}.time, 1:length(data{1}.time), 0.4, 'nearest');
    dc_upper = interp1(data{1}.time, 1:length(data{1}.time), 3.05, 'nearest');


    dc_peak = [];
    offset_peak = [];

    for index = 1:numel(data)
        dc_peak(index) = findpeaks(data{index}.avg(25,dc_lower:dc_upper),'SortStr', 'descend', 'NPeaks',1); %finds the peak in the dc shift period
        offset_peak(index) = findpeaks((data{index}.avg(24,offset_lower:offset_upper)*-1),'SortStr', 'descend', 'NPeaks',1) * -1;
    end

    R = corrcoef(dc_peak,offset_peak)


