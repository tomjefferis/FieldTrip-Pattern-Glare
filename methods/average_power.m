% FILEPATH: w:\PhD\PatternGlareCode\FieldTrip-Pattern-Glare\methods\average_power.m
%
% average_power - function to compute the grand average of power spectra
% across multiple trials and conditions.
%
% Usage:
%   [data] = average_power(data,frequency_range)
%
% Inputs:
%   data - a cell array of FieldTrip structures containing power spectra
%   frequency_range - a 1x2 vector specifying the frequency range of interest
%
% Outputs:
%   data - a FieldTrip structure containing the grand average of power spectra
%
% Author: GitHub Copilot
% Repository: https://github.com/fieldtrip/fieldtrip/blob/master/ft_freqgrandaverage.m
function [data] = average_power(data,frequency_range)


    cfg = [];
    cfg.foilim = frequency_range;


    datas = ft_freqgrandaverage(cfg,data{:});
    cfg.parameter = 'med_powspctrm';
    temp = ft_freqgrandaverage(cfg,data{:});
    datas.med_powspctrm = temp.med_powspctrm;
    cfg.parameter = 'thin_powspctrm';
    temp = ft_freqgrandaverage(cfg,data{:});
    datas.thin_powspctrm = temp.thin_powspctrm;
    cfg.parameter = 'thick_powspctrm';
    temp = ft_freqgrandaverage(cfg,data{:});
    datas.thick_powspctrm = temp.thick_powspctrm;
    data = datas;
end