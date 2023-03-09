function plot = plot_medium_split(high, low, electrode, factor, start_time, end_time, generate_cis, results,paper_plot)

    
% plots the PGI median split, as a 4x1 collection of subplots
% 
% Use as:
%       plot_medium_split(high, low, electrode, factor, start_time, end_time, generate_cis, results)
% 



    data = [high.data,low.data];
    [highl,lowl] = ylimit_finder(data,electrode);
    ylimit = [lowl,highl];
    start = 2.8;
    f1 = figure;

    % First subplot low PGI across partitions
    Ax = subplot(5, 1, 1);
    plot_medium_split_low(high, low, electrode, start_time, end_time, generate_cis);
    children = get(gca, 'children');
    %delete(children(3));
    delete(children(4));
    delete(children(5));
    delete(children(6));
    ylim(ylimit);
    hold on;
    legend('location', 'northwestoutside');
    tit = strcat("Median Split on PGI @ ", electrode.electrode);
    title(tit);
    subtitle("");

    Ax = subplot(5, 1, 2);
    plot_medium_split_low(high, low, electrode, start_time, end_time, generate_cis);
    children = get(gca, 'children');
    %delete(children(3));
    delete(children(4));
    delete(children(5));
    delete(children(6));
    ylim(ylimit);
    xlim([start_time, end_time]);
    hold on;
    legend('location', 'northwestoutside');
    tit = strcat(" Median split on PGI @ ", electrode.electrode, " Cropped to window");
    title(tit);
    subtitle("");

    [thinlow, medlow, thicklow] = split_data(low.data);
    [thinhigh, medhigh, thickhigh] = split_data(high.data);

    medhightemp.data = medhigh;
    medlowtemp.data = medlow;

    Ax = subplot(5, 1, 3);
    plot_medium_split_low(medhightemp, medlowtemp, electrode, start_time, end_time, generate_cis);
    children = get(gca, 'children');
    %delete(children(3));
    delete(children(4));
    delete(children(5));
    delete(children(6));
    ylim(ylimit);
    hold on;
    legend('location', 'northwestoutside');
    tit = strcat(" Median split on Medium @ ", electrode.electrode);
    title(tit);
    subtitle("");

    Ax = subplot(5, 1, 4);
    generate_erp_plot(results, start_time, end_time, high.data, electrode, factor, generate_cis, "Negative",paper_plot);
    children = get(gca, 'children');
    %delete(children(4));
    delete(children(5));
    delete(children(6));
    delete(children(7));
    ylim(ylimit);
    hold on;
    legend('location', 'northwestoutside');
    tit = strcat("High Group ERP @ ", electrode.electrode);
    title(tit);
    subtitle("");

    Ax = subplot(5, 1, 5);
    generate_erp_plot(results, start_time, end_time, low.data, electrode, factor, generate_cis, "Negative",paper_plot);
    children = get(gca, 'children');
    %delete(children(4));
    delete(children(5));
    delete(children(6));
    delete(children(7));
    ylim(ylimit);
    hold on;
    legend('location', 'northwestoutside');
    tit = strcat("Low Group ERP @ ", electrode.electrode);
    title(tit);
    subtitle("");

    %titles = strcat(" Median split Low vs High group ", factor);
    %f1.Position = f1.Position + [0 -300 0 300];
    
    set(gcf, 'Position', [100, 100, 1600, 900]);
    if ~paper_plot
    name = strcat(results, "/", factor, "/", string(start_time), 'erpcombined.png');
    saveas(gcf, name);
    end
    plot = gcf;
end
