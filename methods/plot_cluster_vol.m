function plot_cluster_vol(stat, factor, start_time, end_time, polarity, save_dir)
    % looking at positive or negative clusters
    if strcmp(polarity, "positive")
        cluster_prob = {stat.posclusters(:).prob};
        cluster = stat.posclusterslabelmat;
        p_vals = [stat.posclusters.prob];
    else
        cluster_prob = {stat.negclusters(:).prob};
        cluster = stat.negclusterslabelmat;
        p_vals = [stat.negclusters.prob];
    end

    %sets the time of x axis
    clf;
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

    if contains(factor, "habituation") || contains(factor, "sensitization")

        if contains(factor, "visual")
            results_fact = "visual-stress";
            imgname = "visual stress partitions cluster volume.png";
        elseif contains(factor, "headache")
            results_fact = "headache";
            imgname = "headache partitions cluster volume.png";
        elseif contains(factor, "discomfort")
            results_fact = "discomfort";
            imgname = "discomfort partitions cluster volume.png";
        else
            results_fact = "none";
            imgname = strcat("none partitions cluster volume.png");
        end

        imgname = strcat(string(start_time)," ", imgname);

    else
        results_fact = factor;
        imgname = strcat(factor, " ", string(start_time), " onsets cluster volume.png");
    end

    save_dir = strcat(save_dir, "/", results_fact, "/", polarity, " ", imgname);
    figure;
    hold on;
    xlim([start_time, end_time]);
    ymax = max(plotted_clust, [], 'all') + 0.2;

    if isempty(ymax)
        ymax = 0.5;
    end

    ylim([0, ymax]);
    xlabel('Time (S)');
    ylabel('Volume');
    title(strcat(polarity, " clusters as % volume"));
    cluster_leg = strings([1, size(plotted_clust, 1)]);

    for index = 1:size(plotted_clust, 1)
        y = plotted_clust(index, :);
        area(x, y);
        cluster_leg(index) = strcat("Cluster ", string(index), " p = ", string(round(p_vals(index) * 10000)/10000))
    end

    legend(cluster_leg);
    set(gcf, 'Position', [100, 100, 800, 350]);
    grid on;
    saveas(gcf, save_dir);
    hold off;

end