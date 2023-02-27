function plot = plot_partitions_erp(dataone, datatwo, datathree, electrode, design2, factor, results, start, endtime, cis, paper_plot)

    [low1, high1] = median_split(dataone, 1, design2);
    [low2, high2] = median_split(datatwo, 1, design2);
    [low3, high3] = median_split(datathree, 1, design2);


    [highl, lowl] = ylimit_finder(high1,electrode);
    ylimit = [lowl,highl];
    %start = 2.8;
    f1 = figure;


    if contains(factor,"onsets-23-45-67")
            legend1 = ["Onsets 2,3 PGI", "Onsets 4,5 PGI", "Onsets 6,7 PGI", "", "", ""];
            legend2 = ["Onsets 2,3 Med", "Onsets 4,5 Med", "Onsets 6,7 Med", "", "", ""];

            title1 = 'Onsets 2,3';
            title2 = 'Onsets 4,5';
            title3 = 'Onsets 6,7';
            title4 = 'onsets';
    else
            legend1 = ["Partition 1 PGI", "Partition 2 PGI", "Partition 3 PGI", "", "", ""];
            legend2 = ["Partition 1 Med", "Partition 2 Med", "Partition 3 Med", "", "", ""];

            title1 = 'Partition 1';
            title2 = 'Partition 2';
            title3 = 'Partition 3';
            title4 = 'Partitions';
    end



    % First subplot low PGI across partitions
    Ax = subplot(5, 2, 1);
    data = partitions_combine(low1.data, low2.data, low3.data, "PGI");
    generate_erp_plot(results, start, endtime, data, electrode, "none", false, "positive");
    h = get(gca, 'Children');
    h(8).Color = [0.8350 0.0780 0.1840];
    h(7).Color = [0.4660 0.8740 0.1880];
    h(6).Color = [0.3010 0.7450 0.9330];
    delete(h(2));
    delete(h(3));
    delete(h(4));
    ylim(ylimit);
 
     
    hold on;
    legend(legend1, 'location', 'eastoutside');
    tit = strcat("Low Group PGI through ", title4, " @ ", electrode.electrode);
    title(tit);

    Ax = subplot(5, 2, 2);
    data = partitions_combine(high1.data, high2.data, high3.data, "PGI");
    generate_erp_plot(results, start, endtime, data, electrode, "none", false, "positive");
    h = get(gca, 'Children');
    h(8).Color = [0.8350 0.0780 0.1840];
    h(7).Color = [0.4660 0.8740 0.1880];
    h(6).Color = [0.3010 0.7450 0.9330];
    delete(h(2));
    delete(h(3));
    delete(h(4));
    ylim(ylimit);
 
     
    hold on;
    legend('hide');
    tit = strcat("High Group PGI through ", title4, " @ ", electrode.electrode);
    title(tit);

    Ax = subplot(5, 2, 3);
    data = partitions_combine(low1.data, low2.data, low3.data, "med");
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
 
     
    hold on;
    legend(legend2, 'location', 'eastoutside');
    tit = strcat("Low Group Medium through ", title4, " @ ", electrode.electrode);
    subtitle("");
    title(tit);

    Ax = subplot(5, 2, 4);
    data = partitions_combine(high1.data, high2.data, high3.data, "med");
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
 
     
    hold on;
    legend('hide');
    tit = strcat("High Group Medium through ", title4, " @ ", electrode.electrode);
    subtitle("");
    title(tit);

    Ax = subplot(5, 2, 5);
    generate_erp_plot(results, start, endtime, low1.data, electrode, "none", cis, "positive");
    h = get(gca, 'Children');
    delete(h(4));
    delete(h(5));
    delete(h(6));
    delete(h(7));
    ylim(ylimit);
 
     
    hold on;
    tit = strcat("Low ", title1, " ERP @ ", electrode.electrode);
    subtitle("");
    legend('location', 'eastoutside');
    title(tit);

    Ax = subplot(5, 2, 6);
    generate_erp_plot(results, start, endtime, high1.data, electrode, "none", cis, "positive");
    h = get(gca, 'Children');
    delete(h(4));
    delete(h(5));
    delete(h(6));
    delete(h(7));
    ylim(ylimit);
 
     
    hold on;
    tit = strcat("High ", title1, " ERP @ ", electrode.electrode);
    subtitle("");
    legend('hide')
    title(tit);

    Ax = subplot(5, 2, 7);
    generate_erp_plot(results, start, endtime, low2.data, electrode, "none", cis, "positive");
    h = get(gca, 'Children');
    delete(h(4));
    delete(h(5));
    delete(h(6));
    delete(h(7));
    ylim(ylimit);
 
     
    hold on;
    tit = strcat("Low ", title2, " ERP @ ", electrode.electrode);
    legend('location', 'eastoutside');
    subtitle("");
    title(tit);

    Ax = subplot(5, 2, 8);
    generate_erp_plot(results, start, endtime, high2.data, electrode, "none", cis, "positive");
    h = get(gca, 'Children');
    delete(h(4));
    delete(h(5));
    delete(h(6));
    delete(h(7));
    ylim(ylimit);
 
     
    hold on;
    tit = strcat("High ", title2, " ERP @ ", electrode.electrode);
    subtitle("");
    legend('hide');
    title(tit);

    Ax = subplot(5, 2, 9);
    generate_erp_plot(results, start, endtime, low3.data, electrode, "none", cis, "positive");
    h = get(gca, 'Children');
    delete(h(4));
    delete(h(5));
    delete(h(6));
    delete(h(7));
    ylim(ylimit);
 
     
    hold on;
    tit = strcat("Low ", title3, " ERP @ ", electrode.electrode);
    legend('location', 'eastoutside');
    subtitle("");
    title(tit);

    Ax = subplot(5, 2, 10);
    generate_erp_plot(results, start, endtime, high3.data, electrode, "none", cis, "positive");
    h = get(gca, 'Children');
    delete(h(4));
    delete(h(5));
    delete(h(6));
    delete(h(7));
    ylim(ylimit);
 
     
    hold on;
    tit = strcat("High ", title3, " ERP @ ", electrode.electrode);
    subtitle("");
    legend('hide');
    title(tit);

    titles = strcat("Interactions through ", title4, " Low vs High group ", factor);
    %f1.Position = f1.Position + [0 -300 0 300];
     if ~paper_plot
        set(gcf, 'Position', [100, 100, 1300, 800]);
        %sgtitle(titles);
        name = strcat(results, "/partitions/", factor,electrode.electrode, '_erpcombined.png');
        saveas(gcf, name);
     end
    plot = gcf;
end