function plots = plot_median_split_power(low, high, electrode, time, factor, save_dir, paper_figs, font_size)

    if ~exist('font_size','var')
        font_size = 12;
    end


    electrode_idx = get_electrode_index(low, electrode);

    lowitpc = mean(squeeze(low.powspctrm(electrode_idx,:,:)),1);
    highitpc = mean(squeeze(high.powspctrm(electrode_idx,:,:)),1);

    figure

    subplot(4, 2, [1 2]);
    ax1 = plot(low.time,lowitpc,'g',high.time,highitpc,'b','LineWidth', 1.4);
    xline(electrode.time, '--r');
    title('Median split power PGI');
    legend("Low PGI", "High PGI","Maximum Effect", 'location', 'eastoutside');
    xl1 = xlabel("Time S");
    ylabel("Power db");
    grid on;
    xlim([low.time(1), low.time(end)])
    ylim([min(min(lowitpc,highitpc)) *1.2 ,max(max(lowitpc,highitpc))* 1.2])
    

    lowitlc = mean(squeeze(low.med_powspctrm(electrode_idx,:,:)),1);
    highitlc = mean(squeeze(high.med_powspctrm(electrode_idx,:,:)),1);


    subplot(4, 2, [3 4]);
    ax2 = plot(low.time,lowitlc,'g',high.time,highitlc,'b','LineWidth', 1.4);
    xline(electrode.time, '--r');
    title('Median split power Medium');
    legend("Low Medium", "High Medium","Maximum Effect", 'location', 'eastoutside');
    xl2 = xlabel("Time S");
    ylabel("Power db");
    grid on;
    xlim([low.time(1), low.time(end)])
    ylim([min(min(lowitlc,highitlc)) *1.2 ,max(max(lowitlc,highitlc))* 1.2])

    subplot(4, 2, 5);
    ax3 = imagesc(low.time, low.freq, squeeze(low.powspctrm(electrode_idx, :, :)));
    xlabel("Time S");
    ylabel("Power db");
    hold on;
    xline(electrode.time, '--r');
    tit = strcat("Low Group Power Spectrum PGI");
    title(tit);

    subplot(4, 2, 6);
    ax3 = imagesc(high.time, high.freq, squeeze(high.powspctrm(electrode_idx, :, :)));
    xlabel("Time S");
    ylabel("Power db");
    hold on;
    xline(electrode.time, '--r');
    tit = strcat("High Group Power Spectrum PGI");
    title(tit);

    subplot(4, 2, 7);
    ax3 = imagesc(low.time, low.freq, squeeze(low.med_powspctrm(electrode_idx, :, :)));
    xlabel("Time S");
    ylabel("Power db");
    hold on;
    xline(electrode.time, '--r');
    tit = strcat("Low Group Power Spectrum Medium");
    title(tit);

    subplot(4, 2, 8);
    ax3 = imagesc(high.time, high.freq, squeeze(high.med_powspctrm(electrode_idx, :, :)));
    xlabel("Time S");
    ylabel("Power db");
    hold on;
    xline(electrode.time, '--r');
    tit = strcat("High Group Power Spectrum Medium");
    title(tit);

    set(findall(gcf,'-property','FontSize'),'FontSize',font_size);
    set(gcf, 'Position', [100, 100, 1900, 1600]);

    labPos1 = get(xl1, 'Position');
    labPos1(1) = labPos1(1)*1.13;
    labPos1(2) = labPos1(2)/1.2;
    set(xl1, 'Position', labPos1);

    labPos2 = get(xl2, 'Position');
    labPos2(1) = labPos2(1)*1.13;
    labPos2(2) = labPos2(2)/1.17;
    set(xl2, 'Position', labPos2);

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

if ~paper_figs
    sgtitle(strcat("Median split for power ",factor, "at ",electrode.electrode));
    imgname = strcat(imgname);
    save_dir_full = strcat(save_dir, "/", results_fact, "/", imgname);
    saveas(gcf, save_dir_full);
    hold off;
end

plots = gcf

end