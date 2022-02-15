function [data] = roi_mask(input, order, start_time, end_time, results, time_freq, frequency_range, posneg, main_path, grand_avg_filename, n_participants, onsets_part)

    save_roi_path = strcat(results, "/none/roi_mask_", time_freq, "_", string(posneg), "_",string(start_time), "s-", string(end_time), "s.mat");

    if ~isfile(save_roi_path)
        [data, order] = load_data(main_path, grand_avg_filename, n_participants, onsets_part);
        [design_matrix, data] = get_design_matrix("none", data, order);
        stat = stat_test(data, 'none', start_time, end_time, design_matrix, time_freq, frequency_range, false);
        if posneg
            
            neg_mask = stat.posclusterslabelmat;
        else
            
            neg_mask = stat.negclusterslabelmat;
        end
        
        % gets biggest clusters and sets all other numbers to zero
        
        neg_mask(neg_mask > 1) = 0;
        % adds together and sets overlapping to 1
        roi_mask = neg_mask; % + pos_mask; % remove this comment to add negative clusters to ROI again
        roi_mask(roi_mask > 1) = 1;
        % now to mask the data out
        %part = resize_roi(data, start_time, end_time, roi_mask);
        part.mask = roi_mask;
        part.time = stat.time;
        save(save_roi_path, 'part');

    else
        data = input;
        roi_mask = load(save_roi_path);
        part = roi_mask.part;
    end

    % getting start time and end time
    %masklength = length(part.time)-1;
    startidx = find(data{1}.time == part.time(1));
    end_idx = find(data{1}.time == part.time(end));

    if strcmp(time_freq, "time")

        for item = 1:length(data)
            edit = data{item}.avg;

            starter = edit(:, 1:startidx - 1);
            ender = edit(:, 1 + end_idx:end);
            mid = edit(:, startidx:end_idx);

            mid(part.mask == 0) = NaN;

            edit = [starter, mid, ender];

            data{item}.avg = edit;
        end

    else

        for item = 1:length(data)
            freqedit = data{item}.avg;

            for idx = 1:size(freqedit, 2)
                edit = freqedit(:, idx, :);

                starter = edit(:, 1:startidx - 1);
                ender = edit(:, 1 + end_idx:end);
                mid = edit(:, startidx:end_idx);

                mid(part.mask == 0) = NaN;

                edit = [starter, mid, ender];

                freqedit(:, idx, :) = edit;
            end

            data{item}.avg = freqedit;
        end

    end

end