function plot = plot_partitions_erp(dataone, datatwo, datathree, electrode, design2, factor, results, start, endtime, cis, paper_plot, font_size)

    if ~exist('font_size','var')
        font_size = 12;
    end

    [low1, high1] = median_split(dataone, 1, design2);
    [low2, high2] = median_split(datatwo, 1, design2);
    [low3, high3] = median_split(datathree, 1, design2);


    [highl, lowl] = ylimit_finder(high1,electrode);
    


    %start = 2.8;
    f1 = figure;
    
    if contains(factor,"onsets") || contains(factor,"Onsets")
            legend1 = ["Onsets 2,3 PGI", "Onsets 4,5 PGI", "Onsets 6,7 PGI", "", "Max Effect", ""];
            legend2 = ["Onsets 2,3 Med", "Onsets 4,5 Med", "Onsets 6,7 Med", "", "Max Effect", ""];

            title1 = 'Onsets 2,3';
            title2 = 'Onsets 4,5';
            title3 = 'Onsets 6,7';
            title4 = 'Onsets';
    else
            legend1 = ["Partition 1 PGI", "Partition 2 PGI", "Partition 3 PGI", "", "Max Effect", ""];
            legend2 = ["Partition 1 Med", "Partition 2 Med", "Partition 3 Med", "", "Max Effect", ""];

            title1 = 'Partition 1';
            title2 = 'Partition 2';
            title3 = 'Partition 3';
            title4 = 'Partitions';
    end



    % First subplot low PGI across partitions
    ax1 = subplot(5,2,1);
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
    leg1 = legend(legend1, 'location', 'eastoutside');
    %legend('hide');
    tit = strcat("Low Group");
    ylabel(strcat(title4," PGI"),"Rotation",0,'HorizontalAlignment','right','fontweight','bold');
    title(tit);
    subtitle("");

    ax2 = subplot(5,2,2);
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
    leg2 = legend(legend1, 'location', 'westoutside');
    tit = strcat("High Group");
    ylabel("","Rotation",0,'HorizontalAlignment','right','fontweight','bold');
    title(tit);
    subtitle("");


    
%%
    ax3 = subplot(5,2,3);
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
    leg3 = legend(legend2, 'location', 'eastoutside');
    %legend('hide');
    ylabel(strcat(title4," Med"),"Rotation",0,'HorizontalAlignment','right','fontweight','bold');
    title("");
    subtitle("");

    ax4 = subplot(5,2,4);
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
    leg4 = legend(legend2, 'location', 'westoutside');
    ylabel("","Rotation",0,'HorizontalAlignment','right','fontweight','bold');
    title("");
    subtitle("");
%%
    ax5 = subplot(5,2,5);
    generate_erp_plot(results, start, endtime, low1.data, electrode, "none", cis, "positive", paper_plot);
    h = get(gca, 'Children');
    %delete(h(1));
    %delete(h(2));
    %delete(h(3));
    %delete(h(4));
   
    hold on;
    leg5 = legend('location', 'eastoutside');
    ylabel(strcat(title1,""),"Rotation",0,'HorizontalAlignment','right','fontweight','bold');
    title("");
    subtitle("");

    ax6 = subplot(5,2,6);
    generate_erp_plot(results, start, endtime, high1.data, electrode, "none", cis, "positive", paper_plot);
    h = get(gca, 'Children');
    %delete(h(1));
    %delete(h(2));
    %delete(h(3));
    %delete(h(4));
   
    ylabel("","Rotation",0,'HorizontalAlignment','right','fontweight','bold'); 
    title("");
    hold on;
    leg6 = legend('location', 'westoutside');
    subtitle("");
%%
    ax7 = subplot(5,2,7);
    generate_erp_plot(results, start, endtime, low2.data, electrode, "none", cis, "positive", paper_plot);
    h = get(gca, 'Children');
    %delete(h(1));
    %delete(h(2));
    %delete(h(3));
    %delete(h(4));
   
    hold on;
    leg7 = legend('location', 'eastoutside');
    %legend('hide');
    ylabel(strcat(title2,""),"Rotation",0,'HorizontalAlignment','right','fontweight','bold');
    title("");
    subtitle("");

    ax8 = subplot(5,2,8);
    generate_erp_plot(results, start, endtime, high2.data, electrode, "none", cis, "positive", paper_plot);
    h = get(gca, 'Children');
    %delete(h(1));
    %delete(h(2));
    %delete(h(3));
    %delete(h(4));
   
    hold on;
    leg8 = legend('location', 'westoutside');
    ylabel("","Rotation",0,'HorizontalAlignment','right','fontweight','bold'); 
    title("");
    %%
    ax9 = subplot(5,2,9);
    generate_erp_plot(results, start, endtime, low3.data, electrode, "none", cis, "positive", paper_plot);
    h = get(gca, 'Children');
    %delete(h(1));
    %delete(h(2));
    %delete(h(3));
    %delete(h(4));
   
    hold on;
    leg9 = legend('location', 'eastoutside');
    ylabel(strcat(title3,""),"Rotation",0,'HorizontalAlignment','right','fontweight','bold');
    %legend('hide');
    title("");
    subtitle("");

    ax10 = subplot(5,2,10);
    generate_erp_plot(results, start, endtime, high3.data, electrode, "none", cis, "positive", paper_plot);
    h = get(gca, 'Children');
    %delete(h(1));
    %delete(h(2));
    %delete(h(3));
    %delete(h(4));
       
    hold on;
    subtitle("");
    leg10 = legend('location', 'westoutside');
    ylabel("","Rotation",0,'HorizontalAlignment','right','fontweight','bold');
    subtitle("");
    title("");
%%
    linkaxes([ax1 ax2 ax3 ax4 ax5 ax6 ax7 ax8 ax9 ax10],'y');
    ax1.YLim = ax1.YLim * 1.1;
    
    titles = strcat("Interactions through ", title4, " Low vs High group ", factor);
    set(findall(gcf,'-property','FontSize'),'FontSize',font_size);

    if font_size > 12
        set(gcf, 'Position', [100, 100, 2600, 1600]);
    else
        set(gcf, 'Position', [100, 100, 1900, 1600]);
    end


    legPos1 = get(leg1, 'Position');
    legPos2 = get(leg2, 'Position');

    avgpos = (legPos1(1)+legPos2(1))/2;
    avgpos = [avgpos,legPos1(2),legPos1(3),legPos1(4)];
    set(leg1, 'Position', avgpos);
    set(leg2, 'Position', avgpos);

    legPos3 = get(leg3, 'Position');
    legPos4 = get(leg4, 'Position');

    avgpos = (legPos3(1)+legPos4(1))/2;
    avgpos = [avgpos,legPos3(2),legPos3(3),legPos3(4)];
    set(leg3, 'Position', avgpos);
    set(leg4, 'Position', avgpos);

    legPos5 = get(leg5, 'Position');
    legPos6 = get(leg6, 'Position');

    avgpos = (legPos5(1)+legPos6(1))/2;
    avgpos = [avgpos,legPos5(2),legPos5(3),legPos5(4)];
    set(leg5, 'Position', avgpos);
    set(leg6, 'Position', avgpos);

    legPos7 = get(leg7, 'Position');
    legPos8 = get(leg8, 'Position');

    avgpos = (legPos7(1)+legPos8(1))/2;
    avgpos = [avgpos,legPos7(2),legPos7(3),legPos7(4)];
    set(leg7, 'Position', avgpos);
    set(leg8, 'Position', avgpos);

    legPos9 = get(leg9, 'Position');
    legPos10 = get(leg10, 'Position');

    avgpos = (legPos9(1)+legPos10(1))/2;
    avgpos = [avgpos,legPos9(2),legPos9(3),legPos9(4)];
    set(leg9, 'Position', avgpos);
    set(leg10, 'Position', avgpos);


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