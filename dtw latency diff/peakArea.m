function latency = peakArea(data1, data2, fs, areaThreshold)

    % determines the latency using fractional area
    avgLatency = [];

    %first we need to determine the point at which the area is calcualted from, suggested not from 0 because of noise 
    %we will use the point at which the signal is 5% of the max - for this example 


    for i = 1:size(data1,1)
        dat1 = data1{i}.erp;
        dat2 = data2{i}.erp;

        %find the max of the signal
        [maxVal, maxInd1] = max(dat1);
        %find the point at which the signal is 5% of the max
        thresh1 = maxVal*0.1;
        [maxVal, maxInd2] = max(dat2);
        thresh2 = maxVal*0.1;

        % calculate the area under the curve from the threshold to the max point
        threshIndex1 = find(dat1 > thresh1, 1, 'first');
        threshIndex2 = find(dat2 > thresh2, 1, 'first');

        %calculate the area under the curve from the threshold to the max point

        maxArea1 = trapz(dat1(threshIndex1:maxInd1));
        maxArea2 = trapz(dat2(threshIndex2:maxInd2));

        % calculate the point at which the area is 50% of the max area 
        areaThresh1 = maxArea1*areaThreshold;
        areaThresh2 = maxArea2*areaThreshold;

        % find the point at which the area is 50% of the max area
        areaIndex1 = find(cumtrapz(dat1) > areaThresh1, 1, 'first');
        areaIndex2 = find(cumtrapz(dat2) > areaThresh2, 1, 'first');

        % calculate the latency
        latency = (areaIndex1 - areaIndex2);
        f = 1/fs;
        avgLatency(i) = latency*f;


    end

    latency = mean(avgLatency);
end

