% generate_confidence_ints - Generate confidence intervals for thin, medium, and thick data
%
% Syntax: [lower_bound_thin, upper_bound_thin, lower_bound_med, upper_bound_med, lower_bound_thick, upper_bound_thick] = generate_confidence_ints(data, electrode)
%
% Inputs:
%    data - A struct containing the data to be split into thin, medium, and thick
%    electrode - The electrode to extract the timeseries data from
%
% Outputs:
%    lower_bound_thin - The lower bound of the confidence interval for the thin data
%    upper_bound_thin - The upper bound of the confidence interval for the thin data
%    lower_bound_med - The lower bound of the confidence interval for the medium data
%    upper_bound_med - The upper bound of the confidence interval for the medium data
%    lower_bound_thick - The lower bound of the confidence interval for the thick data
%    upper_bound_thick - The upper bound of the confidence interval for the thick data
%
% Example:
%    [lb_thin, ub_thin, lb_med, ub_med, lb_thick, ub_thick] = generate_confidence_ints(data, 'Fz')
%
% Other m-files required: split_data.m, get_timeseries_data_electrode.m, get_data_mean.m
% Subfunctions: None
% MAT-files required: None
%
% See also: split_data, get_timeseries_data_electrode, get_data_mean

% Author: GitHub Copilot
% Email: -
% Website: -
% June 2021; Last revision: 10-June-2021
%------------- BEGIN CODE --------------
function [lower_bound_thin, upper_bound_thin, lower_bound_med, upper_bound_med, lower_bound_thick, upper_bound_thick] = generate_confidence_ints(data, electrode)
    % split data to med thick and thin
    [thin, med, thick] = split_data(data);
    thin = get_timeseries_data_electrode(thin, electrode);
    med = get_timeseries_data_electrode(med, electrode);
    thick = get_timeseries_data_electrode(thick, electrode);
    % sets how many samples you want for Bootstrapping
    avg_samples = 4000;
    samples = 40;

    sampled_thin = [];
    sampled_med = [];
    sampled_thick = [];
    lower_bound_thin = [];
    upper_bound_thin = [];
    lower_bound_med = [];
    upper_bound_med = [];
    lower_bound_thick = [];
    upper_bound_thick = [];
    % random sampling
    for jndex = 1:avg_samples
        samples_tn = datasample(thin, samples);
        samples_md = datasample(med, samples);
        samples_tk = datasample(thick, samples);

        sampled_thin(jndex, :) = get_data_mean(samples_tn);
        sampled_med(jndex, :) = get_data_mean(samples_md);
        sampled_thick(jndex, :) = get_data_mean(samples_tk);

    end

    [Num_Rows, Num_Cols] = size(sampled_thin);
    %average random samples
    for index = 1:Num_Cols
        column_thin = sampled_thin(:, index);
        lower_bound_thin(1, index) = prctile(column_thin, 2.5);
        upper_bound_thin(1, index) = prctile(column_thin, 95);

        column_med = sampled_med(:, index);
        lower_bound_med(1, index) = prctile(column_med, 2.5);
        upper_bound_med(1, index) = prctile(column_med, 95);

        column_thick = sampled_thick(:, index);
        lower_bound_thick(1, index) = prctile(column_thick, 2.5);
        upper_bound_thick(1, index) = prctile(column_thick, 95);
    end

end