function [datas] = freq_power_decopmosition(datas, wavelet_width, filename_precomposed, time,frequency_range,baseline_period)

    if ~exist('time','var')
        time = [0,3.998];
    end

    if contains(filename_precomposed, 'pow-')
        output = "pow";
    else
        output = "fourier";
    end


    if contains(filename_precomposed, 'onsets')
        datas = freq_decomp(datas, wavelet_width, output,frequency_range,time, baseline_period);
    else
        datas.part1 = freq_decomp(datas.part1, wavelet_width,output,frequency_range,time, baseline_period);
        datas.part2 = freq_decomp(datas.part2, wavelet_width,output,frequency_range,time, baseline_period);
        datas.part3 = freq_decomp(datas.part3, wavelet_width,output,frequency_range,time, baseline_period);
    end



end