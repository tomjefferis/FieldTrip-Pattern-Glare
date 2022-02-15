function data = set_values_to_zero(data)

% set_values_to_zero sets each participants avg timeseries to zero
% this is used to 'hack' a permutation test against the pattern glare index for
% the Mean intercept and Partitions regressor.
% 
% Use as:
%       set_values_to_zero(data)
%   Where data is a cell array of structs returned by FT_TIMELOCKANALYSIS or FT_FREQANALYSIS 
%   the returned data is to be used in FT_FREQSTATISTICS and FT_TIMELOCKSTATISTICS in combination with the normal data
%

    for idx = 1:numel(data)
        participant_data = data{idx};

        if isfield(participant_data, 'avg')
            series = participant_data.avg;
            series(:) = 0;
            participant_data.avg = series;
            data{idx} = participant_data;
        else
            series = participant_data.powspctrm;
            series(:) = 0;
            participant_data.powspctrm = series;
            data{idx} = participant_data;
        end

    end

end