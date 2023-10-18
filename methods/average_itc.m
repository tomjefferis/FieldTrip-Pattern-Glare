% FILEPATH: w:\PhD\PatternGlareCode\FieldTrip-Pattern-Glare\methods\average_itc.m
%
% Averages inter-trial coherence (ITC) across multiple trials.
%
% Inputs:
%   - data: a cell array of ITC data structures, each containing the following fields:
%       - label: channel labels
%       - freq: frequency vector
%       - time: time vector
%       - dimord: dimension order
%       - itpc: inter-trial phase coherence
%       - itlc: inter-trial linear coherence
%
% Outputs:
%   - itc: a structure containing the following fields:
%       - label: channel labels
%       - freq: frequency vector
%       - time: time vector
%       - dimord: dimension order
%       - itpc: averaged inter-trial phase coherence
%       - itlc: averaged inter-trial linear coherence
%
function [itc] = average_itc(data)

    itc = [];
    itc.label = data{1}.label;
    itc.freq = data{1}.freq;
    itc.time = data{1}.time;
    itc.dimord = 'chan_freq_time';

    itpc = zeros(size(data{1}.itpc));
    itlc = zeros(size(data{1}.itlc));

    for index = 1:numel(data)

        itpc = itpc + data{index}.itpc;
        itlc = itlc+ data{index}.itlc;
    end

    itc.itpc = itpc/numel(data);
    itc.itlc = itlc/numel(data);

end