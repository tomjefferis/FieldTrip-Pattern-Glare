function paper_figures(data, stat, design, onsets_part, figname, start_time, end_time, results)

    figname = paper_figure_name(figname, onsets_part, start_time, end_time);

    % if data is struct assign each element to a variable
    if isstruct(data)
        data1 = data.one;
        data2 = data.two;
        data3 = data.three;
    end

    if isstruct(design)
        design1 = design.one;
        design = design.two;
        design3 = design.three;
    end

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
    Elec_View = plot_peak_electrode(stat, electrode, '', true);
    Elec_View = print('-RGBImage');

    if contains(onsets_part, 'onsets') || contains(onsets_part, 'onset 1') || contains(onsets_part, 'Partition 1')

        if ~contains(factor, 'none')
            [low, high] = median_split(data, 1, design);
            erpplot = plot_medium_split(high, low, electrode, factor, start_time, end_time, true, '', true);
            erpplot = print('-RGBImage');
        else
            %subplots of pgi and erp
            erpplot = generate_erp_plot('', start_time, end_time, data, electrode, factor, true, Effect_direction, true);
            erpplot = print('-RGBImage');
            pgiplot = generate_erp_pgi('', start_time, end_time, data, electrode, factor, true, Effect_direction, true);
            pgiplot = print('-RGBImage');
            erpplot = imstacker({erpplot, pgiplot}, 'dim', 1, 'padding', [255, 255, 255], 'gravity', 'center');
        end

    elseif contains(onsets_part, 'Partitions')

        if ~contains(factor, 'none')
            erpplot = plot_partitions_erp(data1, data2, data3, electrode, design, factor, '', start_time, end_time, true, true);
            erpplot = print('-RGBImage');
        else
            erpplot = plot_partitions_regressor(data1, data2, data3, electrode, design, factor, '', start_time, end_time, true, true);
            erpplot = print('-RGBImage');
        end

    elseif contains(onsets_part, 'Onsets 2,3 vs 4,5 vs 6,7')

        if ~contains(factor, 'none')
            erpplot = plot_partitions_erp(data1, data2, data3, electrode, design, factor, '', start_time, end_time, true, true);
            erpplot = print('-RGBImage');
        else
            erpplot = plot_partitions_regressor(data1, data2, data3, electrode, design, factor, '', start_time, end_time, true, true);
            erpplot = print('-RGBImage');
        end

    elseif contains(onsets_part, 'Partitions vs Onsets')
        erpplot = plot_three_way(data1, data2, data3, electrode, design, factor, '', start_time, end_time, true, true);
        erpplot = print('-RGBImage');
    end

    im1 = {Cluster_vol, Elec_View};
    outpict = imstacker(im1, 'dim', 2, 'padding', [255, 255, 255], 'gravity', 'center');
    images = {outpict, Topomap, erpplot};

    % Define the annotation text and spacing
    text_str = {'a)', 'b)', 'c)'};
    text_pos = [0.02, 0.1; 0.02, 0.3; 0.02, 0.6];
    text_gap = [0.1; 0.1; 0.2];

    outpict = imstacker(images, 'dim', 1, 'padding', [255, 255, 255], 'gravity', 'center');
    figure;
    imshow(outpict);
    % Add the annotations to the image
    for i = 1:numel(text_str)
        % Calculate the x and y positions for the annotation text
        x_pos = text_pos(i, 1);
        y_pos = text_pos(i, 2) + (i - 1) * text_gap(i);

        % Add the text to the image
        text(x_pos, y_pos, text_str{i}, 'FontSize', 14);
    end

    %set figure title and font size to 14
    set(gca, 'FontSize', 14);
    title(figname);

    %save figure to results folder named after the figure
    cd (results + "/figures");
    saveas(gcf, figname, 'png');

end
