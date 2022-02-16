function plot_partitions_regressor(dataone, datatwo, datathree, electrode, design2, factor, results, start, endtime, cis)
    % partitions plot 5x2 grid
    ylimit = ylimit_finder([dataone,datatwo,datathree],electrode);
    start = 2.8;
    f1 = figure;

    % First subplot low PGI across partitions
    Ax = subplot(5, 1, 1);
    data = partitions_combine(dataone, datatwo, datathree, "PGI");
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
    legend("P1 PGI", "P2 PGI", "P3 PGI", "", "", "", 'location', 'northwest');
    tit = strcat("Partitions regressor PGI through partitions @ ", electrode.electrode);
    title(tit);

    Ax = subplot(5, 1, 2);
    data = partitions_combine(dataone, datatwo, datathree, "med");
    generate_erp_plot(results, start, endtime, data, electrode, "none", false, "positive");
    h = get(gca, 'Children');
    h(8).Color = 'r';
    h(7).Color = 'g';
    h(6).Color = 'b';
    delete(h(1));
    delete(h(2));
    delete(h(3));
    delete(h(4));
    ylim(ylimit);
    PosVec = Ax.Position;
    Ax.Position = PosVec + [0 -0.02 0 0.02];
    hold on;
    legend("P1 Med", "P2 Med", "P3 Med", "", "", "", 'location', 'northwest');
    tit = strcat("Low Group Medium through partitions @ ", electrode.electrode);
    subtitle("");
    title(tit);

    Ax = subplot(5, 1, 3);
    generate_erp_plot(results, start, endtime, dataone, electrode, "none", cis, "positive");
    h = get(gca, 'Children');
    delete(h(4));
    delete(h(5));
    delete(h(6));
    delete(h(7));
    ylim(ylimit);
    PosVec = Ax.Position;
    Ax.Position = PosVec + [0 -0.02 0 0.02];
    hold on;
    tit = strcat("Partition 1 @ ", electrode.electrode);
    subtitle("");
    title(tit);

    Ax = subplot(5, 1, 4);
    generate_erp_plot(results, start, endtime, datatwo, electrode, "none", cis, "positive");
    h = get(gca, 'Children');
    delete(h(4));
    delete(h(5));
    delete(h(6));
    delete(h(7));
    ylim(ylimit);
    PosVec = Ax.Position;
    Ax.Position = PosVec + [0 -0.02 0 0.02];
    hold on;
    tit = strcat("Partition 2 @ ", electrode.electrode);
    subtitle("");
    title(tit);

    Ax = subplot(5, 1, 5);
    generate_erp_plot(results, start, endtime, datathree, electrode, "none", cis, "positive");
    h = get(gca, 'Children');
    delete(h(4));
    delete(h(5));
    delete(h(6));
    delete(h(7));
    ylim(ylimit);
    PosVec = Ax.Position;
    Ax.Position = PosVec + [0 -0.02 0 0.02];
    hold on;
    tit = strcat("Partition 3 @ ", electrode.electrode);
    subtitle("");
    title(tit);

    titles = strcat("Interactions through partitions Partitions regressor");
    f1.Position = f1.Position + [0 -300 0 300];
    %sgtitle(titles);
    name = strcat(results, "/partitions/", factor, ' preg_erpcombined.png');
    saveas(gcf, name);
end