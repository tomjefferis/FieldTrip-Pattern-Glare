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