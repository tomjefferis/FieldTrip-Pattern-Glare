function paper_figures(data, stat, design, figname, start_time, end_time)
    figname = paper_figure_name(figname);

    factor = figname;
    Effect_direction = '';

    try
        Negative_Cluster = stat.negclusters.prob;
    catch
        Negative_Cluster = 1;
    end

    try
        Positive_Cluster = stat.posclusters.prob;
    catch
        Positive_Cluster = 1;
    end

    if Positive_Cluster > Negative_Cluster
        Effect_direction = 'negative';
    else
        Effect_direction = 'positive';
    end

    Cluster_vol = plot_cluster_vol(stat, factor, start_time, end_time, Effect_direction, '', true);
    
    Topomap = plot_topo_map(stat, start_time, end_time, Effect_direction, factor, '', true);
    Workspace_Image2 = print('-RGBImage');

    
    
    Elec_View = plot_peak_electrode(stat, compute_best_electrode(stat, Effect_direction), '', true);

    

    if contains(figname, 'Onsets 2-8') || contains(figname, 'Onset 1') || contains(figname, 'Partition 1')
    elseif contains(figname, 'Partitions')
    elseif contains(figname, 'Onsets 2,3 vs 4,5 vs 6,7')
    elseif contains(figname, 'Partitions vs Onsets')
    end

end
