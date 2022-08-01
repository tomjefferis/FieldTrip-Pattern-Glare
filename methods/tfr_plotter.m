function tfr_plotter(datas, electrode, results,factor)
    %TFR_PLOTTER Summary of this function goes here
    %   Detailed explanation goes here

    cfg = [];
    grandavg = ft_freqgrandaverage(cfg, datas{:});
    
    cfg = [];
    cfg.baselinetype = 'db';
    %cfg.maskstyle    = 'saturation';
    %cfg.zlim         = [-2.5e-27 2.5e-27];
    cfg.channel = get_electrode_index(grandavg, electrode);
    subplot(2,1,1)
    ft_singleplotTFR(cfg, grandavg);
    title(strcat("TFR Plot at ", electrode, "PGI"))

    cfg = [];
    cfg.parameter = "med_powspctrm";
    grandavg = ft_freqgrandaverage(cfg, datas{:});
    grandavg.powspctrm = grandavg.med_powspctrm;

    cfg = [];
    cfg.baselinetype = 'db';
    cfg.parameter = "med_powspctrm";
    %cfg.maskstyle    = 'saturation';
    %cfg.zlim         = [-2.5e-27 2.5e-27];
    cfg.channel = get_electrode_index(grandavg, electrode);
    subplot(2,1,2)
    ft_singleplotTFR(cfg, grandavg);
    title(strcat("TFR Plot at ", electrode, "Medium Stimulus"));

    if contains(factor, "habituation") || contains(factor, "sensitization")

        if contains(factor, "visual")
            results_fact = "visual-stress";
            imgname = "visual-stress partitions TFR Plot.png";
        elseif contains(factor, "headache")
            results_fact = "headache";
            imgname = "headache partitions TFR Plot.png";
        elseif contains(factor, "discomfort")
            results_fact = "discomfort";
            imgname = "discomfort partitions TFR Plot.png";
        else
            results_fact = "none";
            imgname = strcat("none partitions TFR Plot.png");
        end

    else
        results_fact = factor;
        imgname = strcat(factor, " onsets TFR Plot.png");
    end


    save_dir_full = strcat(results, "/", results_fact, "/", imgname);
    saveas(gcf, save_dir_full);
end
