function datas = freq_decomp(datas, wavelet_width,output)


    [thin, med, thick] = split_data(datas);

    step = 1/512;
    start = 2;
    endt = 3.998;

    cfg = [];
    cfg.output = output;
    cfg.method = 'wavelet';
    cfg.width = wavelet_width;
    cfg.foi = 1:1:80;
    cfg.toi = start:step:endt;
    cfg.pad = 'nextpow2';
    cfg.channel = 'all';
    cfg.trials = 'all';

    parfor index = 1:length(datas)
        %datas{index} = ft_freqanalysis(cfg, datas{index});
        thin{index} = ft_freqanalysis(cfg, thin{index});
        med{index} = ft_freqanalysis(cfg, med{index});
        thick{index} = ft_freqanalysis(cfg, thick{index});

        thin{index} = baseline_freq(thin{index});
        med{index} = baseline_freq(med{index});
        thick{index} = baseline_freq(thick{index});

        datas{index} = med{index};

        datas{index}.thin_powspctrm = thin{index}.powspctrm;
        datas{index}.med_powspctrm = med{index}.powspctrm;
        datas{index}.thick_powspctrm = thick{index}.powspctrm;
        datas{index}.powspctrm = datas{index}.med_powspctrm - (datas{index}.thin_powspctrm + datas{index}.thick_powspctrm) / 2;
    end

end