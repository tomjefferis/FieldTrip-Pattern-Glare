function [lower_bound, upper_bound] = generate_cis_pgi(data, electrode, samples)

    data = get_timeseries_data_electrode(data, electrode);

    avg_samples = 4000;
    %samples = 40;

    sampled_data = [];

    lower_bound = [];
    upper_bound = [];

    for jndex = 1:avg_samples

        samples_tk = datasample(data, samples);

        sampled_data(jndex, :) = get_data_mean(samples_tk);

    end

    [Num_Rows, Num_Cols] = size(sampled_data);

    for index = 1:Num_Cols
        column_data = sampled_data(:, index);
        lower_bound(1, index) = prctile(column_data, 2.5);
        upper_bound(1, index) = prctile(column_data, 95);
    end

end