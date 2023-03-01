function [lower_bound, upper_bound] = generate_cis_pgi(data, electrode, samples)
% Get timeseries data for the electrode
data = get_timeseries_data_electrode(data, electrode);

% Number of samples to take
avg_samples = samples * 100;

% Preallocate arrays
sampled_data = zeros(avg_samples, length(data));
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