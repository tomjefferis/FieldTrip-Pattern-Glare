function [data,order] = load_freq_decomp(main_path, single_trial_name, composed_filename, n_participants, wavelet_width,time)

    if ~exist('time','var')
        time = [0,3.998];
    end


    if contains(composed_filename, "pow-")
        output = "pow";
    else
        output = "fourier";
    end
        data = [];
        order = [];

    for index = 1:n_participants
        fprintf('LOADING %d/%d \n', index, n_participants);
        participant_main_path = strcat(main_path, int2str(index));

        if exist(participant_main_path, 'dir')
            cd(participant_main_path);
            if isfile(composed_filename)
                order(end + 1) = index;
                data{end+1} = load(composed_filename).decomposed;
            elseif isfile(single_trial_name)
                order(end + 1) = index;
                datas = load(single_trial_name).data;
                datas.trialinfo = [1];
                datas.dimord = 'chan_time';
                datas.time = datas.time{1};
                if contains(output, "pow")
                    decomposed = freq_power_decopmosition(datas, wavelet_width, composed_filename, time);
                else
                    decomposed = freq_fourier_decomposition(datas, wavelet_width, composed_filename, time);
                end

                decomposed.diamord = "chan_time";

                save(composed_filename, "decomposed", '-v7.3');
                data{end+1} = decomposed;
            end

        end

    end

end
