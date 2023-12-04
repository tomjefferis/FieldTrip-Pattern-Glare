function latency = fracpeaklatency(data1, data2, fs)

    for i = 1:size(data1,1)
        % get the peak of data1 and data2 with the indexs using max
        [pks1,locs1] = max(data1{i}.erp);
        [pks2,locs2] = max(data2{i}.erp);

        % find 50% of the peak
        pks1 = pks1 * 0.5;
        pks2 = pks2 * 0.5;

        % find the index of the 50% peak or the closest value to it
        loc1(i) = find(data1{i}.erp > pks1, 1);
        loc2(i) = find(data2{i}.erp > pks2, 1);

        


    end

    loc1 = mean(loc1);
    loc2 = mean(loc2);

    f = 1/fs;
    latency = (loc1 - loc2) * f;
    
end

