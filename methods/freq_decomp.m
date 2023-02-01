function datas = freq_decomp(datas, wavelet_width, output,frequency_range, time, baseline_period)

    %%  Frequency decomposition function
    %   This is the main function for frequency decomposition
    %   It is the lowest level function and is called by:
    %           freq_power_decomposition() or freq_fourier_decomposition()
    %

    temp_time = time(1);
    if time(1) >= 3 
        time(1) = 2.8;
    else
        time(1) = datas{1}.time(1);
    end


    [thin, med, thick] = split_data(datas,true);
    if ~strcmp(output,'pow')
        thin = [];
        thick = [];
        datas = med;
        for index = 1:numel(datas)
            temp_datas = datas{index}.avg(2:end);
            datas{index}.trial = permute(cat(3,temp_datas{:}),[3 1 2]);
            datas{index}.trialinfo = 1:numel(temp_datas);
            datas{index} = rmfield(datas{index}, "avg");
            datas{index} = rmfield(datas{index}, "dimord");
        end
        med = [];    
    else
        for index = 1:numel(datas)
            temp_thin = thin{index}.avg(2:end);
            temp_med = med{index}.avg(2:end);
            temp_thick = thick{index}.avg(2:end);
            thin{index}.trial = permute(cat(3,temp_thin{:}),[3 1 2]);
            med{index}.trial = permute(cat(3,temp_med{:}),[3 1 2]);
            thick{index}.trial = permute(cat(3,temp_thick{:}),[3 1 2]);
            thin{index}.trialinfo = 1:numel(temp_thin);
            med{index}.trialinfo = 1:numel(temp_med);
            thick{index}.trialinfo = 1:numel(temp_thick);
            thin{index} = rmfield(thin{index}, "avg");
            thin{index} = rmfield(thin{index}, "dimord");
            med{index} = rmfield(med{index}, "avg");
            med{index} = rmfield(med{index}, "dimord");
            thick{index} = rmfield(thick{index}, "avg");
            thick{index} = rmfield(thick{index}, "dimord");
        end
    end

    step = 1/512;
    start = time(1);
    endt = time(2);

    cfg = [];
    cfg.output = output;
    cfg.method = 'wavelet';
    cfg.width = wavelet_width;
    cfg.foi = frequency_range(1):1:frequency_range(2); 
    cfg.toi = start:step:endt;
    cfg.pad = 'nextpow2';
    cfg.channel = 'all';
    cfg.trials = 'all';
    cfg.keeptrials = 'yes';
    %cfg.parameter = 'avg';
    
parfor index = 1:numel(datas)
        if strcmp(cfg.output, 'pow')
            thin{index} = ft_freqanalysis(cfg, thin{index});
            med{index} = ft_freqanalysis(cfg, med{index});
            thick{index} = ft_freqanalysis(cfg, thick{index});

            idx = interp1(thin{index}.time, 1:length(thin{index}.time), temp_time, 'nearest');

            tx = thin{index}.elec;
            mx = med{index}.elec;
            thx = thick{index}.elec;

            cfgm = [];
            thin{index} = ft_freqdescriptives(cfgm, thin{index});
            med{index} = ft_freqdescriptives(cfgm, med{index});
            thick{index} = ft_freqdescriptives(cfgm, thick{index});
            
            thin{index}.elec = tx;
            med{index}.elec = mx;
            thick{index}.elec = thx;
            
            tx = baseline_freq(thin{index}, baseline_period);
            mx = baseline_freq(med{index}, baseline_period);
            thx = baseline_freq(thick{index}, baseline_period);

            tm = tx.time(idx:end);

            thin{index}.time = tm;
            med{index}.time = tm;
            thick{index}.time = tm;

            thin{index}.powspctrm = tx.powspctrm(:,:,idx:end);
            med{index}.powspctrm = mx.powspctrm(:,:,idx:end);
            thick{index}.powspctrm = thx.powspctrm(:,:,idx:end);
            
            datas{index} = med{index};

            datas{index}.thin_powspctrm = thin{index}.powspctrm;
            datas{index}.med_powspctrm = med{index}.powspctrm;
            datas{index}.thick_powspctrm = thick{index}.powspctrm;
            datas{index}.powspctrm = datas{index}.med_powspctrm - (datas{index}.thin_powspctrm + datas{index}.thick_powspctrm) / 2;
        else
            
            %datas = ft_freqanalysis(cfg, datas{index});
            %datas.thin_fourierspctrm = thin.fourierspctrm;
            %datas.med_fourierspctrm = med.fourierspctrm;
            %datas.thick_fourierspctrm = thick.fourierspctrm;

        end

end

end
