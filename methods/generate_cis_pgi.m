% Generates confidence intervals for the mean of the timeseries data for a given electrode.
% 
% Syntax:
% [lower_bound, upper_bound] = generate_cis_pgi(data, electrode, samples)
%
% Inputs:
% data - A structure containing timeseries data for multiple electrodes.
% electrode - The index of the electrode for which to generate confidence intervals.
% samples - The number of samples to take for each mean calculation.
%
% Outputs:
% lower_bound - The lower bound of the confidence interval.
% upper_bound - The upper bound of the confidence interval.
%
% Example:
% [lb, ub] = generate_cis_pgi(data, 3, 10);
%
% This function uses the datasample and prctile functions from the Statistics and Machine Learning Toolbox.
function [lower_bound, upper_bound] = generate_cis_pgi(data, electrode, samples)
% Get timeseries data for the electrode
data = get_timeseries_data_electrode(data, electrode);

% Number of samples to take
avg_samples = samples * 100;

% Preallocate arrays
sampled_data = zeros(avg_samples, length(data{1}));
lower_bound = zeros(1, length(data));
upper_bound = zeros(1, length(data));

% Take samples and calculate mean
for jndex = 1:avg_samples
    samples_tk = datasample(data, samples);
    sampled_data(jndex, :) = get_data_mean(samples_tk);
end

% Calculate confidence intervals using prctile
lower_bound = prctile(sampled_data, 2.5, 1);
upper_bound = prctile(sampled_data, 97.5, 1);


end