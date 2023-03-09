function plot = plot_topo_map(stat, start_time, end_time, polarity, factor, results, paper_plot)

    difference = linspace(start_time, end_time, 10); %amount of subplots in this

    if strcmp(polarity, "positive")
        clustermark = stat.posclusterslabelmat;
    else
        clustermark = stat.negclusterslabelmat;
    end

    clustermark(clustermark > 1) = 0;

    maxstat = round(max(max(stat.stat)));
    minstat = round(min(min(stat.stat)));

    %replacing nans with 0 to not break function
    stat.stat(isnan(stat.stat))=0;
    figure;
    set(gcf, 'Position',  [100, 100, 1400, 300]);

    tiledlayout(1,9)

    for i = 1:9

        %finding time window from the closest times in the series to the inputs
        lower = interp1(stat.time, 1:length(stat.time), difference(i), 'nearest');
        upper = interp1(stat.time, 1:length(stat.time), difference(i + 1), 'nearest');

        if isnan(upper)
            upper = length(stat.time);
        end

        if isnan(lower)
            lower = length(stat.time) - 1;
        end

        highlight = round(mean(clustermark(:, lower:upper), 2));
        highlight = stat.label(highlight == 1);

        nexttile;
        % cfg for plot
        cfg = [];
        cfg.xlim = [difference(i), difference(i + 1)];
        cfg.highlight = 'on';
        cfg.highlightchannel = highlight;
        cfg.highlightcolor = [1 0 0];
        cfg.highlightsymbolseries = ['*', '*', '.', '.', '.'];
        cfg.highlightsize = 8;
        cfg.contournum = 0;
        cfg.alpha = 0.05;
        %cfg.comment = 'xlim';
        cfg.parameter = 'stat';
        cfg.zlim = [-2 4];

        if i == 5
            cfg.colorbar = 'South'; % adds to every plot usually disabled, uness need figure with bar
        end

        cfg.parameter = 'stat';
        ft_topoplotER(cfg, stat);
        title(strcat(string(difference(i)), " - ", string(difference(i + 1)), "s"));

    end

    if contains(factor, "habituation") || contains(factor, "sensitization")

        if contains(factor, "visual")
            results_fact = "visual-stress";
            imgname = "visual-stress partitions topomap.png";
        elseif contains(factor, "headache")
            results_fact = "headache";
            imgname = "headache partitions topomap.png";
        elseif contains(factor, "discomfort")
            results_fact = "discomfort";
            imgname = "discomfort partitions topomap.png";
        else
            results_fact = "none";
            imgname = strcat("none partitions topomap.png");
        end

        imgname = strcat(string(start_time)," ", imgname);

    else
        results_fact = factor;
        imgname = strcat(factor, " ", string(start_time), " onsets topomap.png");
    end

    title_main = strcat("Topographic map of significant clusters ", results_fact);
    
    imgname = strcat(polarity, " ", imgname);
    if isfield(stat,"freq")
        freq = round(stat.freq);
        save_dir_full = strcat(results, "/", results_fact, "/",string(freq),"Hz ", imgname);
    else
        save_dir_full = strcat(results, "/", results_fact, "/", imgname);
    end

    
    plot = gcf;
    if ~paper_plot
        sgtitle(title_main);
        saveas(gcf, save_dir_full);
    end

    hold off;
end