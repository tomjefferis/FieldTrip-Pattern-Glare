function data = pad_series(data, pad_samp, step)

    time_Start = 1;
    [~, time_End] = min(abs(data{1}.time));
    time_End = time_End-1;
    timelen = time_End - time_Start + 1;

    for index = 1:numel(data)
        data1 = data{index}.avg;
        data_time = data{index}.time;
        data{index}.time = linspace(data_time(1)-4*timelen*step, data_time(end)+pad_samp*step, length(data_time)+4*timelen+pad_samp);

    for av = 1:numel(data1)
        pad_data = data1{av}(:,time_Start:time_End);
        pad_mirror = fliplr(pad_data);
        data1{av} = [pad_data,pad_mirror,pad_data,pad_mirror,data1{av}];
        data1{av} = ft_preproc_padding(data1{av},'mirror', 0, pad_samp);
    end
    data{index}.avg = data1;
end
end