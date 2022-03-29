function [data] = rebaseline_data(data, baseline_period)

    cfg = [];
    cfg.parameter = setdiff(fieldnames(data{1}),{'label','time','trialinfo','elec','dimord',});
    cfg.baseline = baseline_period;


    for index = 1:size(data,2)
        data{index} = ft_timelockbaseline(cfg,data{index});
    end
    

end