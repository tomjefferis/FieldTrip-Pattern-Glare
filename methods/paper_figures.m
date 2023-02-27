function paper_figures(data, stat, design, figname)
    figname = paper_figure_name(figname);

    Cluster_vol;
    Topomap;
    ERP;

    if contains(figname, 'Onsets 2-8') || contains(figname, 'Onset 1') || contains(figname, 'Partition 1')
        Cluster_vol = 
    elseif contains(figname, 'Partitions')
    elseif contains(figname, 'Onsets 2,3 vs 4,5 vs 6,7')
    elseif contains(figname, 'Partitions vs Onsets')
    end

end


