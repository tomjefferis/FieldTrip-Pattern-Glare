function datas = freq_decomp(datas, wavelet_width, output)

    %%  Frequency decomposition function
    %   This is the main function for frequency decomposition
    %   It is the lowest level function and is called by:
    %           freq_power_decomposition() or freq_fourier_decomposition()
    %

    [thin, med, thick] = split_data(datas);
    if ~strcmp(output,'pow')
        thin = [];
        thick = [];
        datas = med;
        med = [];    
    end
    
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

    for index = 1:length(datas)
        %datas{index} = ft_freqanalysis(cfg, datas{index});

        if strcmp(cfg.output, 'pow')
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
        else

            datas{index} = ft_freqanalysis(cfg, datas{index});
            %datas{index}.thin_fourierspctrm = thin{index}.fourierspctrm;
            %datas{index}.med_fourierspctrm = med{index}.fourierspctrm;
            %datas{index}.thick_fourierspctrm = thick{index}.fourierspctrm;

        end

    end

end
