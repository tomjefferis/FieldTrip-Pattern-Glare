function plot = plot_three_way(dataone, datatwo, datathree, electrode, design2, factor, results, start, endtime, cis, paper_plot,font_size)

    if ~exist('font_size','var')
        font_size = 12;
    end

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

    

   

   
    %start = 2.8;
    f1 = figure;

    % First subplot low PGI across P1 onsets
    ax1 = subplot(6,2,1);
    data = partitions_combine(low11.data, low21.data, low31.data, "PGI");
    generate_erp_plot(results, start, endtime, data, electrode, "none", false, "positive", paper_plot);
    h = get(gca, 'Children');
    h(10).Color = [0.8350 0.0780 0.1840];
    h(9).Color = [0.4660 0.8740 0.1880];
    h(8).Color = [0.3010 0.7450 0.9330];
    %delete(h(2));
    %delete(h(3));
    %delete(h(4));
   
     xlabel("");
     %Ax.Position = PosVec + [0 -0.02 0 0.02];
    hold on;
    leg1 = legend("Onsets 2,3","Onsets 4,5","Onsets 6,7","","Max Effect", 'location', 'eastoutside');
    tit = strcat("Low Group");
    ylabel("P1 PGI","Rotation",0,'HorizontalAlignment','right','fontweight','bold');
    title(tit);
    subtitle("");



    % First subplot low PGI across P1 onsets
    ax2 = subplot(6,2,2);
    data = partitions_combine(high11.data, high21.data, high31.data, "PGI");
    generate_erp_plot(results, start, endtime, data, electrode, "none", false, "positive", paper_plot);
    h = get(gca, 'Children');
    h(10).Color = [0.8350 0.0780 0.1840];
    h(9).Color = [0.4660 0.8740 0.1880];
    h(8).Color = [0.3010 0.7450 0.9330];
    %delete(h(2));
    %delete(h(3));
    %delete(h(4));
   
     xlabel("");
     %Ax.Position = PosVec + [0 -0.02 0 0.02];
    hold on;
    leg2 = legend("Onsets 2,3","Onsets 4,5","Onsets 6,7","","Max Effect", 'location', 'westoutside');
    tit = strcat("High Group");
    title(tit);
    ylabel("","Rotation",0,'HorizontalAlignment','right','fontweight','bold');
    subtitle("");

        % First subplot low PGI across P1 onsets
    ax3 = subplot(6,2,3);
    data = partitions_combine(low11.data, low21.data, low31.data, "med");
    generate_erp_plot(results, start, endtime, data, electrode, "none", false, "positive", paper_plot);
    h = get(gca, 'Children');
    h(10).Color = 'r';
    h(9).Color = 'g';
    h(8).Color = 'b';
    %delete(h(2));
    %delete(h(3));
    %delete(h(4));
   
     xlabel("");
     %Ax.Position = PosVec + [0 -0.02 0 0.02];
    hold on;
    ylabel("P1 Med","Rotation",0,'HorizontalAlignment','right','fontweight','bold');
    leg3 = legend("Onsets 2,3","Onsets 4,5","Onsets 6,7","","Max Effect", 'location', 'eastoutside');
    subtitle("");
    title("");



    % First subplot low PGI across P1 onsets
    ax4 = subplot(6,2,4);
    data = partitions_combine(high11.data, high21.data, high31.data, "med");
    generate_erp_plot(results, start, endtime, data, electrode, "none", false, "positive", paper_plot);
    h = get(gca, 'Children');
    h(10).Color = 'r';
    h(9).Color = 'g';
    h(8).Color = 'b';
    %delete(h(2));
    %delete(h(3));
    %delete(h(4));
   
     xlabel("");
     %Ax.Position = PosVec + [0 -0.02 0 0.02];
    hold on;
    leg4 = legend("Onsets 2,3","Onsets 4,5","Onsets 6,7","","Max Effect", 'location', 'westoutside');
    ylabel("","Rotation",0,'HorizontalAlignment','right','fontweight','bold');
    subtitle("");
    title("");

    %% First subplot low PGI across P2 onsets
    ax5 = subplot(6,2,5);
    data = partitions_combine(low12.data, low22.data, low32.data, "PGI");
    generate_erp_plot(results, start, endtime, data, electrode, "none", false, "positive", paper_plot);
    h = get(gca, 'Children');
    h(10).Color = [0.8350 0.0780 0.1840];
    h(9).Color = [0.4660 0.8740 0.1880];
    h(8).Color = [0.3010 0.7450 0.9330];
    %delete(h(2));
    %delete(h(3));
    %delete(h(4));
   
     xlabel("");
     %Ax.Position = PosVec + [0 -0.02 0 0.02];
    hold on;
    leg5 = legend("Onsets 2,3","Onsets 4,5","Onsets 6,7","","Max Effect", 'location', 'eastoutside');
    ylabel("P2 PGI","Rotation",0,'HorizontalAlignment','right','fontweight','bold');
    subtitle("");
    title("");



    % First subplot low PGI across P1 onsets
    ax6 = subplot(6,2,6);
    data = partitions_combine(high12.data, high22.data, high32.data, "PGI");
    generate_erp_plot(results, start, endtime, data, electrode, "none", false, "positive", paper_plot);
    h = get(gca, 'Children');
    h(10).Color = [0.8350 0.0780 0.1840];
    h(9).Color = [0.4660 0.8740 0.1880];
    h(8).Color = [0.3010 0.7450 0.9330];
    %delete(h(2));
    %delete(h(3));
    %delete(h(4));
   
     xlabel("");
     %Ax.Position = PosVec + [0 -0.02 0 0.02];
    hold on;
    leg6 = legend("Onsets 2,3","Onsets 4,5","Onsets 6,7","","Max Effect", 'location', 'westoutside');
    ylabel("","Rotation",0,'HorizontalAlignment','right','fontweight','bold');
    subtitle("");
    title("");

        % First subplot low PGI across P1 onsets
    ax7 = subplot(6,2,7);
    data = partitions_combine(low12.data, low22.data, low32.data, "med");
    generate_erp_plot(results, start, endtime, data, electrode, "none", false, "positive", paper_plot);
    h = get(gca, 'Children');
    h(10).Color = 'r';
    h(9).Color = 'g';
    h(8).Color = 'b';
    %delete(h(2));
    %delete(h(3));
    %delete(h(4));
   
     xlabel("");
     %Ax.Position = PosVec + [0 -0.02 0 0.02];
    hold on;
    leg7 = legend("Onsets 2,3","Onsets 4,5","Onsets 6,7","","Max Effect", 'location', 'eastoutside');
    ylabel("P2 Med","Rotation",0,'HorizontalAlignment','right','fontweight','bold');
    subtitle("");
    title("");



    % First subplot low PGI across P1 onsets
    ax8 = subplot(6,2,8);
    data = partitions_combine(high12.data, high22.data, high32.data, "med");
    generate_erp_plot(results, start, endtime, data, electrode, "none", false, "positive", paper_plot);
    h = get(gca, 'Children');
    h(10).Color = 'r';
    h(9).Color = 'g';
    h(8).Color = 'b';
    %delete(h(2));
    %delete(h(3));
    %delete(h(4));
   
     xlabel("");
     %Ax.Position = PosVec + [0 -0.02 0 0.02];
    hold on;
    leg8 = legend("Onsets 2,3","Onsets 4,5","Onsets 6,7","","Max Effect", 'location', 'westoutside');
    ylabel("","Rotation",0,'HorizontalAlignment','right','fontweight','bold');
    subtitle("");
    title("");

    %%P3
        % First subplot low PGI across P1 onsets
    ax9 = subplot(6,2,9);
    data = partitions_combine(low13.data, low23.data, low33.data, "PGI");
    generate_erp_plot(results, start, endtime, data, electrode, "none", false, "positive", paper_plot);
    h = get(gca, 'Children');
    h(10).Color = [0.8350 0.0780 0.1840];
    h(9).Color = [0.4660 0.8740 0.1880];
    h(8).Color = [0.3010 0.7450 0.9330];
    %delete(h(2));
    %delete(h(3));
    %delete(h(4));
   
     xlabel("");
     %Ax.Position = PosVec + [0 -0.02 0 0.02];
    hold on;
    leg9 = legend("Onsets 2,3","Onsets 4,5","Onsets 6,7","","Max Effect", 'location', 'eastoutside');
    ylabel("P3 PGI","Rotation",0,'HorizontalAlignment','right','fontweight','bold');
    subtitle("");
    title("");



    % First subplot low PGI across P1 onsets
    ax10 = subplot(6,2,10);
    data = partitions_combine(high13.data, high23.data, high33.data, "PGI");
    generate_erp_plot(results, start, endtime, data, electrode, "none", false, "positive", paper_plot);
    h = get(gca, 'Children');
    h(10).Color = [0.8350 0.0780 0.1840];
    h(9).Color = [0.4660 0.8740 0.1880];
    h(8).Color = [0.3010 0.7450 0.9330];
    %delete(h(2));
    %delete(h(3));
    %delete(h(4));
   
     xlabel("");
     %Ax.Position = PosVec + [0 -0.02 0 0.02];
    hold on;
    leg10 = legend("Onsets 2,3","Onsets 4,5","Onsets 6,7","","Max Effect", 'location', 'westoutside');
    ylabel("","Rotation",0,'HorizontalAlignment','right','fontweight','bold');
    subtitle("");
    title("");

        % First subplot low PGI across P1 onsets
    ax11 = subplot(6,2,11);
    data = partitions_combine(low13.data, low23.data, low33.data, "med");
    generate_erp_plot(results, start, endtime, data, electrode, "none", false, "positive", paper_plot);
    h = get(gca, 'Children');
    h(10).Color = 'r';
    h(9).Color = 'g';
    h(8).Color = 'b';
    %delete(h(2));
    %delete(h(3));
    %delete(h(4));
   
     
    %Ax.Position = PosVec + [0 -0.02 0 0.02];
    hold on;
    ylabel("P3 Med","Rotation",0,'HorizontalAlignment','right','fontweight','bold');
    leg11 = legend("Onsets 2,3","Onsets 4,5","Onsets 6,7","","Max Effect", 'location', 'eastoutside');
    subtitle("");
    title("");



    % First subplot low PGI across P1 onsets
    ax12 = subplot(6,2,12);
    data = partitions_combine(high13.data, high23.data, high33.data, "med");
    generate_erp_plot(results, start, endtime, data, electrode, "none", false, "positive", paper_plot);
    h = get(gca, 'Children');
    h(10).Color = 'r';
    h(9).Color = 'g';
    h(8).Color = 'b';
    %delete(h(2));
    %delete(h(3));
    %delete(h(4));
   
     
    %Ax.Position = PosVec + [0 -0.02 0 0.02];
    hold on;
    leg12 = legend("Onsets 2,3","Onsets 4,5","Onsets 6,7","","Max Effect", 'location', 'westoutside');
    ylabel("","Rotation",0,'HorizontalAlignment','right','fontweight','bold');
    subtitle("");
    title("");

   
    linkaxes([ax1 ax2 ax3 ax4 ax5 ax6 ax7 ax8 ax9 ax10 ax11 ax12],'y');
    ax1.YLim = ax1.YLim * 1.1;

    titles = strcat("Interactions through Partitions vs Onsets @",electrode.electrode, " for ", factor);
    %f1.Position = f1.Position + [0 -300 0 300];
    set(findall(gcf,'-property','FontSize'),'FontSize',font_size);
    
    set(gcf, 'Position', [100, 100, 1900, 2400]);
    
    pos1 = get(ax1, 'Position');
    pos2 = get(ax2, 'Position');
    pos3 = get(ax3, 'Position');
    pos4 = get(ax4, 'Position');
    pos5 = get(ax5, 'Position');
    pos6 = get(ax6, 'Position');
    pos7 = get(ax7, 'Position');
    pos8 = get(ax8, 'Position');
    pos9 = get(ax9, 'Position');
    pos10 = get(ax10, 'Position');
    pos11 = get(ax11, 'Position');
    pos12 = get(ax12, 'Position');

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

    legPos11 = get(leg11, 'Position');
    legPos12 = get(leg12, 'Position');

    avgpos = (legPos11(1)+legPos12(1))/2;
    avgpos = [avgpos,legPos11(2),legPos11(3),legPos11(4)];
    set(leg11, 'Position', avgpos);
    set(leg12, 'Position', avgpos);

    % get all positions of axes again
    pos1_new = get(ax1, 'Position');
    pos2_new = get(ax2, 'Position');
    pos3_new = get(ax3, 'Position');
    pos4_new = get(ax4, 'Position');
    pos5_new = get(ax5, 'Position');
    pos6_new = get(ax6, 'Position');
    pos7_new = get(ax7, 'Position');
    pos8_new = get(ax8, 'Position');
    pos9_new = get(ax9, 'Position');
    pos10_new = get(ax10, 'Position');
    pos11_new = get(ax11, 'Position');
    pos12_new = get(ax12, 'Position');

    % set width of 2/3rds of the new width compared to old
    pos1_new(3) = pos1(3) + (2/3)*(pos1_new(3) - pos1(3));
    pos2_new(3) =  pos1_new(3);
    pos3_new(3) =  pos1_new(3);
    pos4_new(3) =  pos1_new(3);
    pos5_new(3) =  pos1_new(3);
    pos6_new(3) =  pos1_new(3);
    pos7_new(3) =  pos1_new(3);
    pos8_new(3) =  pos1_new(3);
    pos9_new(3) =  pos1_new(3);
    pos10_new(3) = pos1_new(3);
    pos11_new(3) = pos1_new(3);
    pos12_new(3) = pos1_new(3);

      % set x position of 2/3rds of the new x position compared to old for even axes
    pos2_new(1) = pos2(1) + (2/3)*(pos2_new(1) - pos2(1));
    pos4_new(1) = pos2_new(1);
    pos6_new(1) = pos2_new(1);
    pos8_new(1) = pos2_new(1);
    pos10_new(1) = pos2_new(1);
    pos12_new(1) = pos2_new(1);

    % set position of all axes
    set(ax1, 'Position', pos1_new);
    set(ax2, 'Position', pos2_new);
    set(ax3, 'Position', pos3_new);
    set(ax4, 'Position', pos4_new);
    set(ax5, 'Position', pos5_new);
    set(ax6, 'Position', pos6_new);
    set(ax7, 'Position', pos7_new);
    set(ax8, 'Position', pos8_new);
    set(ax9, 'Position', pos9_new);
    set(ax10, 'Position', pos10_new);
    set(ax11, 'Position', pos11_new);
    set(ax12, 'Position', pos12_new);

    %if font_size > 12
    %   set(gcf, 'Position', [100, 100, 2600, 2000]);
    %end

    if ~paper_plot
        sgtitle(titles);
        name = strcat(results, "/partitions/", factor, electrode.electrode, '_erpcombined.png');
        saveas(gcf, name);
    end
    plot = gcf;
end
