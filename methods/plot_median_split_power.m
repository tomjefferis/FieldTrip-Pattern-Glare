function plot_median_split_power(low, high)

    xlimit = [2.8 3.7];
    ylimit_line = [0 0.5];
    ylimit = [8 13];


    electrode_idx = 26;

    lowitpc = mean(squeeze(low.powspctrm(electrode_idx,8:13,:)),1);
    highitpc = mean(squeeze(high.powspctrm(electrode_idx,8:13,:)),1);

    plot(low.time,lowitpc,'g',high.time,highitpc,'b','LineWidth', 1.4);
    xlim(xlimit);
    ylim(ylimit_line);
    title('Inter-trial phase coherence Alpha Average');
    legend("Low", "High");
    grid on;

end