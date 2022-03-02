function [data] = average_power(data,frequency_range)


    cfg = [];
    cfg.foilim = frequency_range;

    data = ft_freqgrandaverage(cfg,data{:});


end