function GFP_Plotter(results_dir, windowindexs, gfp, time, start_time, end_time, windows)

    save_dir = strcat(results_dir, '\general\gfp_plot.png');
    % plotting GFP plot
    hold off;
    plot(time, gfp, 'r', 'LineWidth', 1.4);
    title('Global Field Power');
    legend('GFP');
    plotting_window = [start_time * 1000, end_time * 1000];
    xlim(plotting_window);
    xlabel('Time in ms');
    ylabel('GFP');
    set(gcf, 'Position', [100, 100, 1200, 600]);
    grid on;
    saveas(gcf, save_dir);

    minbox = min(gfp) - 0.2;
    heightbox = (max(gfp) + 0.2) - (min(gfp) - 0.2);

    if windows

        for index = 1:numel(windowindexs)
            rectlength = time(windowindexs(index).endloc) - time(windowindexs(index).startloc);
            rectangle('Position', [time(windowindexs(index).startloc) minbox rectlength heightbox], 'LineWidth', 2);
        end

    end

    title('Global Field Power With Windows of Analysis');
    save_dir = strcat(results_dir, '\general\gfp_plot_with_windows.png');
    saveas(gcf, save_dir);
end