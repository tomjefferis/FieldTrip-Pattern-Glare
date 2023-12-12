%% EEG pattern glare analysis - Author: Tom Jefferis
%% This file is used for running DTW on the EEG data
%% setting up paths to plugins and default folder
clear all;
restoredefaultpath;

%% Parameters of this analysis
SNR_test = [0.1:0.05:0.9];
desired_peak_loc_1 = 0.1; % in seconds
desired_peak_loc_2 = 0.2; % in seconds
desired_time = 0.5; % in seconds
num_permutations = 10; % number of times to generate signal per snr level
 

% parameters of synthetic signal
desired_fs = 500; % sample rate in Hz
desired_noise_level = 0.1; % SNR ratio
desired_trials = 1; % number of trials per participant to generate
desired_participants = 1; % number of participants to generate
desired_jitter = 0; % jitter in ± ms 
desired_peak_fs = 5; % frequency of peak in Hz
%Controls where the peak is placed in seconds



median_dtw_distances = zeros(num_permutations,length(SNR_test));
mean_dtw_distances = zeros(num_permutations,length(SNR_test));
mode_dtw_distances = zeros(num_permutations,length(SNR_test));
max_dtw_distances = zeros(num_permutations,length(SNR_test));
max95_dtw_distances = zeros(num_permutations,length(SNR_test));
peak_latency = zeros(num_permutations,length(SNR_test));
frac_peak_latency = zeros(num_permutations,length(SNR_test));


for i = 1:length(SNR_test)
    for j = 1:num_permutations
        signals1 = generate_data(desired_time, desired_fs, SNR_test(i), desired_trials, ...
            desired_participants, desired_jitter, desired_peak_fs,desired_peak_loc_1);
        
        
        signals2 = generate_data(desired_time, desired_fs, SNR_test(i), desired_trials, ...
            desired_participants, desired_jitter, desired_peak_fs,desired_peak_loc_2);
    
         
        [mean_dtw_distances(j,i),median_dtw_distances(j,i),mode_dtw_distances(j,i),max_dtw_distances(j,i),max95_dtw_distances(j,i)] = dynamictimewarper(signals1,signals2,desired_fs);
        [peak_latency(j,i)] = peaklatency(signals1,signals2, desired_fs);
        [frac_peak_latency(j,i)] = fracpeaklatency(signals1,signals2, desired_fs);
    
    end
end

median_dtw_distances = median(median_dtw_distances,1);
mean_dtw_distances = median(mean_dtw_distances,1);
mode_dtw_distances = median(mode_dtw_distances,1);
max_dtw_distances = median(max_dtw_distances,1);
max95_dtw_distances = median(max95_dtw_distances,1);
peak_latency = median(peak_latency,1);
frac_peak_latency = median(frac_peak_latency,1);


%% Plotting the results, subplot for each line with X bing SNR and Y being the DTW distance
figure;
tiledlayout(2,4);

ax1 = nexttile;
plot(SNR_test,median_dtw_distances,'LineWidth',2)
hold on
yline(mean(median_dtw_distances),'r--', 'LineWidth',2)
yline((desired_peak_loc_1 - desired_peak_loc_2), 'g--', 'LineWidth',2)
title('Median DTW distance')
subtitle("Average latency = " + mean(median_dtw_distances) + "ms")
xlabel('NSR')
ylabel('DTW distance (ms)')

ax2 = nexttile;
plot(SNR_test,mean_dtw_distances,'LineWidth',2)
hold on
yline(mean(mean_dtw_distances),'r--', 'LineWidth',2)
yline((desired_peak_loc_1 - desired_peak_loc_2), 'g--', 'LineWidth',2)
title('Mean DTW distance')
subtitle("Average latency = " + mean(mean_dtw_distances) + "ms")
xlabel('NSR')
ylabel('DTW distance (ms)')

ax3 = nexttile;
plot(SNR_test,mode_dtw_distances,'LineWidth',2)
hold on
yline(mean(mode_dtw_distances),'r--', 'LineWidth',2)
yline((desired_peak_loc_1 - desired_peak_loc_2), 'g--', 'LineWidth',2)
title('Mode DTW distance')
subtitle("Average latency = " + mean(mode_dtw_distances) + "ms")
xlabel('NSR')
ylabel('DTW distance (ms)')

ax4 = nexttile;
plot(SNR_test,max_dtw_distances,'LineWidth',2)
hold on
yline(mean(max_dtw_distances),'r--', 'LineWidth',2)
yline((desired_peak_loc_1 - desired_peak_loc_2), 'g--', 'LineWidth',2)
title('Max DTW distance')
subtitle("Average latency = " + mean(max_dtw_distances) + "ms")
xlabel('NSR')
ylabel('DTW distance (ms)')

ax5 = nexttile;
plot(SNR_test,max95_dtw_distances,'LineWidth',2)
hold on
yline(mean(max95_dtw_distances),'r--', 'LineWidth',2)
yline((desired_peak_loc_1 - desired_peak_loc_2), 'g--', 'LineWidth',2)
title('95% Max DTW distance')
subtitle("Average latency = " + mean(max95_dtw_distances) + "ms")
xlabel('NSR')
ylabel('DTW distance (ms)')

ax6 = nexttile;
plot(SNR_test,peak_latency,'LineWidth',2)
hold on
yline(mean(peak_latency),'r--', 'LineWidth',2)
yline((desired_peak_loc_1 - desired_peak_loc_2), 'g--', 'LineWidth',2)
title('Peak latency')
subtitle("Average latency = " + mean(peak_latency) + "ms")
xlabel('NSR')
ylabel('Peak latency (ms)')

ax7 = nexttile;
plot(SNR_test,frac_peak_latency,'LineWidth',2)
hold on
yline(mean(frac_peak_latency),'r--', 'LineWidth',2)
yline((desired_peak_loc_1 - desired_peak_loc_2), 'g--', 'LineWidth',2)
title('Fractional peak latency')
subtitle("Average latency = " + mean(frac_peak_latency) + "ms")
xlabel('NSR')
ylabel('Fractional peak latency (ms)')

% set y axis to be the same for all tiles
linkaxes([ax1,ax2,ax3,ax4,ax5,ax6,ax7],'y')
ylim1 = ylim(ax1);
ylim([ylim1(1) ylim1(2)]);

lg  = legend('Latency','Mean Latency','Actual latency');
lg.FontSize = 16;
lg.Layout.Tile = 8;

tit = strcat("DTW vs other methods for varying NSR levels for ",string(desired_time*1000),"ms signal");
sgt = sgtitle(tit);
sgt.FontSize = 24;

set(gcf,'Position',[0 0 2560 1080])
figname = strcat("DTW_results_NSR_",string(desired_time*1000),"ms_signal.png");
saveas(gcf,figname)



