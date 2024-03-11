function plots = plot_median_split_power(low, high, electrode, time, factor, save_dir, paper_figs, font_size,baselinet)

    if ~exist('font_size','var')
        font_size = 12;
    end

    if time(1) == 0.5
        time(1) = baselinet(1);
        window = 0.5;
        baseline = baselinet(1,1);
        baselineS = baselinet(1,2);
    elseif time(1) == 3.0
        time(1) = 2.8;
        window = 3;
        baseline = 2.95;
        baselineS = 2.75;
    end

    electrode_idx = get_electrode_index(low, electrode);

    lowitpc = mean(squeeze(low.powspctrm(electrode_idx,:,:)),1);
    highitpc = mean(squeeze(high.powspctrm(electrode_idx,:,:)),1);

    figure

    subplot(4, 2, [1 2]);
    ax1 = plot(low.time,lowitpc,'g',high.time,highitpc,'b','LineWidth', 1.4);
    title('Median split power PGI');
    xl1 = xlabel("Time S");
    ylabel("Power db");
    xline(electrode.time, '--r');
    xline(baseline,'-m','LineWidth',1);
    xline(baselineS,'-m','LineWidth',1);
    xline(window,'-','LineWidth',1);
    legend("Low PGI", "High PGI","Maximum Effect","Baseline End", "Baseline Start", "Window Start", 'location', 'eastoutside');
    grid on;
    xlim([time(1), time(end)])
    ylim([min(min(lowitpc,highitpc)) *1.2 ,max(max(lowitpc,highitpc))* 1.2])
    

    lowitlc = mean(squeeze(low.med_powspctrm(electrode_idx,:,:)),1);
    highitlc = mean(squeeze(high.med_powspctrm(electrode_idx,:,:)),1);


    subplot(4, 2, [3 4]);
    ax2 = plot(low.time,lowitlc,'g',high.time,highitlc,'b','LineWidth', 1.4);
    title('Median split power Medium');
    xl2 = xlabel("Time S");
    ylabel("Power db");
    xline(electrode.time, '--r');
    xline(baseline,'-m','LineWidth',1);
    xline(baselineS,'-m','LineWidth',1);
    xline(window,'-','LineWidth',1);
    legend("Low Medium", "High Medium","Maximum Effect","Baseline End","Baseline Start", "Window Start", 'location', 'eastoutside');
    grid on;
    xlim([time(1), time(end)])
    ylim([min(min(lowitlc,highitlc)) *1.2 ,max(max(lowitlc,highitlc))* 1.2])

    pgimax = round(max(max(max(squeeze(low.powspctrm(electrode_idx, :, :)),squeeze(high.powspctrm(electrode_idx, :, :))))))
    pgimin = round(min(min(min(squeeze(low.powspctrm(electrode_idx, :, :)),squeeze(high.powspctrm(electrode_idx, :, :))))))
    pgirange = [pgimin,pgimax];

    medmax = round(max(max(max(squeeze(low.med_powspctrm(electrode_idx, :, :)),squeeze(high.med_powspctrm(electrode_idx, :, :))))))
    medmin = round(min(min(min(squeeze(low.med_powspctrm(electrode_idx, :, :)),squeeze(high.med_powspctrm(electrode_idx, :, :))))))
    medrange = [medmin,medmax];

    subplot(4, 2, 5);
    ax3 = surf(low.time, low.freq, squeeze(low.powspctrm(electrode_idx, :, :)),'EdgeColor','none');
    shading interp
    colorbar;
    view(2);
    xlim([time(1), time(end)])
    ylim([low.freq(1), low.freq(end)])
    xlabel("Time S");
    ylabel("Frequency Hz");
    caxis(pgirange);
    hold on;
    xline(electrode.time, '--r');
    xline(baseline,'-m','LineWidth',1);
    xline(baselineS,'-m','LineWidth',1);
    xline(window,'-','LineWidth',1);
    tit = strcat("Low Group Power Spectrum PGI");
    title(tit);

    subplot(4, 2, 6);
    ax4 = surf(high.time, high.freq, squeeze(high.powspctrm(electrode_idx, :, :)),'EdgeColor','none');
    shading interp
    colorbar;
    view(2);
    xlim([time(1), time(end)])
    ylim([low.freq(1), low.freq(end)])
    caxis(pgirange);
    xlabel("Time S");
    ylabel("Frequency Hz");
    hold on;
    xline(electrode.time, '--r');
    xline(baseline,'-m','LineWidth',1);
    xline(baselineS,'-m','LineWidth',1);
    xline(window,'-','LineWidth',1);
    tit = strcat("High Group Power Spectrum PGI");
    title(tit);

    subplot(4, 2, 7);
    ax5 = surf(low.time, low.freq, squeeze(low.med_powspctrm(electrode_idx, :, :)),'EdgeColor','none');
    shading interp
    colorbar;
    view(2);
    xlim([time(1), time(end)])
    ylim([low.freq(1), low.freq(end)])
    caxis(medrange);
    xlabel("Time S");
    ylabel("Frequency Hz");
    hold on;
    xline(electrode.time, '--r');
    xline(baseline,'-m','LineWidth',1);
    xline(baselineS,'-m','LineWidth',1);
    xline(window,'-','LineWidth',1);
    tit = strcat("Low Group Power Spectrum Medium");
    title(tit);

    subplot(4, 2, 8);
    ax6 = surf(high.time, high.freq, squeeze(high.med_powspctrm(electrode_idx, :, :)),'EdgeColor','none');
    shading interp
    colorbar;
    view(2);
    xlim([time(1), time(end)])
    ylim([low.freq(1), low.freq(end)])
    caxis(medrange);
    xlabel("Time S");
    ylabel("Frequency Hz");
    hold on;
    xline(electrode.time, '--r');
    xline(baseline,'-m','LineWidth',1);
    xline(baselineS,'-m','LineWidth',1);
    xline(window,'-','LineWidth',1);
    tit = strcat("High Group Power Spectrum Medium");
    title(tit);

    set(findall(gcf,'-property','FontSize'),'FontSize',font_size);
    set(gcf, 'Position', [100, 100, 1400, 1600]);

    labPos1 = get(xl1, 'Position');
    labPos1(1) = labPos1(1)*1.4;
    labPos1(2) = labPos1(2)/1.2;
    %SlabPos1 = [-0.3,-0.7598,-1];
    set(xl1, 'Position', labPos1);

    labPos2 = get(xl2, 'Position');
    labPos2(1) = labPos2(1)*1.4;
    labPos2(2) = labPos2(2)/1.2;
    %labPos2 = [-0.3,-3.20,-1];
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