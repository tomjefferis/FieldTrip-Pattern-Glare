function data = pad_series(data, pad_samp, step)
    for index = 1:numel(data)
        data1 = data{index}.avg;
        data_time = data{index}.time;
        data{index}.time = linspace(data_time(1)-step*pad_samp, data_time(end)+step*pad_samp, length(data_time)+2*pad_samp);
    for av = 1:numel(data1)
        data1{av} = ft_preproc_padding(data1{av},'mirror', pad_samp, pad_samp);
    end
    data{index}.avg = data1;
end
end