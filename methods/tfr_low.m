function tfr_low(data,electrode,f_range)
%TFR_LOW Summary of this function goes here
%   Detailed explanation goes here

e = get_electrode_index(data, electrode);
x = squeeze(data.powspctrm(e,:,:));
time = data.time;

imagesc(x);
colorbar;
hold on;
yt = get(gca, 'YTick');
ytlbl = round(linspace(f_range(1), f_range(end), numel(yt)));
yticklabels(fliplr(ytlbl));
xt = get(gca, 'XTick');                                             
xtlbl = round(linspace(time(1), time(end), numel(xt)),1); 
xticklabels(xtlbl);
xlabel("Time (s)");
ylabel("Frequency (Hz)");


end

