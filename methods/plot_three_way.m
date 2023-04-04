function plot = plot_three_way(dataone, datatwo, datathree, electrode, design2, factor, results, start, endtime, cis, paper_plot)

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

    tiledlayout(6,2);

    % First subplot low PGI across P1 onsets
    ax1 = nexttile
    data = partitions_combine(low11.data, low21.data, low31.data, "PGI");
    generate_erp_plot(results, start, endtime, data, electrode, "none", false, "positive", paper_plot);
    h = get(gca, 'Children');
    h(6).Color = [0.8350 0.0780 0.1840];
    h(5).Color = [0.4660 0.8740 0.1880];
    h(4).Color = [0.3010 0.7450 0.9330];
    %delete(h(2));
    %delete(h(3));
    %delete(h(4));
   
    PosVec = Ax.Position;
     %Ax.Position = PosVec + [0 -0.02 0 0.02];
    hold on;
    legend("Onsets 2,3","Onsets 4,5","Onsets 6,7","","Max Effect", 'location', 'westoutside');
    tit = strcat("Low Group");
    ylabel("P1 PGI","Rotation",0,'HorizontalAlignment','right','fontweight','bold');
    title(tit);
    subtitle("");



    % First subplot low PGI across P1 onsets
    ax2 = nexttile
    data = partitions_combine(high11.data, high21.data, high31.data, "PGI");
    generate_erp_plot(results, start, endtime, data, electrode, "none", false, "positive", paper_plot);
    h = get(gca, 'Children');
    h(6).Color = [0.8350 0.0780 0.1840];
    h(5).Color = [0.4660 0.8740 0.1880];
    h(4).Color = [0.3010 0.7450 0.9330];
    %delete(h(2));
    %delete(h(3));
    %delete(h(4));
   
    PosVec = Ax.Position;
     %Ax.Position = PosVec + [0 -0.02 0 0.02];
    hold on;
    legend("Onsets 2,3","Onsets 4,5","Onsets 6,7", 'location', 'eastoutside');
    legend('hide');
    tit = strcat("High Group");
    title(tit);
    ylabel("","Rotation",0,'HorizontalAlignment','right','fontweight','bold');
    subtitle("");

        % First subplot low PGI across P1 onsets
    ax3 = nexttile
    data = partitions_combine(low11.data, low21.data, low31.data, "med");
    generate_erp_plot(results, start, endtime, data, electrode, "none", false, "positive", paper_plot);
    h = get(gca, 'Children');
    h(6).Color = 'r';
    h(5).Color = 'g';
    h(4).Color = 'b';
    %delete(h(2));
    %delete(h(3));
    %delete(h(4));
   
    PosVec = Ax.Position;
     %Ax.Position = PosVec + [0 -0.02 0 0.02];
    hold on;
    ylabel("P1 Med","Rotation",0,'HorizontalAlignment','right','fontweight','bold');
    legend("Onsets 2,3","Onsets 4,5","Onsets 6,7","","Max Effect", 'location', 'westoutside');
    subtitle("");
    title("");



    % First subplot low PGI across P1 onsets
    ax4 = nexttile
    data = partitions_combine(high11.data, high21.data, high31.data, "med");
    generate_erp_plot(results, start, endtime, data, electrode, "none", false, "positive", paper_plot);
    h = get(gca, 'Children');
    h(6).Color = 'r';
    h(5).Color = 'g';
    h(4).Color = 'b';
    %delete(h(2));
    %delete(h(3));
    %delete(h(4));
   
    PosVec = Ax.Position;
     %Ax.Position = PosVec + [0 -0.02 0 0.02];
    hold on;
    legend("Onsets 2,3","Onsets 4,5","Onsets 6,7", 'location', 'eastoutside');
    legend('hide');
    ylabel("","Rotation",0,'HorizontalAlignment','right','fontweight','bold');
    subtitle("");
    title("");

    %% First subplot low PGI across P2 onsets
    ax5 = nexttile
    data = partitions_combine(low12.data, low22.data, low32.data, "PGI");
    generate_erp_plot(results, start, endtime, data, electrode, "none", false, "positive", paper_plot);
    h = get(gca, 'Children');
    h(6).Color = [0.8350 0.0780 0.1840];
    h(5).Color = [0.4660 0.8740 0.1880];
    h(4).Color = [0.3010 0.7450 0.9330];
    %delete(h(2));
    %delete(h(3));
    %delete(h(4));
   
    PosVec = Ax.Position;
     %Ax.Position = PosVec + [0 -0.02 0 0.02];
    hold on;
    legend("Onsets 2,3","Onsets 4,5","Onsets 6,7","","Max Effect", 'location', 'westoutside');
    ylabel("P2 PGI","Rotation",0,'HorizontalAlignment','right','fontweight','bold');
    subtitle("");
    title("");



    % First subplot low PGI across P1 onsets
    ax6 = nexttile
    data = partitions_combine(high12.data, high22.data, high32.data, "PGI");
    generate_erp_plot(results, start, endtime, data, electrode, "none", false, "positive", paper_plot);
    h = get(gca, 'Children');
    h(6).Color = [0.8350 0.0780 0.1840];
    h(5).Color = [0.4660 0.8740 0.1880];
    h(4).Color = [0.3010 0.7450 0.9330];
    %delete(h(2));
    %delete(h(3));
    %delete(h(4));
   
    PosVec = Ax.Position;
     %Ax.Position = PosVec + [0 -0.02 0 0.02];
    hold on;
    legend("Onsets 2,3","Onsets 4,5","Onsets 6,7", 'location', 'eastoutside');
    legend('hide');
    ylabel("","Rotation",0,'HorizontalAlignment','right','fontweight','bold');
    subtitle("");
    title("");

        % First subplot low PGI across P1 onsets
    ax7 = nexttile
    data = partitions_combine(low12.data, low22.data, low32.data, "med");
    generate_erp_plot(results, start, endtime, data, electrode, "none", false, "positive", paper_plot);
    h = get(gca, 'Children');
    h(6).Color = 'r';
    h(5).Color = 'g';
    h(4).Color = 'b';
    %delete(h(2));
    %delete(h(3));
    %delete(h(4));
   
    PosVec = Ax.Position;
     %Ax.Position = PosVec + [0 -0.02 0 0.02];
    hold on;
    legend("Onsets 2,3","Onsets 4,5","Onsets 6,7","","Max Effect", 'location', 'westoutside');
    ylabel("P2 Med","Rotation",0,'HorizontalAlignment','right','fontweight','bold');
    subtitle("");
    title("");



    % First subplot low PGI across P1 onsets
    ax8 = nexttile
    data = partitions_combine(high12.data, high22.data, high32.data, "med");
    generate_erp_plot(results, start, endtime, data, electrode, "none", false, "positive", paper_plot);
    h = get(gca, 'Children');
    h(6).Color = 'r';
    h(5).Color = 'g';
    h(4).Color = 'b';
    %delete(h(2));
    %delete(h(3));
    %delete(h(4));
   
    PosVec = Ax.Position;
     %Ax.Position = PosVec + [0 -0.02 0 0.02];
    hold on;
    legend("Onsets 2,3","Onsets 4,5","Onsets 6,7", 'location', 'eastoutside');
    legend('hide');
    ylabel("","Rotation",0,'HorizontalAlignment','right','fontweight','bold');
    subtitle("");
    title("");

    %%P3
        % First subplot low PGI across P1 onsets
    ax9 = nexttile
    data = partitions_combine(low13.data, low23.data, low33.data, "PGI");
    generate_erp_plot(results, start, endtime, data, electrode, "none", false, "positive", paper_plot);
    h = get(gca, 'Children');
    h(6).Color = [0.8350 0.0780 0.1840];
    h(5).Color = [0.4660 0.8740 0.1880];
    h(4).Color = [0.3010 0.7450 0.9330];
    %delete(h(2));
    %delete(h(3));
    %delete(h(4));
   
    PosVec = Ax.Position;
     %Ax.Position = PosVec + [0 -0.02 0 0.02];
    hold on;
    legend("Onsets 2,3","Onsets 4,5","Onsets 6,7","","Max Effect", 'location', 'westoutside');
    ylabel("P3 PGI","Rotation",0,'HorizontalAlignment','right','fontweight','bold');
    subtitle("");
    title("");



    % First subplot low PGI across P1 onsets
    ax10 = nexttile
    data = partitions_combine(high13.data, high23.data, high33.data, "PGI");
    generate_erp_plot(results, start, endtime, data, electrode, "none", false, "positive", paper_plot);
    h = get(gca, 'Children');
    h(6).Color = [0.8350 0.0780 0.1840];
    h(5).Color = [0.4660 0.8740 0.1880];
    h(4).Color = [0.3010 0.7450 0.9330];
    %delete(h(2));
    %delete(h(3));
    %delete(h(4));
   
    PosVec = Ax.Position;
     %Ax.Position = PosVec + [0 -0.02 0 0.02];
    hold on;
    legend("Onsets 2,3","Onsets 4,5","Onsets 6,7", 'location', 'eastoutside');
    legend('hide');
    ylabel("","Rotation",0,'HorizontalAlignment','right','fontweight','bold');
    subtitle("");
    title("");

        % First subplot low PGI across P1 onsets
    ax11 = nexttile
    data = partitions_combine(low13.data, low23.data, low33.data, "med");
    generate_erp_plot(results, start, endtime, data, electrode, "none", false, "positive", paper_plot);
    h = get(gca, 'Children');
    h(6).Color = 'r';
    h(5).Color = 'g';
    h(4).Color = 'b';
    %delete(h(2));
    %delete(h(3));
    %delete(h(4));
   
    PosVec = Ax.Position;
    %Ax.Position = PosVec + [0 -0.02 0 0.02];
    hold on;
    ylabel("P3 Med","Rotation",0,'HorizontalAlignment','right','fontweight','bold');
    legend("Onsets 2,3","Onsets 4,5","Onsets 6,7","","Max Effect", 'location', 'westoutside');
    subtitle("");
    title("");



    % First subplot low PGI across P1 onsets
    ax12 = nexttile
    data = partitions_combine(high13.data, high23.data, high33.data, "med");
    generate_erp_plot(results, start, endtime, data, electrode, "none", false, "positive", paper_plot);
    h = get(gca, 'Children');
    h(6).Color = 'r';
    h(5).Color = 'g';
    h(4).Color = 'b';
    %delete(h(2));
    %delete(h(3));
    %delete(h(4));
   
    PosVec = Ax.Position;
    %Ax.Position = PosVec + [0 -0.02 0 0.02];
    hold on;
    legend("Onsets 2,3","Onsets 4,5","Onsets 6,7", 'location', 'eastoutside');
    legend('hide');
    ylabel("","Rotation",0,'HorizontalAlignment','right','fontweight','bold');
    subtitle("");
    title("");

   
    linkaxes([ax1 ax2 ax3 ax4 ax5 ax6 ax7 ax8 ax9 ax10 ax11 ax12],'y');
    ax1.YLim = ax1.YLim * 1.1;
    
    titles = strcat("Interactions through Partitions vs Onsets @",electrode.electrode, "for ", factor);
    %f1.Position = f1.Position + [0 -300 0 300];
    set(gcf, 'Position', [100, 100, 1800, 2000]);
    sgtitle(titles);
    if ~paper_plot
        name = strcat(results, "/partitions/", factor, electrode.electrode, '_erpcombined.png');
        saveas(gcf, name);
    end
    plot = gcf;
end
