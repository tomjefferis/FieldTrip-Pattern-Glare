function generate_erp_pgi(results_dir, start_time, end_time, data, significant_electrode, factor, generate_ci, polarity)

    % Generating erp plots for no factor (similar to previous method, just for PGI instead of individual factors)

    start_window_time = start_time;
    end_window_time = end_time;

    start_time = 2.8;
    end_time = 3.99;

    save_dir = strcat(results_dir, "\", factor, "\");
    plotting_window = [start_time, end_time];

    cfg = [];
    cfg.channel = 'all';
    cfg.latency = 'all';
    %pgi = get_PGI(data);

    % Get electrode index
    electrode_index = get_electrode_index(data, significant_electrode);
    electrode_name = string(significant_electrode.electrode);

    gfp = "PGI";
    grandavg = ft_timelockgrandaverage(cfg, data{:});
    graph_title = strcat("ERP at ", electrode_name, " Between ", string(start_time), "s and ", string(end_time), "s");
    save_dir = strcat(save_dir, electrode_name, string(start_window_time), " ", string(end_window_time), polarity, "erpPGI.png");
    electrode_index = get_electrode_index(data, significant_electrode);
    electrode_name = string(significant_electrode.electrode);
    time = data{1}.time;
    y1 = grandavg.avg(electrode_index, :);

    plot(time, y1, 'g', 'LineWidth', 1.4);
    xlim(plotting_window);
    ylim([-6, 6]);
    yline(0, '--');

    if ~(start_window_time == 3)
        xline(3, '--o', {"Stimulus", "Off"});
        xline(start_window_time, '-', {"Window Start"});
    else
        xline(3, '--o', {"Stimulus Off", "Window Start"});
    end

    xline(end_window_time, '-', {"Window End"});
    xline(significant_electrode.time, '--r', {"Maximum", "Effect"});
    title(graph_title);
    subtitle(strcat("Maximum T Value = ", string(significant_electrode.t_value)));
    hold on;

    if generate_ci
        [lower_bound, upper_bound] = generate_cis_pgi(data, electrode_index, 40);

        h = patch([time fliplr(time)], [lower_bound fliplr(upper_bound)], 'g');
        set(h, 'facealpha', .05);

    end

    legend(gfp, "", 'location', 'northwest');
    xlabel("Time in S");
    ylabel("ERP voltage in µV");
    set(gcf, 'Position', [100, 100, 1200, 600]);
    grid on;
    saveas(gcf, save_dir);
    hold off;
end