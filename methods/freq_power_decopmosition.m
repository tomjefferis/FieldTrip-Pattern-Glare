function [datas] = freq_power_decopmosition(datas, wavelet_width, decimate, filename_precomposed, time,frequency_range,baseline_period)

    if ~exist('time','var')
        time = [0,3.998];
    end

    if contains(filename_precomposed, 'pow-')
        output = "pow";
    else
        output = "fourier";
    end


    if contains(filename_precomposed, 'onsets') && ~contains(filename_precomposed, "partitions-vs-onsets")&& ~contains(filename_precomposed, "onsets-23-45-67")
        datas = freq_decomp(datas, wavelet_width, output,frequency_range,time, baseline_period,decimate);
        time = datas{1}.time;
        for i = 1:length(datas)
            datas{i}.time = time;
        end
    else
        datas.part1 = freq_decomp(datas.part1, wavelet_width,output,frequency_range,time, baseline_period,decimate);
        datas.part2 = freq_decomp(datas.part2, wavelet_width,output,frequency_range,time, baseline_period,decimate);
        datas.part3 = freq_decomp(datas.part3, wavelet_width,output,frequency_range,time, baseline_period,decimate);

        time = datas.part1{1}.time;

        for i = 1:length(datas.part1)
            datas.part1{i}.time = time;
        end
        for i = 1:length(datas.part2)
            datas.part2{i}.time = time;
        end
        for i = 1:length(datas.part3)
            datas.part3{i}.time = time;
        end
    end



end