function plot = plot_partitions_regressor(dataone, datatwo, datathree, electrode, design2, factor, results, start, endtime, cis, paper_plot)
    % partitions plot 5x2 grid
    [high,low] = ylimit_finder([dataone,datatwo,datathree],electrode);

     if contains(factor,"onsets")|| contains(factor,"Onsets")
            legend1 = ["Onsets 2,3 PGI", "Onsets 4,5 PGI", "Onsets 6,7 PGI", "", "Max Effect", ""];
            legend2 = ["Onsets 2,3 Med", "Onsets 4,5 Med", "Onsets 6,7 Med", "", "Max Effect", ""];

            title1 = 'Onsets 2,3';
            title2 = 'Onsets 4,5';
            title3 = 'Onsets 6,7';
            title4 = 'onsets';
    else
            legend1 = ["Partition 1 PGI", "Partition 2 PGI", "Partition 3 PGI", "", "Max Effect", ""];
            legend2 = ["Partition 1 Med", "Partition 2 Med", "Partition 3 Med", "", "Max Effect", ""];

            title1 = 'Partition 1';
            title2 = 'Partition 2';
            title3 = 'Partition 3';
            title4 = 'Partitions';
     end

    
    f1 = figure;

    tiledlayout(3,2);

    % First subplot low PGI across partitions
    ax1 = nexttile
    data = partitions_combine(dataone, datatwo, datathree, "PGI");
    generate_erp_plot(results, start, endtime, data, electrode, "none", false, "positive", paper_plot);
    h = get(gca, 'Children');
    h(10).Color = [0.8350 0.0780 0.1840];
    h(9).Color = [0.4660 0.8740 0.1880];
    h(8).Color = [0.3010 0.7450 0.9330];
   
    hold on;
    legend("P1 PGI", "P2 PGI", "P3 PGI", "", "", "", 'location', 'northeastoutside');
    tit = strcat("");
    title(tit);
    subtitle("");
    ylabel(strcat("Partitions PGI"),"Rotation",0,'HorizontalAlignment','right','fontweight','bold');

    ax5 = nexttile
    generate_erp_plot(results, start, endtime, dataone, electrode, "none", cis, "positive", paper_plot);
    h = get(gca, 'Children');
   
    hold on;
    legend('location', 'northeastoutside');
    tit = strcat("");
    title(tit);
    subtitle("");
    ylabel(strcat("Partition 1"),"Rotation",0,'HorizontalAlignment','right','fontweight','bold');


    ax3 = nexttile
    data = partitions_combine(dataone, datatwo, datathree, "med");
    generate_erp_plot(results, start, endtime, data, electrode, "none", false, "positive", paper_plot);
    h = get(gca, 'Children');
    h(10).Color = 'r';
    h(9).Color = 'g';
    h(8).Color = 'b';
   
    hold on;
    legend("P1 Med", "P2 Med", "P3 Med", "", "", "", 'location', 'northeastoutside');
    tit = strcat("");
    title(tit);
    subtitle("");
    ylabel(strcat("Partitions Med"),"Rotation",0,'HorizontalAlignment','right','fontweight','bold');

    ax2 = nexttile
    generate_erp_plot(results, start, endtime, datatwo, electrode, "none", cis, "positive", paper_plot);
    h = get(gca, 'Children');
   
    hold on;
    legend('location', 'northeastoutside');
    tit = strcat("");
    title(tit);
    subtitle("");
    ylabel(strcat("Partition 2"),"Rotation",0,'HorizontalAlignment','right','fontweight','bold');

    nexttile
    axis off
    
    ax4 = nexttile
    generate_erp_plot(results, start, endtime, datathree, electrode, "none", cis, "positive", paper_plot);
    h = get(gca, 'Children');
   
    hold on;
    legend('location', 'northeastoutside');
    tit = strcat("");
    title(tit);
    subtitle("");
    ylabel(strcat("Partition 3"),"Rotation",0,'HorizontalAlignment','right','fontweight','bold');


    linkaxes([ax1 ax2 ax3 ax4 ax5],'y');
    ax1.YLim = ax1.YLim * 1.1;
    
    titles = strcat("Interactions through partitions Partitions regressor");
    %f1.Position = f1.Position + [0 -300 0 300];
    set(gcf, 'Position', [100, 100, 1900, 1600]);
    if ~paper_plot
        %sgtitle(titles);
        name = strcat(results, "/partitions/", factor, ' preg_erpcombined.png');
        saveas(gcf, name);
    end
    plot = gcf;
end