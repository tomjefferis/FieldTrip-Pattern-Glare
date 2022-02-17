function [datas] = freq_power_decopmosition(datas, wavelet_width, filename_precomposed)

    if contains(filename_precomposed, 'onsets')
        datas = freq_decomp(datas, wavelet_width, 'pow');
    else
        datas.part1 = freq_decomp(datas.part1, wavelet_width,'pow');
        datas.part2 = freq_decomp(datas.part2, wavelet_width,'pow');
        datas.part3 = freq_decomp(datas.part3, wavelet_width,'pow');
    end



end