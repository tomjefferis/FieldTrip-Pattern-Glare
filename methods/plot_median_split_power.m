function plot_median_split_power(low, high, electrode)

    xlimit = [2.8 3.7];
    ylimit_line = [-2 3];

    electrode_idx = get_electrode_index(low, electrode);

    lowitpc = mean(squeeze(low.powspctrm(electrode_idx,:,:)),1);
    highitpc = mean(squeeze(high.powspctrm(electrode_idx,:,:)),1);

    figure
    subplot(2, 1, 1);
    plot(low.time,lowitpc,'g',high.time,highitpc,'b','LineWidth', 1.4);
    xlim(xlimit);
    ylim(ylimit_line);
    title('Median split power PGI');
    xline(3, '--o', {"Stimulus", "Off"});
    legend("Low", "High","");
    xlabel("Time S");
    ylabel("Power db");
    grid on;



    lowitlc = mean(squeeze(low.med_powspctrm(electrode_idx,:,:)),1);
    highitlc = mean(squeeze(high.med_powspctrm(electrode_idx,:,:)),1);


    subplot(2, 1, 2);
    plot(low.time,lowitlc,'g',high.time,highitlc,'b','LineWidth', 1.4);
    xlim(xlimit);
    ylim(ylimit_line);
    title('Median split power PGI Medium');
    xline(3, '--o', {"Stimulus", "Off"});
    legend("Low", "High","");
    xlabel("Time S");
    ylabel("Power db");
    grid on;



    sgtitle("Median split for Beta band");

end