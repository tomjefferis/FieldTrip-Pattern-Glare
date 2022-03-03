function [data] = average_power(data,frequency_range)




    cfg = [];
    cfg.foilim = frequency_range;


    datas = ft_freqgrandaverage(cfg,data{:});
    cfg.parameter = 'med_powspctrm';
    temp = ft_freqgrandaverage(cfg,data{:});
    datas.med_powspctrm = temp.med_powspctrm;

    data = datas;
end