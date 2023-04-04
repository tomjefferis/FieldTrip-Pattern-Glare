function plot = plot_partitions_erp(dataone, datatwo, datathree, electrode, design2, factor, results, start, endtime, cis, paper_plot)

    [low1, high1] = median_split(dataone, 1, design2);
    [low2, high2] = median_split(datatwo, 1, design2);
    [low3, high3] = median_split(datathree, 1, design2);


    [highl, lowl] = ylimit_finder(high1,electrode);
    


    %start = 2.8;
    f1 = figure;
    tiledlayout(5,2);


    if contains(factor,"onsets-23-45-67")
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



    % First subplot low PGI across partitions
    ax1 = nexttile;
    data = partitions_combine(low1.data, low2.data, low3.data, "PGI");
    generate_erp_plot_alt(results, start, endtime, data, electrode, "none", false, "positive", paper_plot);
    h = get(gca, 'Children');
    h(7).Color = [0.8350 0.0780 0.1840];
    h(6).Color = [0.4660 0.8740 0.1880];
    h(5).Color = [0.3010 0.7450 0.9330];
    %delete(h(2));
    %delete(h(3));
    %delete(h(4));
   
    hold on;
    legend(legend1, 'location', 'eastoutside');
    %legend('hide');
    tit = strcat("Low Group");
    ylabel(strcat(title4," PGI"),"Rotation",0,'HorizontalAlignment','right','fontweight','bold');
    title(tit);
    subtitle("");

    ax2 = nexttile;
    data = partitions_combine(high1.data, high2.data, high3.data, "PGI");
    generate_erp_plot_alt(results, start, endtime, data, electrode, "none", false, "positive", paper_plot);
    h = get(gca, 'Children');
    h(7).Color = [0.8350 0.0780 0.1840];
    h(6).Color = [0.4660 0.8740 0.1880];
    h(5).Color = [0.3010 0.7450 0.9330];
    %delete(h(2));
    %delete(h(3));
    %delete(h(4));
   
    hold on;
    legend('hide');
    tit = strcat("High Group");
    ylabel("","Rotation",0,'HorizontalAlignment','right','fontweight','bold');
    title(tit);
    subtitle("");

    ax3 = nexttile;
    data = partitions_combine(low1.data, low2.data, low3.data, "med");
    generate_erp_plot(results, start, endtime, data, electrode, "none", false, "positive", paper_plot);
    h = get(gca, 'Children');
    h(6).Color = 'r';
    h(5).Color = 'g';
    h(4).Color = 'b';
    %delete(h(1));
    %delete(h(2));
    %delete(h(3));
    %delete(h(4));
   
    hold on;
    legend(legend2, 'location', 'eastoutside');
    %legend('hide');
    ylabel(strcat(title4," Med"),"Rotation",0,'HorizontalAlignment','right','fontweight','bold');
    title("");
    subtitle("");

    ax4 = nexttile;
    data = partitions_combine(high1.data, high2.data, high3.data, "med");
    generate_erp_plot(results, start, endtime, data, electrode, "none", false, "positive", paper_plot);
    h = get(gca, 'Children');
    h(6).Color = 'r';
    h(5).Color = 'g';
    h(4).Color = 'b';
    %delete(h(1));
    %delete(h(2));
    %delete(h(3));
    %delete(h(4));
   
    hold on;
    legend('hide');
    ylabel("","Rotation",0,'HorizontalAlignment','right','fontweight','bold');
    title("");
    subtitle("");

    ax5 = nexttile;
    generate_erp_plot(results, start, endtime, low1.data, electrode, "none", cis, "positive", paper_plot);
    h = get(gca, 'Children');
    %delete(h(1));
    %delete(h(2));
    %delete(h(3));
    %delete(h(4));
   
    hold on;
    legend('location', 'eastoutside');
    ylabel(strcat(title1,""),"Rotation",0,'HorizontalAlignment','right','fontweight','bold');
    title("");
    subtitle("");

    ax6 = nexttile;
    generate_erp_plot(results, start, endtime, high1.data, electrode, "none", cis, "positive", paper_plot);
    h = get(gca, 'Children');
    %delete(h(1));
    %delete(h(2));
    %delete(h(3));
    %delete(h(4));
   
    ylabel("","Rotation",0,'HorizontalAlignment','right','fontweight','bold'); 
    title("");
    hold on;
    legend('hide')
    subtitle("");

    ax7 = nexttile;
    generate_erp_plot(results, start, endtime, low2.data, electrode, "none", cis, "positive", paper_plot);
    h = get(gca, 'Children');
    %delete(h(1));
    %delete(h(2));
    %delete(h(3));
    %delete(h(4));
   
    hold on;
    legend('location', 'eastoutside');
    %legend('hide');
    ylabel(strcat(title2,""),"Rotation",0,'HorizontalAlignment','right','fontweight','bold');
    title("");
    subtitle("");

    ax8 = nexttile;
    generate_erp_plot(results, start, endtime, high2.data, electrode, "none", cis, "positive", paper_plot);
    h = get(gca, 'Children');
    %delete(h(1));
    %delete(h(2));
    %delete(h(3));
    %delete(h(4));
   
    hold on;
    legend('hide');
    ylabel("","Rotation",0,'HorizontalAlignment','right','fontweight','bold'); 
    title("");
    
    ax9 = nexttile;
    generate_erp_plot(results, start, endtime, low3.data, electrode, "none", cis, "positive", paper_plot);
    h = get(gca, 'Children');
    %delete(h(1));
    %delete(h(2));
    %delete(h(3));
    %delete(h(4));
   
    hold on;
    legend('location', 'eastoutside');
    ylabel(strcat(title3,""),"Rotation",0,'HorizontalAlignment','right','fontweight','bold');
    %legend('hide');
    title("");
    subtitle("");

    ax10 = nexttile;
    generate_erp_plot(results, start, endtime, high3.data, electrode, "none", cis, "positive", paper_plot);
    h = get(gca, 'Children');
    %delete(h(1));
    %delete(h(2));
    %delete(h(3));
    %delete(h(4));
       
    hold on;
    subtitle("");
    legend('hide');
    ylabel("","Rotation",0,'HorizontalAlignment','right','fontweight','bold');
    subtitle("");
    title("");

    linkaxes([ax1 ax2 ax3 ax4 ax5 ax6 ax7 ax8 ax9 ax10],'y');
    ax1.YLim = ax1.YLim * 1.1;
    
    titles = strcat("Interactions through ", title4, " Low vs High group ", factor);
    set(gcf, 'Position', [100, 100, 1900, 1600]);


    %lg  = legend(["", "", "","", "Max Effect"], 'Orientation','horizontal'); 
    %lg.Layout.Tile = 'North';
    %f1.Position = f1.Position + [0 -300 0 300];
     if ~paper_plot
        %sgtitle(titles);
        name = strcat(results, "/partitions/", factor,electrode.electrode, '_erpcombined.png');
        saveas(gcf, name);
     end
    plot = gcf;
end