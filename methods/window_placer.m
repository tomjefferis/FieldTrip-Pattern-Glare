function [peaks, windowindexs] = window_placer(gfp, windows, baseline_period)

    [pks, locs] = findpeaks(gfp, 'MinPeakHeight', mean(gfp) * 1.1, 'SortStr', 'descend', 'NPeaks', windows, 'MinPeakDistance', 50);

    peakwindows = struct('endloc', 0, 'startloc', 0);

    % this loop goes through and finds the windows at which to do analysis
    % on, these are found by the vector standardization where the
    % 'baseline' is below zero so the algorithm can find the point at which
    % the timeseries goes below zero and is at a valley.
    for index = 1:length(pks)
        %gets location of peak
        peakdets = {};
        peakloc = locs(index);
        %looking for end of peak
        value = gfp(peakloc);
        n = peakloc;

        peakmid = gfp(peakloc) / 1.8;
        meansig = mean(gfp);

        while (value > peakmid || value > gfp(n + 1)) && ~contains_struct(peakwindows, value)
            % prevent overflow
            if length(gfp) == n
                break;
            end

            value = gfp(n);
            n = n + 1;
        end

        peakdets.endloc = n;

        %looking for start of peak
        value = gfp(peakloc);
        n = peakloc;

        if peakwindows(1).endloc ~= 0 && index > 1

            if peakloc > locs(index -1)
                n = peakwindows(index -1).endloc;
            end

        else

            while (value > peakmid || value > gfp(n - 1)) && ~contains_struct(peakwindows, value)
                % prevent overflow
                if n == 0
                    break;
                end

                value = gfp(n);
                n = n - 1;
            end

        end

        peakdets.startloc = n;

        peakwindows(index) = peakdets;
    end

    %% removes duplicate windows
    N = numel(peakwindows);
    X = false(1, N);

    for ii = 2:N
        Y = false;

        for jj = 1:ii - 1
            Y = Y || isequal(peakwindows(ii), peakwindows(jj));
        end

        X(ii) = Y;
    end

    peakwindows(X) = [];
    remove = [];

    for index = 1:numel(peakwindows)
        window_length = peakwindows(index).endloc - peakwindows(index).startloc;
        partseries = round(length(gfp) / 20); %window needs to be at least 5 % of the timeseries

        if window_length < partseries
            remove(end + 1) = index;
        end

    end

    for index = remove
        peakwindows(index) = [];
    end

    windowindexs = peakwindows;
    peaks = locs;

end