function dynamictimewarper(data1, data2, fs)
% Dynamic Time Warper is a function that gets the DTW distance for the
% electrode and computes the Fractional peak, peak, and area of the erp
% component

% Input: data = array of erp data for a single electrode samples x trials






for i = 1:size(data1,1)
    query = zscore(data1{i}.erp);
    reference = zscore(data2{i}.erp);
    [dist,ix,iy] = dtw(query,reference);
    latency = ix - iy;
    meanAbsLatency(i,:) = latency;
    figure;
    plot(ix,iy,'--',[ix(1) ix(end)],[iy(1) iy(end)])
    title("Warping Path")
    xlabel("Signal 2")
    ylabel("Signal 1")
    arealatency(i) = (trapz(ix,iy) - trapz([ix(1) ix(end)],[iy(1) iy(end)]))/trapz([ix(1) ix(end)],[iy(1) iy(end)]);
end

fs = 1/fs;

absoloutemean = median(meanAbsLatency);
absoloutemean = absoloutemean*fs;
absmeanstr = strcat("DTW Median latency difference: ",string(absoloutemean),"s");
disp(absmeanstr)

absoloutemean = mode(meanAbsLatency);
absoloutemean = absoloutemean*fs;
absmeanstr = strcat("DTW Mode latency difference: ",string(absoloutemean),"s");
disp(absmeanstr)

absoloutearea = median(arealatency);
absmeanstr = strcat("DTW Area median distance: ",string(absoloutearea));
disp(absmeanstr)


end

