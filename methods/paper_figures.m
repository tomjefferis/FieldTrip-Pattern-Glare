function paper_figures(data, stat, design, onsets_part, figname, start_time, end_time, cis, results)

    figname = paper_figure_name(figname, onsets_part, start_time, end_time);
    font_size = 18;

    % if data cells length greater than 40 split into 3 cells
    if length(data) > 40
        len = length(data);
        data1 = data(1:len/3);
        data2 = data(len/3+1:len/3*2);
        data3 = data(len/3*2+1:len);
    end

    % same for design
    if length(design) > 40
        len = length(design);
        design1 = design(1:len/3);
        design2 = design(len/3+1:len/3*2);
        design3 = design(len/3*2+1:len);
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
    set(findall(gcf,'-property','FontSize'),'FontSize',font_size);
    Cluster_vol = print('-RGBImage');
    Topomap = plot_topo_map(stat, start_time, end_time, Effect_direction, factor, '', true);
    set(findall(gcf,'-property','FontSize'),'FontSize',font_size);
    Topomap = print('-RGBImage');
    Elec_View = plot_peak_electrode(stat, electrode, '', true);
    %set(findall(gcf,'-property','FontSize'),'FontSize',font_size);
    Elec_View = print('-RGBImage');

    if contains(onsets_part, 'onsets') || contains(onsets_part, 'onset 1') || contains(onsets_part, 'Partition 1')

        if ~contains(factor, 'none')
            [low, high] = median_split(data, 1, design);
            erpplot = plot_medium_split(high, low, electrode, factor, start_time, end_time, cis, '', true);
            set(findall(gcf,'-property','FontSize'),'FontSize',font_size);
            erpplot = print('-RGBImage');
        else
            %subplots of pgi and erp
            erpplot = generate_erp_plot('', start_time, end_time, data, electrode, factor, cis, Effect_direction, true);
            erpplot = print('-RGBImage');
            pgiplot = generate_erp_pgi('', start_time, end_time, data, electrode, factor, cis, Effect_direction, true);
            pgiplot = print('-RGBImage');
            erpplot = imstacker({erpplot, pgiplot}, 'dim', 1, 'padding', [255, 255, 255], 'gravity', 'center');
        end

    elseif contains(onsets_part, 'partitions')

        if ~contains(factor, 'none')
            erpplot = plot_partitions_erp(data1, data2, data3, electrode, design, factor, '', start_time, end_time, cis, true);
            set(findall(gcf,'-property','FontSize'),'FontSize',font_size);
            erpplot = print('-RGBImage');
        else
            erpplot = plot_partitions_regressor(data1, data2, data3, electrode, design, factor, '', start_time, end_time, cis, true);
            set(findall(gcf,'-property','FontSize'),'FontSize',font_size);
            erpplot = print('-RGBImage');
        end

    elseif contains(onsets_part, 'onsets-2,3-4,5-6,7')

        if ~contains(factor, 'none')
            erpplot = plot_partitions_erp(data1, data2, data3, electrode, design, factor, '', start_time, end_time, cis, true);
            set(findall(gcf,'-property','FontSize'),'FontSize',font_size);
            erpplot = print('-RGBImage');
        else
            erpplot = plot_partitions_regressor(data1, data2, data3, electrode, design, factor, '', start_time, end_time, cis, true);
            set(findall(gcf,'-property','FontSize'),'FontSize',font_size);
            erpplot = print('-RGBImage');
        end

    elseif contains(onsets_part, 'partitions-vs-onsets')
        erpplot = plot_three_way(data1, data2, data3, electrode, design, factor, '', start_time, end_time, cis, true);
        set(findall(gcf,'-property','FontSize'),'FontSize',font_size);
        erpplot = print('-RGBImage');
    end

    im1 = {Cluster_vol, Elec_View};
    outpict = imstacker(im1, 'dim', 2, 'padding', [255, 255, 255], 'gravity', 'center');
    images = {outpict, Topomap, erpplot};

    % Define the annotation text and spacing
    text_str = {'a)', 'b)', 'c)'};
    text_pos = [50, 250; 50, 850; 50, 1400];
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
    save = strcat(figname,".png");
    saveas(gcf, save, 'png');

end
