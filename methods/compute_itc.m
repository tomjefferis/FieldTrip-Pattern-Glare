% FILEPATH: w:\PhD\PatternGlareCode\FieldTrip-Pattern-Glare\methods\compute_itc.m
%
% COMPUTE_ITC computes inter-trial coherence (ITC) and inter-trial linear
% coherence (ITLC) from Fourier spectra of trial data.
%
% INPUT:
%   data - a structure containing the following fields:
%       - fourierspctrm: Fourier spectra of trial data (channels x frequencies x time x trials)
%       - label: channel labels (cell array of strings)
%       - freq: frequency values (vector)
%       - time: time values (vector)
%
% OUTPUT:
%   itc - a structure containing the following fields:
%       - label: channel labels (cell array of strings)
%       - freq: frequency values (vector)
%       - time: time values (vector)
%       - dimord: dimension order of the Fourier spectra (fixed to 'chan_freq_time')
%       - itpc: inter-trial phase coherence (channels x frequencies x time)
%       - itlc: inter-trial linear coherence (channels x frequencies x time)
%
% See also FT_FREQANALYSIS, FT_CONNECTIVITYANALYSIS.
function [itc] = compute_itc(data)

    itc = [];
    itc.label = data.label;
    itc.freq = data.freq;
    itc.time = data.time;
    itc.dimord = 'chan_freq_time';

    F = data.fourierspctrm; % copy the Fourier spectrum
    N = size(F, 1); % number of trials

    % compute inter-trial phase coherence (itpc)
    itc.itpc = F ./ abs(F); % divide by amplitude
    itc.itpc = sum(itc.itpc, 1); % sum angles
    itc.itpc = abs(itc.itpc) / N; % take the absolute value and normalize
    itc.itpc = squeeze(itc.itpc); % remove the first singleton dimension

    % compute inter-trial linear coherence (itlc)
    itc.itlc = sum(F) ./ (sqrt(N * sum(abs(F).^2)));
    itc.itlc = abs(itc.itlc); % take the absolute value, i.e. ignore phase
    itc.itlc = squeeze(itc.itlc); % remove the first singleton dimension

end
