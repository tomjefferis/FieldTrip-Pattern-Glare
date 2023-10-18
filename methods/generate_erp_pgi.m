% Generates ERP plots for PGI (Pattern Glare Index) for a given electrode and time window.
% 
% plots = generate_erp_pgi(results_dir, start_time, end_time, data, significant_electrode, factor, generate_ci, polarity, paper_plot)
%
% INPUTS:
% - results_dir: directory to save the generated plots
% - start_time: start time of the time window for the plot
% - end_time: end time of the time window for the plot
% - data: cell array of FieldTrip data structures
% - significant_electrode: structure containing information about the significant electrode
% - factor: factor to plot the ERP for (can be "visual-stress", "headache", "discomfort", or "none")
% - generate_ci: boolean indicating whether to generate confidence intervals for the plot
% - polarity: string indicating the polarity of the ERP ("pos" or "neg")
% - paper_plot: boolean indicating whether to generate a plot suitable for publication
%
% OUTPUTS:
% - plots: handle to the generated plot
function plots = generate_erp_pgi(results_dir, start_time, end_time, data, significant_electrode, factor, generate_ci, polarity, paper_plot)

    % Generating erp plots for no factor (similar to previous method, just for PGI instead of individual factors)

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
            factor = "visual-stress";
            
        elseif contains(factor, "headache")
            factor = "headache";
            
        elseif contains(factor, "discomfort")
            factor = "discomfort";
            
        else
            factor = "none";
            
        end

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

    temp = data{1};
    temp.PGI = true;
    data{1} = temp;
    [high, low] = ylimit_finder(data, significant_electrode);
    plot(time, y1, 'g', 'LineWidth', 1.6);
    hold on;
    plot([significant_electrode.sig_start,significant_electrode.sig_end],[0,0] ,'b','LineWidth', 2);
    xlim(plotting_window);
    ylim([low high]);
    yline(0, '--');

    

    %xline(end_window_time, '-', {"Window End"});
    xline(significant_electrode.time, '--r','LineWidth', 2);
    
    hold on;

    if generate_ci
        [lower_bound, upper_bound] = generate_cis_pgi(data, electrode_index, 40);

        h = patch([time fliplr(time)], [lower_bound fliplr(upper_bound)], 'g');
        set(h, 'facealpha', .05);

    end

    
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


    legend(gfp, "Duration","","Max Effect",'location', 'northwestoutside');
    xlabel("Time in S");
    ylabel("ERP voltage in µV");
    set(gcf, 'Position', [100, 100, 1600, 600]);
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