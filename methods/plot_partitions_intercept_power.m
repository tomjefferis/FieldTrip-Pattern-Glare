function plots = plot_partitions_intercept_power(dataone, datatwo, datathree, electrode, design2, factor, results, paper_figs, time, font_size, baseline)

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

cfg = [];
cfg.parameter = ["powspctrm","med_powspctrm"];
dat1 = ft_freqgrandaverage(cfg, dataone{:});
dat2 = ft_freqgrandaverage(cfg, datatwo{:});
dat3 = ft_freqgrandaverage(cfg, datathree{:});


xlimit = [time(1), time(end)];
ylims = [dat1.freq(1), dat1.freq(end)];
%start = 2.8;
f1 = figure;

electrode_idx = get_electrode_index(dat1, electrode);

datitpc1 = mean(squeeze(dat1.powspctrm(electrode_idx, :, :)), 1);
datitpc2 = mean(squeeze(dat2.powspctrm(electrode_idx, :, :)), 1);
datitpc3 = mean(squeeze(dat3.powspctrm(electrode_idx, :, :)), 1);

datmed1 = mean(squeeze(dat1.med_powspctrm(electrode_idx, :, :)), 1);
datmed2 = mean(squeeze(dat2.med_powspctrm(electrode_idx, :, :)), 1);
datmed3 = mean(squeeze(dat3.med_powspctrm(electrode_idx, :, :)), 1);


pgimax = round(max(max(max(max(max(squeeze(datitpc1),squeeze(datitpc2)),squeeze(datitpc3))))) + 0.5);

pgimin = round(min(min(min(min(min(squeeze(datitpc1),squeeze(datitpc2)),squeeze(datitpc3))))) - 0.5);
pgirange = [pgimin,pgimax];


medmax = round(max(max(max(max(max(squeeze(datmed1),squeeze(datmed2)),squeeze(datmed3))))) + 0.5);
medmin = round(min(min(min(min(min(squeeze(datmed1),squeeze(datmed2)),squeeze(datmed3))))) - 0.5);
medrange = [medmin, medmax];


if contains(factor,"onsets") || contains(factor,"Onsets")
    legend1 = ["Onsets 2,3 PGI", "Onsets 4,5 PGI", "Onsets 6,7 PGI", "Baseline End","Baseline Start", "Max Effect", "Window Start"];
    legend2 = ["Onsets 2,3 Med", "Onsets 4,5 Med", "Onsets 6,7 Med", "", "Max Effect", ""];
    
    title1 = 'Onsets 2,3';
    title2 = 'Onsets 4,5';
    title3 = 'Onsets 6,7';
    title4 = 'Onsets';
else
    legend1 = ["Partition 1 PGI", "Partition 2 PGI", "Partition 3 PGI", "Baseline End","Baseline Start", "Max Effect", "Window Start"];
    legend2 = ["Partition 1 Med", "Partition 2 Med", "Partition 3 Med", "", "Max Effect", ""];
    
    title1 = 'Partition 1';
    title2 = 'Partition 2';
    title3 = 'Partition 3';
        title4 = 'Partitions';
end

% First subplot low PGI across partitions
ax1 = subplot(5, 1, 1);
plot(dat1.time, datitpc1, 'g', dat1.time, datitpc2, 'b', dat1.time, datitpc3, 'r', 'LineWidth', 1.4);
title(title1);
xlabel("Time S");
ylabel("Power db");
grid on;
hold on;
xline(baseline,'-m','LineWidth',1);  
xline(baselineS,'-m','LineWidth',1);
xline(electrode.time, '--r');
xline(window,'-','LineWidth',1);
xlim([time(1), time(end)]);
ylim(pgirange);
leg1 = legend(legend1, 'location', 'eastoutside');
tit = strcat("PGI through ", title4);
title(tit);

ax2 = subplot(5, 1, 2);
plot(dat1.time, datmed1, 'g', dat1.time, datmed2, 'b', dat1.time, datmed3, 'r', 'LineWidth', 1.4);
title(title1);
xlabel("Time S");
ylabel("Power db");
grid on;
hold on;
xline(baseline,'-m','LineWidth',1);  
xline(baselineS,'-m','LineWidth',1);
xline(electrode.time, '--r');
xline(window,'-','LineWidth',1);
xlim([time(1), time(end)])
ylim(medrange);
leg2 = legend(legend1, 'location', 'eastoutside');
tit = strcat("Medium through ", title4);
title(tit);

ax3 = subplot(5, 1, 3);
surf(dat1.time, dat1.freq, squeeze(dat1.powspctrm(electrode_idx, :, :)), 'EdgeColor', 'none');
view(2);
shading interp;
colorbar;
xlabel("Time S");
xlim([time(1), time(end)])
caxis(pgirange);
ylim(ylims)
ylabel("Frequency Hz");
hold on;
xline(baseline,'-m','LineWidth',1);   
xline(baselineS,'-m','LineWidth',1);
xline(electrode.time, '--r');
xline(window,'-','LineWidth',1);
tit = strcat(title1, " power Spectrum @ ", electrode.electrode);
title(tit);

ax4 = subplot(5, 1, 4);
surf(dat2.time, dat2.freq, squeeze(dat2.powspctrm(electrode_idx, :, :)), 'EdgeColor', 'none');
view(2);
shading interp;
colorbar;
xlabel("Time S");
caxis(pgirange);
ylim(ylims)
xlim([time(1), time(end)])
ylabel("Frequency Hz");
hold on;
xline(baseline,'-m','LineWidth',1);   
xline(baselineS,'-m','LineWidth',1);
xline(electrode.time, '--r');
xline(window,'-','LineWidth',1);
tit = strcat(title2," power Spectrum @ ", electrode.electrode);
title(tit);

ax5 = subplot(5, 1, 5);
surf(dat1.time, dat1.freq, squeeze(dat3.powspctrm(electrode_idx, :, :)), 'EdgeColor', 'none');
view(2);
shading interp;
colorbar;
xlim(xlimit);
ylim(ylims);
caxis(pgirange);
%ylim(ylimit);
axis xy
xlabel("Time S");
ylabel("Frequency Hz");
hold on;
xline(baseline,'-m','LineWidth',1);  
xline(baselineS,'-m','LineWidth',1);
xline(electrode.time, '--r');
xline(window,'-','LineWidth',1);
tit = strcat(title3," power spectrum @ ", electrode.electrode);
title(tit);



titles = strcat("Interactions through ", title4, " for ", factor);
set(findall(gcf,'-property','FontSize'),'FontSize',font_size);

set(gcf, 'Position', [100, 100, 1900, 1800]);


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
