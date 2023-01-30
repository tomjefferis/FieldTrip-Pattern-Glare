function plot_partitions_freq_power(dataone, datatwo, datathree, electrode, design2, factor, results, start, endtime)

    [low1, high1] = median_split(dataone, 1, design2);
    [low2, high2] = median_split(datatwo, 1, design2);
    [low3, high3] = median_split(datathree, 1, design2);

    [highl, lowl] = ylimit_finder(high1, electrode);

    cfg = [];
    low1 = ft_freqgrandaverage(cfg, low1.data{:});
    high1 = ft_freqgrandaverage(cfg, high1.data{:});
    low2 = ft_freqgrandaverage(cfg, low2.data{:});
    high2 = ft_freqgrandaverage(cfg, high2.data{:});
    low3 = ft_freqgrandaverage(cfg, low3.data{:});
    high3 = ft_freqgrandaverage(cfg, high3.data{:});

    xlimit = [low1.time(1), low1.time(end)];
    ylimit_line = [lowl, highl];
    %start = 2.8;
    f1 = figure;

    electrode_idx = get_electrode_index(low1, electrode);    

    lowitpc1 = mean(squeeze(low1.powspctrm(electrode_idx, :, :)), 1);
    highitpc1 = mean(squeeze(high1.powspctrm(electrode_idx, :, :)), 1);
    lowitpc2 = mean(squeeze(low2.powspctrm(electrode_idx, :, :)), 1);
    highitpc2 = mean(squeeze(high2.powspctrm(electrode_idx, :, :)), 1);
    lowitpc3 = mean(squeeze(low3.powspctrm(electrode_idx, :, :)), 1);
    highitpc3 = mean(squeeze(high3.powspctrm(electrode_idx, :, :)), 1);

    if contains(factor, "onsets-23-45-67")
        legend1 = ["Onsets 2,3 PGI", "Onsets 4,5 PGI", "Onsets 6,7 PGI", "", "", ""];
        legend2 = ["Onsets 2,3 Med", "Onsets 4,5 Med", "Onsets 6,7 Med", "", "", ""];

        title1 = 'Onsets 2,3';
        title2 = 'Onsets 4,5';
        title3 = 'Onsets 6,7';
        title4 = 'onsets';
    else
        legend1 = ["Partition 1 PGI", "Partition 2 PGI", "Partition 3 PGI", "", "", ""];
        legend2 = ["Partition 1 Med", "Partition 2 Med", "Partition 3 Med", "", "", ""];

        title1 = 'Partition 1';
        title2 = 'Partition 2';
        title3 = 'Partition 3';
        title4 = 'Partitions';
    end

    % First subplot low PGI across partitions
    Ax = subplot(4, 2, 1);
    plot(low1.time, lowitpc1, 'g', low1.time, lowitpc2, 'b', low1.time, lowitpc3, 'r', 'LineWidth', 1.4);
    xlim(xlimit);
    ylim(ylimit_line);
    title(title1);
    xline(3, '--o', {"Stimulus", "Off"});
    xlabel("Time S");
    ylabel("Power db");
    grid on;
    hold on;
    xline(electrode.time, '--r', {"Maximum Effect"}, 'LabelOrientation', 'horizontal','LabelVerticalAlignment','bottom','LabelHorizontalAlignment','right');
    legend(legend1, 'location', 'eastoutside');
    tit = strcat("Low Group PGI ", title4, " @ ", electrode.electrode);
    title(tit);

    Ax = subplot(4, 2, 2);
    plot(high1.time, highitpc1, 'g', high1.time, highitpc2, 'b', high1.time, highitpc3, 'r', 'LineWidth', 1.4);
    xlim(xlimit);
    ylim(ylimit_line);
    title(title1);
    xline(3, '--o', {"Stimulus", "Off"});
    xlabel("Time S");
    ylabel("Power db");
    grid on;
    hold on;
    xline(electrode.time, '--r', {"Maximum Effect"}, 'LabelOrientation', 'horizontal','LabelVerticalAlignment','bottom','LabelHorizontalAlignment','right');
    legend(legend1, 'location', 'eastoutside');
    tit = strcat("High Group PGI ", title4, " @ ", electrode.electrode);
    title(tit);

    Ax = subplot(4, 2, 3);
    imagesc(low1.time, low1.freq, squeeze(low1.powspctrm(electrode_idx, :, :)));
    xlim(xlimit);
%    ylim(ylimit);
    axis xy
    xlabel("Time S");
    ylabel("Power db");
    hold on;
    xline(electrode.time, '--r', {"Maximum Effect"}, 'LabelOrientation', 'horizontal','LabelVerticalAlignment','bottom','LabelHorizontalAlignment','right');
    tit = strcat("Low group power spectrum ", title1, " @ ", electrode.electrode);
    title(tit);

    Ax = subplot(4, 2, 4);
    imagesc(high1.time, high1.freq, squeeze(high1.powspctrm(electrode_idx, :, :)));
    xlim(xlimit);
    %ylim(ylimit);
    axis xy
    xlabel("Time S");
    ylabel("Power db");
    hold on;
    xline(electrode.time, '--r', {"Maximum Effect"}, 'LabelOrientation', 'horizontal','LabelVerticalAlignment','bottom','LabelHorizontalAlignment','right');
    tit = strcat("High group power spectrum ", title1, " @ ", electrode.electrode);
    title(tit);

    Ax = subplot(4, 2, 5);
    imagesc(low2.time, low2.freq, squeeze(low2.powspctrm(electrode_idx, :, :)));
    xlim(xlimit);
    %ylim(ylimit);
    axis xy
    xlabel("Time S");
    ylabel("Power db");
    hold on;
    xline(electrode.time, '--r', {"Maximum Effect"}, 'LabelOrientation', 'horizontal','LabelVerticalAlignment','bottom','LabelHorizontalAlignment','right');
    tit = strcat("Low group power spectrum ", title2, " @ ", electrode.electrode);
    title(tit);

    Ax = subplot(4, 2, 6);
    imagesc(high2.time, high2.freq, squeeze(high2.powspctrm(electrode_idx, :, :)));
    xlim(xlimit);
    %ylim(ylimit);
    axis xy
    xlabel("Time S");
    ylabel("Power db");
    hold on;
    xline(electrode.time, '--r', {"Maximum Effect"}, 'LabelOrientation', 'horizontal','LabelVerticalAlignment','bottom','LabelHorizontalAlignment','right');
    tit = strcat("High group power spectrum ", title2, " @ ", electrode.electrode);
    title(tit);

    Ax = subplot(4, 2, 7);
    imagesc(low3.time, low3.freq, squeeze(low3.powspctrm(electrode_idx, :, :)));
    xlim(xlimit);
   % ylim(ylimit);
    axis xy
    xlabel("Time S");
    ylabel("Power db");
    hold on;
    xline(electrode.time, '--r', {"Maximum Effect"}, 'LabelOrientation', 'horizontal','LabelVerticalAlignment','bottom','LabelHorizontalAlignment','right');
    tit = strcat("Low group power spectrum ", title3, " @ ", electrode.electrode);
    title(tit);

    Ax = subplot(4, 2, 8);
    imagesc(high3.time, high3.freq, squeeze(high3.powspctrm(electrode_idx, :, :)));
    xlim(xlimit);
    %ylim(ylimit);
    axis xy
    xlabel("Time S");
    ylabel("Power db");
    hold on;
    xline(electrode.time, '--r', {"Maximum Effect"}, 'LabelOrientation', 'horizontal','LabelVerticalAlignment','bottom','LabelHorizontalAlignment','right');
    tit = strcat("High group power spectrum ", title3, " @ ", electrode.electrode);
    title(tit);

    %titles = strcat("Interactions through ", title4, " Low vs High group ", factor);
    %f1.Position = f1.Position + [0 -300 0 300];
    set(gcf, 'Position', [100, 100, 1300, 800]);
    %sgtitle(titles);
    freqmin = high1.freq(1);
    freqmax = high1.freq(end);

    name = strcat(results, "/partitions/", factor, electrode.electrode, '_', string(freqmin), '_', string(freqmax), '_erpcombined.png');
    saveas(gcf, name);

end
