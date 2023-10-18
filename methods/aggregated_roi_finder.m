% This function finds the time windows of interest for a given dataset by
% calculating the grand average of all conditions and then finding the
% peaks in the global field power (GFP) of the flattened average. The
% function then returns the time windows that contain the peaks. The
% function also has an option to plot the GFP and the identified time
% windows. 
%
% Inputs:
%   - main_path: the path to the directory containing the data files
%   - filename: the name of the data file
%   - n_participants: the number of participants in the study
%   - start_time: the start time of the time window of interest
%   - end_time: the end time of the time window of interest
%   - baseline_period: the baseline period for calculating the GFP
%   - max_windows: the maximum number of time windows to identify
%   - results_dir: the directory to save the plot of the GFP and identified
%     time windows
%   - plotter: a boolean indicating whether to plot the GFP and identified
%     time windows
%
% Outputs:
%   - window_time: a matrix containing the start and end times of the
%     identified time windows
%
% Example usage:
%   [window_time] = aggregated_roi_finder('w:\PhD\PatternGlareCode\FieldTrip-Pattern-Glare\methods\', 'data.mat', 10, 0.1, 0.5, [-0.2 -0.1], 3, 'results\', true);
function [window_time] = aggregated_roi_finder(main_path, filename, n_participants, start_time, end_time, baseline_period, max_windows, results_dir, plotter)
    % loads trial data and prepares for aggregated avg merge
    [data, order] = load_data(main_path, filename, n_participants, 'onsets');

    datas = {};

    % adding all the conditions together into one set of trials for each participant
    for index = 1:length(data)
        item = data{index};
        thin = item.thin;
        med = item.med;
        thick = item.thick;
        thin(:, 1) = [];
        med(:, 1) = [];
        thick(:, 1) = [];
        datas = cat(2, datas, thin, med, thick);
    end

    % grand average of all conditions
    % creating a template in FT format for the FFA
    template = data{1};
    template = rmfield(template, 'med');
    template = rmfield(template, 'thin');
    template = rmfield(template, 'thick');
    div = length(datas);
    data = zeros(size(datas{1}));
    % getting the mean of all the timeseries
    for item = datas
        item = item{:};
        data = data + item;
    end

    data = data / div;

    % memory efficiancy
    template.avg = data;
    data = [];

    % I do this to have a less restricted time window to search in can be
    % disabled if needed with setting the flex input to false
    if (end_time - start_time) < 0.4
        start_times = start_time / 1.05;
        end_times = end_time * 1.05;
        % checks if these new 'flexed' times are good
        if ~isnan(start_times)
            start_time = start_times;
        end

        if ~isnan(end_times)
            end_time = end_times;
        end

    end

    %finding time window from the closest times in the series to the inputs
    lower = interp1(template.time, 1:length(template.time), start_time, 'nearest');
    upper = interp1(template.time, 1:length(template.time), end_time, 'nearest');
    %reducing time window to search for peaks
    template.time = template.time(lower:upper);
    template.avg = template.avg(:, lower:upper);

    time = template.time * 1000;
    % calculating GFP from flatttened average
    gfp = [1:length(template.time)];

    for index = 1:length(gfp)
        gfp(index) = rms(template.avg(:, index));
    end

    [peaks, windowindexs] = window_placer(gfp, max_windows, baseline_period);

    window_time = [];

    for index = 1:numel(windowindexs)

        if windowindexs(index).startloc == 0
            windowindexs(index).startloc = 1;
        end

        % gets the windows in correct format to be returned for next method
        window_time(index, :) = [round(time(windowindexs(index).startloc) / 1000, 2), round(time(windowindexs(index).endloc) / 1000, 2)];

    end

    if plotter
        GFP_Plotter(results_dir, windowindexs, gfp, time, start_time, end_time, true);
    end

end