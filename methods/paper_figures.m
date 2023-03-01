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

    figure;
    tcl = tiledlayout(9,8);
    % Cluster Volume plot
    nexttile(1, [1 7]);
    if strcmp(Effect_direction, "positive")
        cluster_prob = {stat.posclusters(:).prob};
        cluster = stat.posclusterslabelmat;
        p_vals = [stat.posclusters.prob];
    else
        cluster_prob = {stat.negclusters(:).prob};
        cluster = stat.negclusterslabelmat;
        p_vals = [stat.negclusters.prob];
    end

    
    x = stat.time;
    vol = numel(stat.label);
    plotted_clust = [];

    for index = 1:numel(cluster_prob)

        if cluster_prob{index} < 0.25 % plots clusters that are tending towards significance

            for jndex = 1:numel(x)
                plotted_clust(index, jndex) = sum(cluster(:, jndex) == index) / vol; % sums the column looking for cluster and then divides the occurences for % volume
            end

        end

    end

    hold on;
    xlim([start_time, end_time]);
    ymax = max(plotted_clust, [], 'all') + 0.2;

    if isempty(ymax)
        ymax = 0.5;
    end

    ylim([0, ymax]);
    xlabel('Time (S)');
    ylabel('Volume');
    
    cluster_leg = strings([1, size(plotted_clust, 1)]);

    for index = 1:size(plotted_clust, 1)
        y = plotted_clust(index, :);
        area(x, y);
        cluster_leg(index) = strcat("Cluster ", string(index), " p = ", string(round(p_vals(index) * 10000)/10000))
    end

    legend(cluster_leg);
    grid on;
    hold off;
    % Significant Electrode Plot
    nexttile(8, [1, 1]);
    peak_electrode = compute_best_electrode(stat, Effect_direction, 1).electrode;
    elecs = zeros(size(stat.elec.chanpos,1), 1);
    e_idx = find(contains(stat.label,peak_electrode));
    elecs(e_idx)=1;
    cfg = [];
    cfg.parameter = 'stat';
    cfg.zlim = [-5, 5];
    cg.colorbar = 'yes';
    cfg.marker = 'off';
    cfg.markersize = 1;
    cfg.highlight = 'on';
    cfg.highlightchannel = find(elecs);
    cfg.highlightcolor = {'r', [0 0 1]};
    cfg.highlightsize = 10;
    cfg.comment = 'no';
    cfg.style = 'blank';
    
    ft_topoplotER(cfg, stat);
    set(gca,'XColor', 'none','YColor','none')
    b = gca; legend(b,'off');
 
    % Add Topomap plot
    nexttile(9,[1,1]);
    
    

    if contains(figname, 'Onsets 2-8') || contains(figname, 'Onset 1') || contains(figname, 'Partition 1')
    elseif contains(figname, 'Partitions')
    elseif contains(figname, 'Onsets 2,3 vs 4,5 vs 6,7')
    elseif contains(figname, 'Partitions vs Onsets')
    end

end

