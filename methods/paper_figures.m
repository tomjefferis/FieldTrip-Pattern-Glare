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

    electrode = compute_best_electrode(stat, Effect_direction);
    cd (results + '\workspace')
    Cluster_vol = plot_cluster_vol(stat, factor, start_time, end_time, Effect_direction, '', true);
    Cluster_vol = print('-RGBImage');
    Topomap = plot_topo_map(stat, start_time, end_time, Effect_direction, factor, '', true);
    Topomap = print('-RGBImage');
    Elec_View = plot_peak_electrode(stat,electrode , '', true);
    Elec_View = print('-RGBImage');
    


    
    erpplot = [];
    if contains(figname, 'Onsets 2-8') || contains(figname, 'Onset 1') || contains(figname, 'Partition 1')
        if ~contains(factor,'none')
            [low, high] = median_split(data, 1, design);
            erpplot = plot_medium_split(high, low, electrode, factor, start_time, end_time, 'true', results_dir);
        else
            %subplots of pgi and erp
        end
    elseif contains(figname, 'Partitions')
    elseif contains(figname, 'Onsets 2,3 vs 4,5 vs 6,7')
    elseif contains(figname, 'Partitions vs Onsets')
    end

    images = {Cluster_vol,Topomap,erpplot};

    finage = imtile(images,'BorderSize', 10,'GridSize',{1,4});

end
