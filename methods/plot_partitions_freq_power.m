function plots = plot_partitions_freq_power(dataone, datatwo, datathree, electrode, design2, factor, results, paper_figs, time, font_size)

if ~exist('font_size','var')
    font_size = 12;
end

if time(1) == 0.5
    time(1) = -0.2;
    window = 0.5;
    baseline = 0;
elseif time(1) == 3.0
    time(1) = 2.8;
    window = 3;
    baseline = 3;
end

[low1, high1] = median_split(dataone, 1, design2);
[low2, high2] = median_split(datatwo, 1, design2);
[low3, high3] = median_split(datathree, 1, design2);


cfg = [];
low1 = ft_freqgrandaverage(cfg, low1.data{:});
high1 = ft_freqgrandaverage(cfg, high1.data{:});
low2 = ft_freqgrandaverage(cfg, low2.data{:});
high2 = ft_freqgrandaverage(cfg, high2.data{:});
low3 = ft_freqgrandaverage(cfg, low3.data{:});
high3 = ft_freqgrandaverage(cfg, high3.data{:});

xlimit = [time(1), time(end)];
%start = 2.8;
f1 = figure;

electrode_idx = get_electrode_index(low1, electrode);

lowitpc1 = mean(squeeze(low1.powspctrm(electrode_idx, :, :)), 1);
highitpc1 = mean(squeeze(high1.powspctrm(electrode_idx, :, :)), 1);
lowitpc2 = mean(squeeze(low2.powspctrm(electrode_idx, :, :)), 1);
highitpc2 = mean(squeeze(high2.powspctrm(electrode_idx, :, :)), 1);
lowitpc3 = mean(squeeze(low3.powspctrm(electrode_idx, :, :)), 1);
highitpc3 = mean(squeeze(high3.powspctrm(electrode_idx, :, :)), 1);

if contains(factor,"onsets") || contains(factor,"Onsets")
    legend1 = ["Onsets 2,3 PGI", "Onsets 4,5 PGI", "Onsets 6,7 PGI", "Baseline End", "Max Effect", "Window Start"];
    legend2 = ["Onsets 2,3 Med", "Onsets 4,5 Med", "Onsets 6,7 Med", "", "Max Effect", ""];
    
    title1 = 'Onsets 2,3';
    title2 = 'Onsets 4,5';
    title3 = 'Onsets 6,7';
    title4 = 'Onsets';
else
    legend1 = ["Partition 1 PGI", "Partition 2 PGI", "Partition 3 PGI", "Baseline End", "Max Effect", "Window Start"];
    legend2 = ["Partition 1 Med", "Partition 2 Med", "Partition 3 Med", "", "Max Effect", ""];
    
    title1 = 'Partition 1';
    title2 = 'Partition 2';
    title3 = 'Partition 3';
    title4 = 'Partitions';
end


% First subplot low PGI across partitions
ax1 = subplot(4, 2, 1);
plot(low1.time, lowitpc1, 'g', low1.time, lowitpc2, 'b', low1.time, lowitpc3, 'r', 'LineWidth', 1.4);
title(title1);
xlabel("Time S");
ylabel(strcat(title4," PGI"),"Rotation",0,'HorizontalAlignment','right','fontweight','bold');
grid on;
hold on;
xline(baseline,'-m','LineWidth',1);
xline(electrode.time, '--r');
xline(window,'-','LineWidth',1);
xlim([time(1), time(end)])
leg1 = legend(legend1, 'location', 'eastoutside');
tit = strcat("Low Group");
title(tit);

ax2 = subplot(4, 2, 2);
plot(high1.time, highitpc1, 'g', high1.time, highitpc2, 'b', high1.time, highitpc3, 'r', 'LineWidth', 1.4);
title(title1);
xlabel("Time S");
ylabel("Power db");
grid on;
hold on;
xline(baseline,'-m','LineWidth',1);
xline(electrode.time, '--r');
xline(window,'-','LineWidth',1);
xlim([time(1), time(end)])
leg2 = legend(legend1, 'location', 'westoutside');
tit = strcat("High Group");
title(tit);

pgimax = round(max(max(max(max(max(squeeze(low1.powspctrm(electrode_idx, :, :)), ...
    squeeze(high1.powspctrm(electrode_idx, :, :))), ...
    max(squeeze(low2.powspctrm(electrode_idx, :, :)), ...
    squeeze(high2.powspctrm(electrode_idx, :, :)))), ...
    max(max(squeeze(low3.powspctrm(electrode_idx, :, :)), ...
    squeeze(high3.powspctrm(electrode_idx, :, :))))))));

pgimin = round(min(min(min(min(min(squeeze(low1.powspctrm(electrode_idx, :, :)), ...
    squeeze(high1.powspctrm(electrode_idx, :, :))), ...
    min(squeeze(low2.powspctrm(electrode_idx, :, :)), ...
    squeeze(high2.powspctrm(electrode_idx, :, :)))), ...
    min(min(squeeze(low3.powspctrm(electrode_idx, :, :)), ...
    squeeze(high3.powspctrm(electrode_idx, :, :))))))));
pgirange = [pgimin,pgimax];


ax3 = subplot(4, 2, 3);
imagesc(low1.time, low1.freq, squeeze(low1.powspctrm(electrode_idx, :, :)),pgirange);
colorbar;
xlabel("Time S");
xlim([time(1), time(end)])
ylabel(strcat(title1," PGI"),"Rotation",0,'HorizontalAlignment','right','fontweight','bold');
hold on;
xline(baseline,'-m','LineWidth',1);
xline(electrode.time, '--r');
xline(window,'-','LineWidth',1);
tit = strcat("Power Spectrum @ ", electrode.electrode);
title(tit);

ax4 = subplot(4, 2, 4);
imagesc(high1.time, high1.freq, squeeze(high1.powspctrm(electrode_idx, :, :)),pgirange);
colorbar;
xlabel("Time S");
xlim([time(1), time(end)])
ylabel("Frequency Hz");
hold on;
xline(baseline,'-m','LineWidth',1);
xline(electrode.time, '--r');
xline(window,'-','LineWidth',1);
tit = strcat("Power Spectrum @ ", electrode.electrode);
title(tit);

ax5 = subplot(4, 2, 5);
imagesc(low2.time, low2.freq, squeeze(low2.powspctrm(electrode_idx, :, :)),pgirange);
colorbar;
xlim(xlimit);
%ylim(ylimit);
axis xy
xlabel("Time S");
ylabel(strcat(title2," PGI"),"Rotation",0,'HorizontalAlignment','right','fontweight','bold');
hold on;
xline(baseline,'-m','LineWidth',1);
xline(electrode.time, '--r');
xline(window,'-','LineWidth',1);
tit = strcat("Low group power spectrum ", title2, " @ ", electrode.electrode);
%title(tit);

ax6 = subplot(4, 2, 6);
imagesc(high2.time, high2.freq, squeeze(high2.powspctrm(electrode_idx, :, :)),pgirange);
colorbar;
xlim(xlimit);
%ylim(ylimit);
axis xy
xlabel("Time S");
ylabel("Frequency Hz");
hold on;
xline(baseline,'-m','LineWidth',1);
xline(electrode.time, '--r');
xline(window,'-','LineWidth',1);
tit = strcat("High group power spectrum ", title2, " @ ", electrode.electrode);
%title(tit);

ax7 = subplot(4, 2, 7);
imagesc(low3.time, low3.freq, squeeze(low3.powspctrm(electrode_idx, :, :)),pgirange);
colorbar;
xlim(xlimit);
% ylim(ylimit);
axis xy
xlabel("Time S");
ylabel(strcat(title3," PGI"),"Rotation",0,'HorizontalAlignment','right','fontweight','bold');
hold on;
xline(baseline,'-m','LineWidth',1);
xline(electrode.time, '--r');
xline(window,'-','LineWidth',1);
tit = strcat("Low group power spectrum ", title3, " @ ", electrode.electrode);
%title(tit);

ax8 = subplot(4, 2, 8);
imagesc(high3.time, high3.freq, squeeze(high3.powspctrm(electrode_idx, :, :)),pgirange);
colorbar;
xlim(xlimit);
%ylim(ylimit);
axis xy
xlabel("Time S");
ylabel("Frequency Hz");
hold on;
xline(baseline,'-m','LineWidth',1);
xline(electrode.time, '--r');
xline(window,'-','LineWidth',1);
tit = strcat("High group power spectrum ", title3, " @ ", electrode.electrode);
%title(tit);

linkaxes([ax1 ax2],'y');
ax1.YLim = ax1.YLim * 1.1;

titles = strcat("Interactions through ", title4, " Low vs High group ", factor);
set(findall(gcf,'-property','FontSize'),'FontSize',font_size);

set(gcf, 'Position', [100, 100, 1900, 1600]);

legPos1 = get(leg1, 'Position');

avgpos = 0.5 - legPos1(3)/2.5;
avgpos = [avgpos,legPos1(2),legPos1(3),legPos1(4)];
set(leg1, 'Position', avgpos);
set(leg2, 'Position', avgpos);

pause(2);


% get all positions of axes again
pos1_new = get(ax1, 'Position');
pos2_new = get(ax2, 'Position');
pos3 = get(ax3, 'Position');

pos1_new(3) = pos1_new(3) - avgpos(3)/4;
pos2_new(1) = pos2_new(1) + avgpos(3)/3.5;
pos2_new(3) = pos2_new(3) - avgpos(3)/3.5;


% set position of all axes
set(ax1, 'Position', pos1_new);
set(ax2, 'Position', pos2_new);


if ~paper_figs
    %titles = strcat("Interactions through ", title4, " Low vs High group ", factor);
    %f1.Position = f1.Position + [0 -300 0 300];
    set(gcf, 'Position', [100, 100, 1300, 800]);
    %sgtitle(titles);
    freqmin = high1.freq(1);
    freqmax = high1.freq(end);
    
    name = strcat(results, "/partitions/", factor, electrode.electrode, '_', string(freqmin), '_', string(freqmax), '_erpcombined.png');
    saveas(gcf, name);
end
plots = gcf;
end
