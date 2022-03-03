function plot_med_split_itc(low, high,electrode)

    xlimit = [2.8 3.7];
    ylimit_line = [0 0.5];
    ylimit = [8 13];

    electrode_idx = get_electrode_index(low, electrode);

    lowitpc = mean(squeeze(low.itpc(electrode_idx,8:13,:)),1);
    highitpc = mean(squeeze(high.itpc(electrode_idx,8:13,:)),1);

    lowitlc = mean(squeeze(low.itlc(electrode_idx,8:13,:)),1);
    highitlc = mean(squeeze(high.itlc(electrode_idx,8:13,:)),1);

    figure
    subplot(6, 1, 1);
    plot(low.time,lowitpc,'g',high.time,highitpc,'b','LineWidth', 1.4);
    xlim(xlimit);
    ylim(ylimit_line);
    title('Inter-trial phase coherence Alpha Average');
    legend("Low", "High");
    grid on;

    subplot(6, 1, 2);
    plot(low.time,lowitlc,'g',high.time,highitlc,'b','LineWidth', 1.4);
    xlim(xlimit);
    ylim(ylimit_line);
    legend("Low", "High");
    title('Inter-trial linear coherence Alpha Average');
    grid on;

    subplot(6, 1, 3);
    imagesc(low.time, low.freq, squeeze(low.itpc(electrode_idx, :, :)));
    xlim(xlimit);
    ylim(ylimit);
    axis xy
    title('Low Group Inter-trial phase coherence');
    subplot(6, 1, 4);
    imagesc(low.time, low.freq, squeeze(low.itlc(electrode_idx, :, :)));
    xlim(xlimit);
    ylim(ylimit);
    axis xy
    title('Low Group Inter-trial linear coherence');

    subplot(6, 1, 5);
    imagesc(high.time, high.freq, squeeze(high.itpc(electrode_idx, :, :)));
    xlim(xlimit);
    ylim(ylimit);
    axis xy
    title('High Group Inter-trial phase coherence');
    subplot(6, 1, 6);
    imagesc(high.time, high.freq, squeeze(high.itlc(electrode_idx, :, :)));
    xlim(xlimit);
    ylim(ylimit);
    axis xy
    title('High Group Inter-trial linear coherence');


    sgtitle("Median split on ITC for Alpha band");

end
