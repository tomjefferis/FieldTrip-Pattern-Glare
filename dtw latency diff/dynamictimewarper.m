function dynamictimewarper(data,fs)
% Dynamic Time Warper is a function that gets the DTW distance for the
% electrode and computes the Fractional peak, peak, and area of the erp
% component

% Input: data = array of erp data for a single electrode samples x trials

trials = [data{:}]';
grand_avg = mean(trials,1);


for i = 1:size(trials,1)
    [dist,ix,iy] = dtw(grand_avg,trials(i,:));
    latency = ix - iy;
    abslatency = latency/fs;
    meanAbsLatency(i) = mean(abslatency);
end
abslatency = abs(meanAbsLatency);
absoloutemean = mean(abslatency);
disp(absoloutemean)



end

