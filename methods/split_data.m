function [thin, med, thick] = split_data(data, freq)

% split the data into thin med thick
% where each medium thick and thin are 128 channel timeseries returned from FT_TIMELOCKANALYSIS
% Use as
%   split_data(data)
% Where data is a cell array of FT structs with time series fields avg, thin, med, and thick
% Freq is an optional parameter

if ~exist('freq','var')
    freq = false;
end

    thin = low_level_split(data, "thin",freq);
    med = low_level_split(data, "med",freq);
    thick = low_level_split(data, "thick",freq);

end