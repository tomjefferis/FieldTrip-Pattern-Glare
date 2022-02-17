function datas = freq_decomp(datas, wavelet_width, output)

    %%  Frequency decomposition function
    %   This is the main function for frequency decomposition
    %   It is the lowest level function and is called by:
    %           freq_power_decomposition() or freq_fourier_decomposition()
    %

    [thin, med, thick] = split_data({datas});
    if ~strcmp(output,'pow')
        thin = [];
        thick = [];
        datas = med{1};
        med = [];    
    else
        thin = thin{1};
        thick = thick{1};
        datas = med{1};
        med = med{1};   
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
    cfg.parameter = 'avg';
    

        if strcmp(cfg.output, 'pow')
            thin = ft_freqanalysis(cfg, thin);
            med = ft_freqanalysis(cfg, med);
            thick = ft_freqanalysis(cfg, thick);
            thin = baseline_freq(thin);
            med = baseline_freq(med);
            thick = baseline_freq(thick);
            datas = med;

            datas.thin_powspctrm = thin.powspctrm;
            datas.med_powspctrm = med.powspctrm;
            datas.thick_powspctrm = thick.powspctrm;
            datas.powspctrm = datas.med_powspctrm - (datas.thin_powspctrm + datas.thick_powspctrm) / 2;
        else

            datas = ft_freqanalysis(cfg, datas);
            %datas.thin_fourierspctrm = thin.fourierspctrm;
            %datas.med_fourierspctrm = med.fourierspctrm;
            %datas.thick_fourierspctrm = thick.fourierspctrm;

        end

    

end
