function plot_three_way(dataone, datatwo, datathree, electrode, design2, factor, results, start, endtime, cis)

    %splitting design matrix into each batch of onsets
    design2 = reshape(design2, 3, []);
    design2 = design2(2, :);
    % splitting data the same way
    dataone = reshape(dataone, 3, []);
    datatwo = reshape(datatwo, 3, []);
    datathree = reshape(datathree, 3, []);

    %p1
    [low11, high11] = median_split(dataone(1, :), 1, design2);
    [low12, high12] = median_split(dataone(2, :), 1, design2);
    [low13, high13] = median_split(dataone(3, :), 1, design2);

    %p2
    [low21, high21] = median_split(datatwo(1, :), 1, design2);
    [low22, high22] = median_split(datatwo(2, :), 1, design2);
    [low23, high23] = median_split(datatwo(3, :), 1, design2);

    %p3
    [low31, high31] = median_split(datathree(1, :), 1, design2);
    [low32, high32] = median_split(datathree(2, :), 1, design2);
    [low33, high33] = median_split(datathree(3, :), 1, design2);

    [highl, lowl] = ylimit_finder(high21, electrode);

    if(highl > 5) && (lowl < -5)
        highl = 7;
        lowl = -7;
    elseif (highl > 5)
        highl = 7;
    elseif (lowl < -5)
        lowl = -7;
    end

    ylimit = [lowl, highl];
    %start = 2.8;
    f1 = figure;


    % First subplot low PGI across P1 onsets
    Ax = subplot(6, 2, 1);
    data = partitions_combine(low11.data, low12.data, low13.data, "PGI");
    generate_erp_plot(results, start, endtime, data, electrode, "none", false, "positive");
    h = get(gca, 'Children');
    h(8).Color = [0.8350 0.0780 0.1840];
    h(7).Color = [0.4660 0.8740 0.1880];
    h(6).Color = [0.3010 0.7450 0.9330];
    delete(h(2));
    delete(h(3));
    delete(h(4));
    ylim(ylimit);
    PosVec = Ax.Position;
    Ax.Position = PosVec + [0 -0.02 0 0.02];
    hold on;
    legend("Onsets 2,3","Onsets 4,5","Onsets 6,7", 'location', 'eastoutside');
    tit = strcat("Low Group Partition 1 PGI ", " @ ", electrode.electrode);
    title(tit);
    subtitle("");



    % First subplot low PGI across P1 onsets
    Ax = subplot(6, 2, 2);
    data = partitions_combine(high11.data, high12.data, high13.data, "PGI");
    generate_erp_plot(results, start, endtime, data, electrode, "none", false, "positive");
    h = get(gca, 'Children');
    h(8).Color = [0.8350 0.0780 0.1840];
    h(7).Color = [0.4660 0.8740 0.1880];
    h(6).Color = [0.3010 0.7450 0.9330];
    delete(h(2));
    delete(h(3));
    delete(h(4));
    ylim(ylimit);
    PosVec = Ax.Position;
    Ax.Position = PosVec + [0 -0.02 0 0.02];
    hold on;
    legend("Onsets 2,3","Onsets 4,5","Onsets 6,7", 'location', 'eastoutside');
    tit = strcat("High Group Partition 1 PGI ", " @ ", electrode.electrode);
    title(tit);
    subtitle("");

        % First subplot low PGI across P1 onsets
    Ax = subplot(6, 2, 3);
    data = partitions_combine(low11.data, low12.data, low13.data, "med");
    generate_erp_plot(results, start, endtime, data, electrode, "none", false, "positive");
    h = get(gca, 'Children');
    h(8).Color = 'r';
    h(7).Color = 'g';
    h(6).Color = 'b';
    delete(h(2));
    delete(h(3));
    delete(h(4));
    ylim(ylimit);
    PosVec = Ax.Position;
    Ax.Position = PosVec + [0 -0.02 0 0.02];
    hold on;
    legend("Onsets 2,3","Onsets 4,5","Onsets 6,7", 'location', 'eastoutside');
    tit = strcat("Low Group Partition 1 Med ", " @ ", electrode.electrode);
    title(tit);
    subtitle("");



    % First subplot low PGI across P1 onsets
    Ax = subplot(6, 2, 4);
    data = partitions_combine(high11.data, high12.data, high13.data, "med");
    generate_erp_plot(results, start, endtime, data, electrode, "none", false, "positive");
    h = get(gca, 'Children');
    h(8).Color = 'r';
    h(7).Color = 'g';
    h(6).Color = 'b';
    delete(h(2));
    delete(h(3));
    delete(h(4));
    ylim(ylimit);
    PosVec = Ax.Position;
    Ax.Position = PosVec + [0 -0.02 0 0.02];
    hold on;
    legend("Onsets 2,3","Onsets 4,5","Onsets 6,7", 'location', 'eastoutside');
    tit = strcat("High Group Partition 1 Med ", " @ ", electrode.electrode);
    title(tit);
    subtitle("");

    %% First subplot low PGI across P2 onsets
    Ax = subplot(6, 2, 5);
    data = partitions_combine(low21.data, low22.data, low23.data, "PGI");
    generate_erp_plot(results, start, endtime, data, electrode, "none", false, "positive");
    h = get(gca, 'Children');
    h(8).Color = [0.8350 0.0780 0.1840];
    h(7).Color = [0.4660 0.8740 0.1880];
    h(6).Color = [0.3010 0.7450 0.9330];
    delete(h(2));
    delete(h(3));
    delete(h(4));
    ylim(ylimit);
    PosVec = Ax.Position;
    Ax.Position = PosVec + [0 -0.02 0 0.02];
    hold on;
    legend("Onsets 2,3","Onsets 4,5","Onsets 6,7", 'location', 'eastoutside');
    tit = strcat("Low Group Partition 2 PGI ", " @ ", electrode.electrode);
    title(tit);
    subtitle("");



    % First subplot low PGI across P1 onsets
    Ax = subplot(6, 2, 6);
    data = partitions_combine(high21.data, high22.data, high23.data, "PGI");
    generate_erp_plot(results, start, endtime, data, electrode, "none", false, "positive");
    h = get(gca, 'Children');
    h(8).Color = [0.8350 0.0780 0.1840];
    h(7).Color = [0.4660 0.8740 0.1880];
    h(6).Color = [0.3010 0.7450 0.9330];
    delete(h(2));
    delete(h(3));
    delete(h(4));
    ylim(ylimit);
    PosVec = Ax.Position;
    Ax.Position = PosVec + [0 -0.02 0 0.02];
    hold on;
    legend("Onsets 2,3","Onsets 4,5","Onsets 6,7", 'location', 'eastoutside');
    tit = strcat("High Group Partition 2 PGI ", " @ ", electrode.electrode);
    title(tit);
    subtitle("");

        % First subplot low PGI across P1 onsets
    Ax = subplot(6, 2, 7);
    data = partitions_combine(low21.data, low22.data, low23.data, "med");
    generate_erp_plot(results, start, endtime, data, electrode, "none", false, "positive");
    h = get(gca, 'Children');
    h(8).Color = 'r';
    h(7).Color = 'g';
    h(6).Color = 'b';
    delete(h(2));
    delete(h(3));
    delete(h(4));
    ylim(ylimit);
    PosVec = Ax.Position;
    Ax.Position = PosVec + [0 -0.02 0 0.02];
    hold on;
    legend("Onsets 2,3","Onsets 4,5","Onsets 6,7", 'location', 'eastoutside');
    tit = strcat("Low Group Partition 2 Med ", " @ ", electrode.electrode);
    title(tit);
    subtitle("");



    % First subplot low PGI across P1 onsets
    Ax = subplot(6, 2, 8);
    data = partitions_combine(high21.data, high22.data, high23.data, "med");
    generate_erp_plot(results, start, endtime, data, electrode, "none", false, "positive");
    h = get(gca, 'Children');
    h(8).Color = 'r';
    h(7).Color = 'g';
    h(6).Color = 'b';
    delete(h(2));
    delete(h(3));
    delete(h(4));
    ylim(ylimit);
    PosVec = Ax.Position;
    Ax.Position = PosVec + [0 -0.02 0 0.02];
    hold on;
    legend("Onsets 2,3","Onsets 4,5","Onsets 6,7", 'location', 'eastoutside');
    tit = strcat("High Group Partition 2 Med ", " @ ", electrode.electrode);
    title(tit);
    subtitle("");

    %%P3
        % First subplot low PGI across P1 onsets
    Ax = subplot(6, 2, 9);
    data = partitions_combine(low31.data, low32.data, low33.data, "PGI");
    generate_erp_plot(results, start, endtime, data, electrode, "none", false, "positive");
    h = get(gca, 'Children');
    h(8).Color = [0.8350 0.0780 0.1840];
    h(7).Color = [0.4660 0.8740 0.1880];
    h(6).Color = [0.3010 0.7450 0.9330];
    delete(h(2));
    delete(h(3));
    delete(h(4));
    ylim(ylimit);
    PosVec = Ax.Position;
    Ax.Position = PosVec + [0 -0.02 0 0.02];
    hold on;
    legend("Onsets 2,3","Onsets 4,5","Onsets 6,7", 'location', 'eastoutside');
    tit = strcat("Low Group Partition 3 PGI ", " @ ", electrode.electrode);
    title(tit);
    subtitle("");



    % First subplot low PGI across P1 onsets
    Ax = subplot(6, 2, 10);
    data = partitions_combine(high31.data, high32.data, high33.data, "PGI");
    generate_erp_plot(results, start, endtime, data, electrode, "none", false, "positive");
    h = get(gca, 'Children');
    h(8).Color = [0.8350 0.0780 0.1840];
    h(7).Color = [0.4660 0.8740 0.1880];
    h(6).Color = [0.3010 0.7450 0.9330];
    delete(h(2));
    delete(h(3));
    delete(h(4));
    ylim(ylimit);
    PosVec = Ax.Position;
    Ax.Position = PosVec + [0 -0.02 0 0.02];
    hold on;
    legend("Onsets 2,3","Onsets 4,5","Onsets 6,7", 'location', 'eastoutside');
    tit = strcat("High Group Partition 3 PGI ", " @ ", electrode.electrode);
    title(tit);
    subtitle("");

        % First subplot low PGI across P1 onsets
    Ax = subplot(6, 2, 11);
    data = partitions_combine(low31.data, low32.data, low33.data, "med");
    generate_erp_plot(results, start, endtime, data, electrode, "none", false, "positive");
    h = get(gca, 'Children');
    h(8).Color = 'r';
    h(7).Color = 'g';
    h(6).Color = 'b';
    delete(h(2));
    delete(h(3));
    delete(h(4));
    ylim(ylimit);
    PosVec = Ax.Position;
    Ax.Position = PosVec + [0 -0.02 0 0.02];
    hold on;
    legend("Onsets 2,3","Onsets 4,5","Onsets 6,7", 'location', 'eastoutside');
    tit = strcat("Low Group Partiton 3 Med ", " @ ", electrode.electrode);
    title(tit);
    subtitle("");



    % First subplot low PGI across P1 onsets
    Ax = subplot(6, 2, 12);
    data = partitions_combine(high31.data, high32.data, high33.data, "med");
    generate_erp_plot(results, start, endtime, data, electrode, "none", false, "positive");
    h = get(gca, 'Children');
    h(8).Color = 'r';
    h(7).Color = 'g';
    h(6).Color = 'b';
    delete(h(2));
    delete(h(3));
    delete(h(4));
    ylim(ylimit);
    PosVec = Ax.Position;
    Ax.Position = PosVec + [0 -0.02 0 0.02];
    hold on;
    legend("Onsets 2,3","Onsets 4,5","Onsets 6,7", 'location', 'eastoutside');
    tit = strcat("High Group Partition 3 Med ", " @ ", electrode.electrode);
    title(tit);
    subtitle("");

   

    titles = strcat("Interactions through Partitions vs Onsets, Low vs High group ", factor);
    f1.Position = f1.Position + [0 -300 0 300];
    %sgtitle(titles);
    name = strcat(results, "/partitions/", factor, electrode.electrode, '_erpcombined.png');
    saveas(gcf, name);
end
