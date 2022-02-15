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