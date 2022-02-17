function [datas] = freq_fourier_decomposition(datas, wavelet_width, filename)


    if contains(filename, 'onsets')
        datas = freq_decomp(datas, wavelet_width,'fourier');
    else
        datas.part1 = freq_decomp(datas.part1, wavelet_width,'fourier');
        datas.part2 = freq_decomp(datas.part2, wavelet_width,'fourier');
        datas.part3 = freq_decomp(datas.part3, wavelet_width,'fourier');
    end

end