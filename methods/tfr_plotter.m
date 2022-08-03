function tfr_plotter(datas, electrode, factor,results,posneg,save)
    %TFR_PLOTTER Summary of this function goes here
    %   Detailed explanation goes here

    if ~exist("save","var") 
        save = false;
    end


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
    subplot(2,1,1);
    tfr_low(grandavg,electrode,grandavg.freq);
    title(strcat("TFR Plot at ", string(electrode.electrode), " PGI, ",posneg))
    if save
        save_dir_full = strcat(results, "/", results_fact, "/",posneg," PGI ", imgname);
    saveas(gcf, save_dir_full);
    end

    cfg = [];
    cfg.parameter = "med_powspctrm";
    grandavg = ft_freqgrandaverage(cfg, datas{:});
    grandavg.powspctrm = grandavg.med_powspctrm;

    subplot(2,1,2);
    tfr_low(grandavg,electrode,grandavg.freq);
    title(strcat("TFR Plot at ", string(electrode.electrode), " Medium Stimulus, ",posneg));

    if save
        save_dir_full = strcat(results, "/", results_fact, "/",posneg," Med ", imgname);
        saveas(gcf, save_dir_full);
    end
end
