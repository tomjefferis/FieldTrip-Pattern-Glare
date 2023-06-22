function plots = plot_partitions_intercept_power(dataone, datatwo, datathree, electrode, design2, factor, results, paper_figs, time, font_size)

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


cfg = [];
dat1 = ft_freqgrandaverage(cfg, dataone.data{:});
dat2 = ft_freqgrandaverage(cfg, datatwo.data{:});
dat3 = ft_freqgrandaverage(cfg, datathree.data{:});


xlimit = [time(1), time(end)];
%start = 2.8;
f1 = figure;

electrode_idx = get_electrode_index(low1, electrode);

datitpc1 = mean(squeeze(dat1.powspctrm(electrode_idx, :, :)), 1);
datitpc2 = mean(squeeze(dat2.powspctrm(electrode_idx, :, :)), 1);
datitpc3 = mean(squeeze(dat3.powspctrm(electrode_idx, :, :)), 1);

datmed1 = mean(squeeze(dat1.med_powspctrm(electrode_idx, :, :)), 1);
datmed2 = mean(squeeze(dat1.med_powspctrm(electrode_idx, :, :)), 1);
datmed3 = mean(squeeze(dat1.med_powspctrm(electrode_idx, :, :)), 1);


pgimax = round(max(max(max(max(max(squeeze(datitpc1.powspctrm(electrode_idx, :, :)),squeeze(datitpc2.powspctrm(electrode_idx, :, :)),squeeze(datitpc3.powspctrm(electrode_idx, :, :))))))) + 0.5);

pgimin = round(min(min(min(min(min(squeeze(datitpc1.powspctrm(electrode_idx, :, :)),squeeze(datitpc2.powspctrm(electrode_idx, :, :)),squeeze(datitpc3.powspctrm(electrode_idx, :, :))))))) - 0.5);
pgirange = [pgimin,pgimax];



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
ax1 = subplot(5, 1, 1);
plot(datitpc1.time, datitpc1, 'g', datitpc1.time, datitpc2, 'b', datitpc1.time, datitpc3, 'r', 'LineWidth', 1.4);
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
tit = strcat("PGI through ", title4);
title(tit);

ax2 = subplot(5, 1, 2);
plot(datitpc1.time, datmed1, 'g', datitpc1.time, datmed2, 'b', datitpc1.time, datmed3, 'r', 'LineWidth', 1.4);
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
tit = strcat("Medium through ", title4);
title(tit);

ax3 = subplot(5, 1, 3);
imagesc(datitpc1.time, datitpc1.freq, squeeze(datitpc1.powspctrm(electrode_idx, :, :)),pgirange);
colorbar;
xlabel("Time S");
xlim([time(1), time(end)])
ylabel("Frequency Hz");
hold on;
xline(baseline,'-m','LineWidth',1);
xline(electrode.time, '--r');
xline(window,'-','LineWidth',1);
tit = strcat(title1, " power Spectrum @ ", electrode.electrode);
title(tit);

ax4 = subplot(5, 1, 4);
imagesc(datitpc1.time, datitpc1.freq, squeeze(datitpc2.powspctrm(electrode_idx, :, :)),pgirange);
colorbar;
xlabel("Time S");
xlim([time(1), time(end)])
ylabel("Frequency Hz");
hold on;
xline(baseline,'-m','LineWidth',1);
xline(electrode.time, '--r');
xline(window,'-','LineWidth',1);
tit = strcat(title2," power Spectrum @ ", electrode.electrode);
title(tit);

ax5 = subplot(5, 1, 5);
imagesc(datitpc1.time, datitpc1.freq, squeeze(datitpc3.powspctrm(electrode_idx, :, :)),pgirange);
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
tit = strcat(title3," power spectrum @ ", electrode.electrode);
%title(tit);



titles = strcat("Interactions through ", title4, " for ", factor);
set(findall(gcf,'-property','FontSize'),'FontSize',font_size);

set(gcf, 'Position', [100, 100, 1900, 1000]);

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
