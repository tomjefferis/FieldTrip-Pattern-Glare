addpath('./methods');
[results_dir, main_path] = getFolderPath();
grand_avg_filename = 'time_domain_mean_intercept_onsets_2_3_4_5_6_7_8_grand-average.mat'; % file name within folder that has participant data
single_trial_filename = 'time_domain_mean_intercept_onsets_2_3_4_5_6_7_8_trial-level.mat'; % file name for single trial data

[data, orders] = load_data(main_path, grand_avg_filename, 40, "onsets");


data = rebaseline_data(data, [-0.2 0]);


    offset_lower = interp1(data{1}.time, 1:length(data{1}.time), 3.3, 'nearest');
    offset_upper = interp1(data{1}.time, 1:length(data{1}.time), 3.8, 'nearest');

    dc_lower = interp1(data{1}.time, 1:length(data{1}.time), 0.4, 'nearest');
    dc_upper = interp1(data{1}.time, 1:length(data{1}.time), 3.05, 'nearest');

    max_mean_dc = interp1(data{1}.time, 1:length(data{1}.time), 0.9414, 'nearest');
    dc_peak = [];
    offset_peak = [];

    for index = 1:numel(data)

        %dc_val = data{index}.med(25,dc_lower:dc_upper);
        %time_val = data{index}.time(dc_lower:dc_upper);

        %p = polyfit(time_val,dc_val,1) ;
        %m = p(1);

       
        % dc_peak(index) = m;

        dc_peak(index) = mean(data{index}.med(23,dc_lower:dc_upper)); %finds the peak in the dc shift period
        %dc_peak(index) = findpeaks(data{index}.med(25,dc_lower:dc_upper),'SortStr', 'descend', 'NPeaks',1);
        %offset_peak(index) = findpeaks((data{index}.med(23,offset_lower:offset_upper)*-1),'SortStr', 'descend', 'NPeaks',1) * -1;
        offset_peak(index) = mean(data{index}.med(23,offset_lower:offset_upper));
    end

    [R,P] = corrcoef(dc_peak,offset_peak);
    sub = strcat('R = ', string(R(2)), ' P = ', string(P(2)));
    %print(p);
    %scatter plot
    figure;
    scatter(dc_peak, offset_peak);
    xlabel('DC Shift Average Amplitude');
    ylabel('Offset Average');
    title('DC Shift Average Amplitude vs. Offset Average');
    subtitle(sub)
    hold on;
    grid on;
    %line of best fit
    p = polyfit(dc_peak,offset_peak,1);
    x = linspace(min(dc_peak),max(dc_peak));
    y = p(1)*x + p(2);
    plot(x,y);
    saveas(gcf,strcat(results_dir, '/dc_offset_scatter.png'));
    hold off;

    

    



