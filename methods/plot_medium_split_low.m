function plot_medium_split_low(high, low, electrode, start_time, end_time, generate_cis)

% plots the PGI median split, low vs high on the same plot
% 
% Use as:
%       plot_medium_split_low(high, low, electrode, start_time, end_time, generate_cis)
%   
%   

    start_window_time = start_time;
    end_window_time = end_time;

    if start_time >= 2.8
        start_time = 2.8;
        end_time = 3.99;
    else
        start_time = -0.2;
        end_time = 3.1;
    end

    electrode_idx = get_electrode_index(high.data, electrode);

    cfg = [];
    cfg.channel = 'all';
    cfg.latency = 'all';
    time = low.data{1}.time;
    high_avg = ft_timelockgrandaverage(cfg, high.data{:});
    low_avg = ft_timelockgrandaverage(cfg, low.data{:});

    plot(time, low_avg.avg(electrode_idx, :), 'g', time, high_avg.avg(electrode_idx, :), 'b', 'LineWidth', 2);
    hold on;
    yline(0, '--');
    tit = " Low vs High Median Split on PGI ";
    xlim([start_time, end_time]);

    xline(3, '--', 'LineWidth', 2);
    xline(0.5, '-', 'LineWidth', 2);

    if start_window_time > 3
        xline(0, '-', 'LineWidth', 2);
        xline(start_window_time, '--m','LineWidth', 2);
        xline(end_window_time, '--m','LineWidth', 2);
    else
        xline(start_window_time, '-', 'LineWidth', 2);
        xline(4, '--m','LineWidth', 2);
        xline(4, '--m','LineWidth', 2);
    end

    xline(electrode.time, '--r', 'DisplayName', 'Max Effect','LineWidth', 2);
    title(tit);
    subtitle(strcat("Maximum T Value = ", string(electrode.t_value)));
    xlabel("Time in S");
    ylabel("Voltage in µV");
    set(gcf, 'Position', [100, 100, 1200, 600]);
    grid on;
    set(gca, 'LineWidth', 2);
    if generate_cis
        [lower_lower_bound, lower_upper_bound] = generate_cis_pgi(low.data, electrode_idx, 20);
        h = patch([time fliplr(time)], [lower_lower_bound fliplr(lower_upper_bound)], 'g');
        set(h, 'facealpha', .1);
        [upper_lower_bound, upper_upper_bound] = generate_cis_pgi(high.data, electrode_idx, 20);
        h = patch([time fliplr(time)], [upper_lower_bound fliplr(upper_upper_bound)], 'b');
        set(h, 'facealpha', .1);
    end

    legend("Low", "High", "", "","","","", 'location', 'northwest');
    hold off;

end