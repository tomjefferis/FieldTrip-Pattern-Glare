function plots = freq_power_median_split(data, order, design_matrix, elec, frequency_range, time, factor, save_dir, paper_plot, font_size)

    [low, high] = median_split(data, order, design_matrix);

    low = average_power(low.data, frequency_range);
    high = average_power(high.data, frequency_range);
    
    plots = plot_median_split_power(low, high,elec, time,factor, save_dir,paper_plot, font_size);
end