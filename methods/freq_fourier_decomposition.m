function [datas] = freq_fourier_decomposition(datas, wavelet_width, filename, time)

    if ~exist('time','var')
        time = [2.8,3.998];
    end

    if contains(filename, 'onsets')
        datas = freq_decomp(datas, wavelet_width,'fourier',time);
    else
        datas.part1 = freq_decomp(datas.part1, wavelet_width,'fourier',time);
        datas.part2 = freq_decomp(datas.part2, wavelet_width,'fourier',time);
        datas.part3 = freq_decomp(datas.part3, wavelet_width,'fourier',time);
    end

end