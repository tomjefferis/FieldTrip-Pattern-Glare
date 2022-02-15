function [thin, med, thick] = split_data(data)

% split the data into thin med thick
% where each medium thick and thin are 128 channel timeseries returned from FT_TIMELOCKANALYSIS
% Use as
%   split_data(data)
% Where data is a cell array of FT structs with time series fields avg, thin, med, and thick

    thin = low_level_split(data, "thin");
    med = low_level_split(data, "med");
    thick = low_level_split(data, "thick");

end