function freq_power_median_split(data, order, design_matrix, elec, frequency_range, time, factor, save_dir)

    [low, high] = median_split(data, order, design_matrix);

    low = average_power(low.data, frequency_range);
    high = average_power(high.data, frequency_range);
    
    plot_median_split_power(low, high,elec, time,factor, save_dir);
end