% FILEPATH: w:\PhD\PatternGlareCode\FieldTrip-Pattern-Glare\methods\generate_erp_plot_alt.m
%
% generate_erp_plot_alt - Generates ERP plots for a given electrode and time window.
%
% Syntax:  plots = generate_erp_plot_alt(results_dir, start_time, end_time, data, significant_electrode, factor, generate_ci, polarity, paper_plot)
%
% Inputs:
%    results_dir - Directory to save the generated plots.
%    start_time - Start time of the time window to plot.
%    end_time - End time of the time window to plot.
%    data - EEG data structure.
%    significant_electrode - Structure containing information about the significant electrode.
%    factor - Factor to plot the ERP for.
%    generate_ci - Flag to generate confidence intervals.
%    polarity - Polarity of the ERP.
%    paper_plot - Flag to generate a paper plot.
%
% Outputs:
%    plots - Generated ERP plot.
%
% Example:
%    plots = generate_erp_plot_alt('results_dir', 0, 1, data, significant_electrode, 'visual', true, 'positive', false);
%
% Other m-files required: split_data.m, get_electrode_index.m, generate_confidence_ints.m
% Subfunctions: none
% MAT-files required: none
%
% See also: ft_timelockgrandaverage, ft_timelockbaseline, patch, xline, yline, xlim, ylim, xlabel, ylabel, title, subtitle, legend, saveas, grid, set, hold, plot
function plots = generate_erp_plot_alt(results_dir, start_time, end_time, data, significant_electrode, factor, generate_ci, polarity, paper_plot)

% Generating erp plots for no factor

    start_window_time = start_time;
    end_window_time = end_time;

    if start_time >= 2.8
        start_time = 2.8;
        end_time = 3.99;
    else
        start_time = -0.2;
        end_time = 3.1;
    end
    if contains(factor, "visual")
            factor = "Visual-Stress";
            
        elseif contains(factor, "headache")
            factor = "Headache";
            
        elseif contains(factor, "discomfort")
            factor = "Discomfort";
            
        else
            factor = "None";
            
        end

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

    %high = 3;
    %low = -3;%ylimit_finder(data, significant_electrode);

    plot(time, y1, 'Color', [0.8350 0.0780 0.1840], 'LineWidth', 2);
    hold on;
    plot(time, y2, 'Color', [0.4660 0.8740 0.1880], 'LineWidth', 2);
    plot(time, y3, 'Color', [0.3010 0.7450 0.9330], 'LineWidth', 2);
    xlim(plotting_window);
    %ylim([low high]);
    yline(0, '--');

    xline(significant_electrode.time, '--r', 'DisplayName', 'Max Effect','LineWidth', 2);
    xline(3, '--', 'LineWidth', 2);
    xline(0.5, '-', 'LineWidth', 2);



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

   if start_window_time > 3
        xline(0, '-', 'LineWidth', 2);
        xline(start_window_time, '--m','LineWidth', 2);
        xline(end_window_time, '--m','LineWidth', 2);
    else
        xline(start_window_time, '-', 'LineWidth', 2);
        xline(4, '--m','LineWidth', 2);
        xline(4, '--m','LineWidth', 2);
    end

    % more plotting details
    
    legend("P1", "P2", "P3", "", "Max Effect", "","","","", 'location', 'northwestoutside');
    xlabel("Time in S");
    ylabel("ERP voltage in µV");
    set(gcf, 'Position', [100, 100, 800, 300]);
    grid on;
    set(gca, 'LineWidth', 2);
    if ~paper_plot
        title(graph_title);
        subtitle(strcat("Maximum T Value = ", string(significant_electrode.t_value)));
        saveas(gcf, save_dir);
    end
    hold off;
    plots = gcf;
end
