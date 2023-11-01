function plots = plot_freq_intercept(data, electrode, time, factor, save_dir, paper_figs, font_size, baseline)

    if ~exist('font_size','var')
        font_size = 12;
    end
    if time(1) == 0.5
        time(1) = baseline(1);
        window = 0.5;
        baselineS = baseline(1,2);
        baseline = baseline(1,1);
    elseif time(1) == 3.0
        time(1) = 2.8;
        window = 3;
        baseline = 2.95;
        baselineS = 2.75;
    end

    electrode_idx = get_electrode_index(data, electrode);

    data = average_power(data, [data{1}.freq(1) data{1}.freq(end)]);

    dataitpc = mean(squeeze(data.powspctrm(electrode_idx,:,:)),1);
    meditpc = mean(squeeze(data.med_powspctrm(electrode_idx,:,:)),1);
    thickitpc = mean(squeeze(data.thick_powspctrm(electrode_idx,:,:)),1);
    thinitpc = mean(squeeze(data.thin_powspctrm(electrode_idx,:,:)),1);

    minmed = round(min(min(min(min(squeeze(data.med_powspctrm(electrode_idx, :, :)))))) - 0.5);
    maxmed = round(max(max(max(max(squeeze(data.med_powspctrm(electrode_idx, :, :)))))) + 0.5);
    medrange = [minmed, maxmed];

    minpgi = round(min(min(min(min(min(squeeze(data.powspctrm(electrode_idx, :, :)))))))- 0.5);
    maxpgi = round(max(max(max(max(max(squeeze(data.powspctrm(electrode_idx, :, :))))))) + 0.5);
    pgirange = [minpgi, maxpgi];

    xlimit = [data.time(1),data.time(end)];

    figure

    subplot(4, 1, 1);
    ax1 = plot(data.time,dataitpc,'g','LineWidth', 1.4);
    xline(baseline,'-m','LineWidth',1);
    xline(baselineS,'-m','LineWidth',1);
    xline(electrode.time, '--r');
    xline(window,'-','LineWidth',1);
    yline(0,'--o');
    title('PGI Power');
    legend("PGI","Baseline End","Baseline Start", "Max Effect", "Window Start", 'location', 'eastoutside');
    xl1 = xlabel("Time S");
    ylabel("Power db");
    grid on;
    xlim([time(1), time(end)])
    

    subplot(4, 1, 2);
    ax2 = plot(data.time,meditpc,'b', data.time, thickitpc, 'r', data.time, thinitpc, 'g','LineWidth', 1.4);
    xline(baseline,'-m','LineWidth',1);
    xline(baselineS,'-m','LineWidth',1);
    xline(electrode.time, '--r');
    xline(window,'-','LineWidth',1);
    yline(0,'--o');
    title('Medium Power');
    legend("Medium","Thick","Thin","Baseline End","Baseline End", "Max Effect", "Window Start", 'location', 'eastoutside');
    xl2 = xlabel("Time S");
    ylabel("Power db");
    grid on;
    xlim([time(1), time(end)])

    subplot(4, 1, 3);
    ax3 = surf(data.time, data.freq, squeeze(data.powspctrm(electrode_idx, :, :)));
    view(2);
    shading interp;
    colorbar;
    xlabel("Time S");
    xlim(xlimit);
    caxis(pgirange);
    ylim([data.freq(1),data.freq(end)])
    ylabel("Frequency Hz");
    hold on;
    xline(baseline,'-m','LineWidth',1);
    xline(baselineS,'-m','LineWidth',1);
    xline(electrode.time, '--r');
    xline(window,'-','LineWidth',1);
    tit = strcat("PGI Power Spectrum");
    title(tit);

    subplot(4, 1, 4);
    ax4 = surf(data.time, data.freq, squeeze(data.med_powspctrm(electrode_idx, :, :)));
    view(2);
    shading interp;
    xlim(xlimit);
    caxis(medrange);
    ylim([data.freq(1),data.freq(end)])
    colorbar;
    xlabel("Time S");
    ylabel("Frequency Hz");
    hold on;
    xline(baseline,'-m','LineWidth',1);
    xline(baselineS,'-m','LineWidth',1);
    xline(electrode.time, '--r');
    xline(window,'-','LineWidth',1);
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