function [datas, orders] = freq_fourier_decopmosition(datas, orders, wavelet_width, filename_precomposed)

    if contains(filename_precomposed, 'onsets')
        datas = freq_decomp(datas, wavelet_width, wavelet_width,'fourier');
    else
        datas.part1 = freq_decomp(datas.part1, wavelet_width,'fourier');
        datas.part2 = freq_decomp(datas.part2, wavelet_width,'fourier');
        datas.part3 = freq_decomp(datas.part3, wavelet_width,'fourier');
    end

    decomposed.data = datas;
    decomposed.order = orders;
    save(filename_precomposed, "decomposed", '-v7.3');

end