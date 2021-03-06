function tab = frequency_analysis(grand_avg_filename,single_trial_filename,grand_avg_partitions_filename,time_window,n_participants,baseline_period, ...
    aggregated_roi,max_windows,spatial_roi,posneg,stat_run,wavelet_width,frequency_range,clust_volume, topograpic_map_plot, ...
    plot_erps,median_split_plots,gfp_plot,plot_designs,plot_partitions_erps,generate_ci,factor_scores, ...
    onsets_part, type_of_effect, testing)
    

    time_freq = 'frequency';

    tab = pgi_analysis(grand_avg_filename,single_trial_filename,grand_avg_partitions_filename,time_window,n_participants,baseline_period, ...
    aggregated_roi,max_windows,spatial_roi,posneg,stat_run,wavelet_width,frequency_range,clust_volume, topograpic_map_plot, ...
    plot_erps,median_split_plots,gfp_plot,plot_designs,plot_partitions_erps,generate_ci,time_freq,factor_scores, ...
    onsets_part, type_of_effect, testing);

end
