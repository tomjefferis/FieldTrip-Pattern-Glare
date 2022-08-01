function tfr_plotter(datas, electrode, factor,results)
    %TFR_PLOTTER Summary of this function goes here
    %   Detailed explanation goes here


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

    cfg = [];
    grandavg = ft_freqgrandaverage(cfg, datas{:});
    
    cfg = [];
    cfg.baselinetype = 'db';
    cfg.zlim         = [-1.5 1.5];
    cfg.channel = get_electrode_index(grandavg, electrode);
    ft_singleplotTFR(cfg, grandavg);
    title(strcat("TFR Plot at ", string(electrode.electrode), "PGI"))
    save_dir_full = strcat(results, "/", results_fact, "/","PGI ", imgname);
    saveas(gcf, save_dir_full);


    cfg = [];
    cfg.parameter = "med_powspctrm";
    grandavg = ft_freqgrandaverage(cfg, datas{:});
    grandavg.powspctrm = grandavg.med_powspctrm;

    cfg = [];
    cfg.baselinetype = 'db';
    cfg.zlim         = [-1.5 1.5];
    cfg.channel = get_electrode_index(grandavg, electrode);
    ft_singleplotTFR(cfg, grandavg);
    title(strcat("TFR Plot at ", string(electrode.electrode), "Medium Stimulus"));

    save_dir_full = strcat(results, "/", results_fact, "/","Med ", imgname);
    saveas(gcf, save_dir_full);
end
