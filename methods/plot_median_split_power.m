function plot_median_split_power(low, high, electrode)

    xlimit = [2.8 3.7];
    ylimit_line = [-1 1];

    electrode_idx = get_electrode_index(low, electrode);

    lowitpc = mean(squeeze(low.powspctrm(electrode_idx,:,:)),1);
    highitpc = mean(squeeze(high.powspctrm(electrode_idx,:,:)),1);

    plot(low.time,lowitpc,'g',high.time,highitpc,'b','LineWidth', 1.4);
    xlim(xlimit);
    ylim(ylimit_line);
    title('Median split power');
    legend("Low", "High");
    xlabel("Time S");
    ylabel("Power db");
    grid on;

end