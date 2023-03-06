function paper_figures(data, stat, design, onsets_part, figname, start_time, end_time, results)
    figname = paper_figure_name(figname, onsets_part);

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
    


    
    
    if contains(onsets_part, 'onsets') || contains(onsets_part, 'onset 1') || contains(onsets_part, 'Partition 1')
        if ~contains(factor,'none')
            [low, high] = median_split(data, 1, design);
            erpplot = plot_medium_split(high, low, electrode, factor, start_time, end_time, true, '',true);
            erpplot = print('-RGBImage');
        else
            %subplots of pgi and erp
        end
    elseif contains(onsets_part, 'Partitions')
    elseif contains(onsets_part, 'Onsets 2,3 vs 4,5 vs 6,7')
    elseif contains(onsets_part, 'Partitions vs Onsets')
    end
    
    im1 = {Cluster_vol,Elec_View};
    outpict = imstacker(im1,'dim',2,'padding',[255,255,255],'gravity','center');

    images = {outpict,Topomap,erpplot};

    outpict = imstacker(images,'dim',1,'padding',[255,255,255],'gravity','center');
    figure;
    imshow(outpict)

end
