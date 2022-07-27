function plot_median_split_power(low, high, electrode, time, factor, save_dir)

    xlimit = time;
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
    title('Median split power Medium');
    xline(3, '--o', {"Stimulus", "Off"});
    legend("Low", "High","");
    xlabel("Time S");
    ylabel("Power db");
    grid on;



    if contains(factor, "habituation") || contains(factor, "sensitization")

        if contains(factor, "visual")
            results_fact = "visual-stress";
            imgname = "visual-stress partitions power map.png";
        elseif contains(factor, "headache")
            results_fact = "headache";
            imgname = "headache partitions power map.png";
        elseif contains(factor, "discomfort")
            results_fact = "discomfort";
            imgname = "discomfort partitions power map.png";
        else
            results_fact = "none";
            imgname = strcat("none partitions power map.png");
        end

    else
        results_fact = factor;
        imgname = strcat(factor, " ", string(time(1)), " onsets power map.png");
    end


    sgtitle(strcat("Median split for power ",factor, "at ",electrode.electrode));
    imgname = strcat(imgname);
    save_dir_full = strcat(save_dir, "/", results_fact, "/", imgname);
    saveas(gcf, save_dir_full);
    hold off;

end