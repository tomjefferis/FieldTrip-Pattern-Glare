function [datas] = freq_power_decopmosition(datas, wavelet_width, decimate, filename_precomposed, time,frequency_range,baseline_period, channel)

    if ~exist('time','var')
        time = [0,3.998];
    end

    if ~exist('channel','var')
        channel = 'all';
    end

    if contains(filename_precomposed, 'pow-')
        output = "pow";
    else
        output = "fourier";
    end


    if contains(filename_precomposed, 'onsets') && ~contains(filename_precomposed, "partitions-vs-onsets")&& ~contains(filename_precomposed, "onsets-23-45-67")
        datas = freq_decomp(datas, wavelet_width, output,frequency_range,time, baseline_period,decimate,channel);
        time = datas{1}.time;
        freq = datas{1}.freq;
        for i = 1:length(datas)
            datas{i}.time = time;
            datas{i}.freq = freq;
        end
    else
        datas.part1 = freq_decomp(datas.part1, wavelet_width,output,frequency_range,time, baseline_period,decimate,channel);
        datas.part2 = freq_decomp(datas.part2, wavelet_width,output,frequency_range,time, baseline_period,decimate,channel);
        datas.part3 = freq_decomp(datas.part3, wavelet_width,output,frequency_range,time, baseline_period,decimate,channel);

        time = datas.part1{1}.time;
        freq = datas.part1{1}.freq;
        for i = 1:length(datas.part1)
            datas.part1{i}.time = time;
            datas.part1{i}.freq = freq;
        end
        for i = 1:length(datas.part2)
            datas.part2{i}.time = time;
            datas.part3{i}.freq = freq;
        end
        for i = 1:length(datas.part3)
            datas.part3{i}.time = time;
            datas.part3{i}.freq = freq;
        end
    end



end