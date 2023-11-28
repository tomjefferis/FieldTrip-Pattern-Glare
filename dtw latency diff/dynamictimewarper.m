function dynamictimewarper(data1, data2, fs)
% Dynamic Time Warper is a function that gets the DTW distance for the
% electrode and computes the Fractional peak, peak, and area of the erp
% component

% Input: data = array of erp data for a single electrode samples x trials






for i = 1:size(data1,2)
    query = zscore(data1{i}.erp);
    reference = zscore(data2{i}.erp);
    [dist,ix,iy] = dtw(query,reference);
    latency = ix - iy;
    meanAbsLatency{i} = latency;
    figure;
    plot(ix,iy,'--',[ix(1) ix(end)],[iy(1) iy(end)])
    title("Warping Path")
    xlabel("Signal 2")
    ylabel("Signal 1")
    arealatency(i) = (trapz(ix,iy) - trapz([ix(1) ix(end)],[iy(1) iy(end)]))/trapz([ix(1) ix(end)],[iy(1) iy(end)]);
end

fs = 1/fs;
lat = zeros(size(meanAbsLatency,2),max(cellfun('size',meanAbsLatency,2)));
lat(lat==0) = NaN;
for i = 1:size(meanAbsLatency,2)
    lat(i,1:size(meanAbsLatency{i},2)) = meanAbsLatency{i};
end


absoloutemean = median(lat,"all","omitmissing");
absoloutemean = absoloutemean*fs;
absmeanstr = strcat("DTW Median latency difference: ",string(absoloutemean),"s");
disp(absmeanstr)

absoloutemean = mode(lat,"all");
absoloutemean = absoloutemean*fs;
absmeanstr = strcat("DTW Mode latency difference: ",string(absoloutemean),"s");
disp(absmeanstr)

absoloutearea = median(arealatency);
absmeanstr = strcat("DTW Area median distance: ",string(absoloutearea));
disp(absmeanstr)

[~, maxlatIDX] = max(abs(lat));
maxlat = lat(maxlatIDX);
maxlat = maxlat*fs;
absmeanstr = strcat("DTW Max distance: ",string(maxlat));
disp(absmeanstr)

end

