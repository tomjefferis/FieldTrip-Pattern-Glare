function generate_erp_plot(results_dir, start_time, end_time, data, significant_electrode, factor, generate_ci, polarity)

% Generating erp plots for no factor

    start_window_time = start_time;
    end_window_time = end_time;

    start_time = 2.8;
    end_time = 3.99;

    save_dir = strcat(results_dir, "\", factor, "\");
    plotting_window = [start_time, end_time];

    cfg = [];
    cfg.channel = 'all';
    cfg.latency = 'all';
    [thin, med, thick] = split_data(data);

    %get grand average erps for conditions
    grandavgthin = ft_timelockgrandaverage(cfg, thin{:});
    grandavgmed = ft_timelockgrandaverage(cfg, med{:});
    grandavgthick = ft_timelockgrandaverage(cfg, thick{:});

    %change baseline to start
    %cfg = [];
    %cfg.baseline = [-0.2 0];
    %grandavgthin = ft_timelockbaseline(cfg, grandavgthin);
    %grandavgmed = ft_timelockbaseline(cfg, grandavgmed);
    %grandavgthick = ft_timelockbaseline(cfg, grandavgthick);

    % Get electrode index
    electrode_index = get_electrode_index(data, significant_electrode);
    electrode_name = string(significant_electrode.electrode);

    % plotting  setup, title, axis, colours, etc
    graph_title = strcat("ERP at ", electrode_name, " Between ", string(start_time), "s and ", string(end_time), "s");
    save_dir = strcat(save_dir, electrode_name, string(start_window_time), " ", string(end_window_time), polarity, "erp.png");

    time = data{1}.time;
    y1 = grandavgthin.avg(electrode_index, :);
    y2 = grandavgmed.avg(electrode_index, :);
    y3 = grandavgthick.avg(electrode_index, :);

    [high, low] = ylimit_finder(data, significant_electrode);

    plot(time, y1, 'Color', '#0072BD', 'LineWidth', 2);
    hold on;
    plot(time, y2, 'Color', '#D95319', 'LineWidth', 2);
    plot(time, y3, 'Color', '#EDB120', 'LineWidth', 2);
    xlim(plotting_window);
    ylim([low high]);
    yline(0, '--');

    if ~(start_window_time == 3)
        xline(3, '--o', {"Stimulus", "Off"});
        xline(start_window_time, '-', {"Window Start"});
    else
        xline(3, '--o', {"Stimulus Off", "Window Start"});
    end

    xline(end_window_time, '-', {"Window End"});
    xline(significant_electrode.time, '--r', {"Maximum Effect"}, 'LabelOrientation', 'horizontal','LabelVerticalAlignment','bottom','LabelHorizontalAlignment','right');
    title(graph_title);
    subtitle(strcat("Maximum T Value = ", string(significant_electrode.t_value)));

    hold on;
    % generating confidence intervals with bootstrapping method
    if generate_ci
        [lower_bound_thin, upper_bound_thin, lower_bound_med, upper_bound_med, lower_bound_thick, upper_bound_thick] = generate_confidence_ints(data, electrode_index);
        h = patch([time fliplr(time)], [lower_bound_thin fliplr(upper_bound_thin)], [0 0.4470 0.7410]);
        set(h, 'EdgeColor', [0 0.4470 0.7410]);
        set(h, 'facealpha', .08);
        g = patch([time fliplr(time)], [lower_bound_med fliplr(upper_bound_med)], [0.8500 0.3250 0.0980]);
        set(g, 'EdgeColor', [0.8500 0.3250 0.0980]);
        set(g, 'facealpha', .08);
        i = patch([time fliplr(time)], [lower_bound_thick fliplr(upper_bound_thick)], [0.9290 0.6940 0.1250]);
        set(i, 'EdgeColor', [0.9290 0.6940 0.1250]);
        set(i, 'facealpha', .08);

    end

    % more plotting details
    legend("Thin", "Medium", "Thick", "", "", "", 'location', 'northwest');
    xlabel("Time in S");
    ylabel("ERP voltage in µV");
    set(gcf, 'Position', [100, 100, 1200, 600]);
    grid on;
    saveas(gcf, save_dir);
    hold off;
end
