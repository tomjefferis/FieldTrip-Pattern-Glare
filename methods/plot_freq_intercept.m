function plots = plot_freq_intercept(data, electrode, time, factor, save_dir, paper_figs, font_size)

    if ~exist('font_size','var')
        font_size = 12;
    end

    if time(1) == 0.5
        time(1) = -0.2;
    elseif time(1) == 3.0
        time(2) = 2.8;
    end

    electrode_idx = get_electrode_index(low, electrode);

    data = average_power(data, data{1}.freq);

    dataitpc = mean(squeeze(data.powspctrm(electrode_idx,:,:)),1);
    meditpc = mean(squeeze(data.med_powspctrm(electrode_idx,:,:)),1);



    figure

    subplot(4, 1, 1);
    ax1 = plot(data.time,dataitpc,'g','LineWidth', 1.4);
    xline(electrode.time, '--r');
    yline(0,'--o');
    title('PGI Power');
    legend("PGI","Maximum Effect", 'location', 'eastoutside');
    xl1 = xlabel("Time S");
    ylabel("Power db");
    grid on;
    xlim([time(1), time(end)])
    ylim([min(min(dataitpc)) *1.2 ,max(max(dataitpc))* 1.2])
    

    subplot(4, 1, 2);
    ax2 = plot(data.time,meditpc,'b','LineWidth', 1.4);
    xline(electrode.time, '--r');
    yline(0,'--o');
    title('Medium Power');
    legend("Medium","Maximum Effect", 'location', 'eastoutside');
    xl2 = xlabel("Time S");
    ylabel("Power db");
    grid on;
    xlim([time(1), time(end)])
    ylim([min(min(meditpc)) *1.2 ,max(max(meditpc))* 1.2])

    subplot(4, 1, 3);
    ax3 = imagesc(data.time, data.freq, squeeze(data.powspctrm(electrode_idx, :, :)));
    xlabel("Time S");
    ylabel("Frequency Hz");
    hold on;
    xline(electrode.time, '--r');
    tit = strcat("PGI Power Spectrum");
    title(tit);

    subplot(4, 1, 4);
    ax4 = imagesc(data.time, data.freq, squeeze(data.med_powspctrm(electrode_idx, :, :)));
    xlabel("Time S");
    ylabel("Frequency Hz");
    hold on;
    xline(electrode.time, '--r');
    tit = strcat("Medium Power Spectrum");
    title(tit);


    set(findall(gcf,'-property','FontSize'),'FontSize',font_size);
    set(gcf, 'Position', [100, 100, 1900, 1000]);

    labPos1 = get(xl1, 'Position');
    labPos1(1) = labPos1(1)*1.13;
    labPos1(2) = labPos1(2)/1.2;
    set(xl1, 'Position', labPos1);

    labPos2 = get(xl2, 'Position');
    labPos2(1) = labPos2(1)*1.13;
    labPos2(2) = labPos2(2)/1.17;
    set(xl2, 'Position', labPos2);

    linkaxes([ax3,ax4],'z')

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