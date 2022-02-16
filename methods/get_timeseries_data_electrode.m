function [timeseries_data] = get_timeseries_data_electrode(data, electrode, channel)

    % this function gets the time series for only the desired electrode, used in bootstrapping to improve time complexity
    %
    % Use as:
    %       get_timeseries_data_electrode(data, electrode)
    %   Where data is a FT data object with avg series returned from FT_TIMELOCKANALYSIS
    %   And electrode is the index of the wanted electrode

    if ~exist('channel', 'var')
        channel = 'avg';
    end

    timeseries_data = [];

    for index = 1:numel(data)
        item = data{index};
        temp = getfield(item, channel)
        timeseries_data{index} = temp(electrode, :);
    end

end
