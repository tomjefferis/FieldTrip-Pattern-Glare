function plot = plot_medium_split(high, low, electrode, factor, start_time, end_time, generate_cis, results,paper_plot)

% plots the PGI median split, as a 4x1 collection of subplots
% 
% Use as:
%       plot_medium_split(high, low, electrode, factor, start_time, end_time, generate_cis, results)
% 


    start = 2.8;
    f1 = figure;
    
    tiledlayout(3,2);

    
    % First subplot low PGI across partitions
    ax1 = nexttile;
    plot_medium_split_low(high, low, electrode, start_time, end_time, generate_cis);
    children = get(gca, 'children');
    %delete(children(4));
    %delete(children(5));
    %delete(children(6));
    
    hold on;
    legend('location', ' eastoutside');
    tit = strcat("Median Split on PGI @ ", electrode.electrode);
    title(tit);
    subtitle("");

    ax4 = nexttile;
    generate_erp_plot(results, start_time, end_time, high.data, electrode, factor, generate_cis, "Negative",paper_plot);
    children = get(gca, 'children');
    legend('location', ' eastoutside');
    hold on;
    tit = strcat("High Group ERP @ ", electrode.electrode);
    title(tit);
    subtitle("");

    ax2 = nexttile;
    plot_medium_split_low(high, low, electrode, start_time, end_time, generate_cis);
    children = get(gca, 'children');
    %delete(children(4));
    %delete(children(5));
    %delete(children(6));
   
    xlim([start_time, end_time]);
    hold on;
    legend('location', ' eastoutside');
    tit = strcat(" Median split on PGI @ ", electrode.electrode, " Cropped to window");
    title(tit);
    subtitle("");

    [thinlow, medlow, thicklow] = split_data(low.data);
    [thinhigh, medhigh, thickhigh] = split_data(high.data);

    medhightemp.data = medhigh;
    medlowtemp.data = medlow;

    ax5 = nexttile;
    generate_erp_plot(results, start_time, end_time, low.data, electrode, factor, generate_cis, "Negative",paper_plot);
    children = get(gca, 'children');
    hold on;
    legend('location', ' eastoutside');
    tit = strcat("Low Group ERP @ ", electrode.electrode);
    title(tit);
    subtitle("");

    ax3 = nexttile;
    plot_medium_split_low(medhightemp, medlowtemp, electrode, start_time, end_time, generate_cis);
    children = get(gca, 'children');
    %delete(children(4));
    %delete(children(5));
    %delete(children(6));
   
    hold on;
    legend('location', ' eastoutside');
    tit = strcat(" Median split on Medium @ ", electrode.electrode);
    title(tit);
    subtitle("");

    



    linkaxes([ax1 ax2 ax3 ax4 ax5],'y');
    ax1.YLim = ax1.YLim * 1.1;

    set(gcf, 'Position', [100, 100, 1600, 1900]);
    if ~paper_plot
        name = strcat(results, "/", factor, "/", string(start_time), 'erpcombined.png');
        saveas(gcf, name);
    end
    plot = gcf;
end