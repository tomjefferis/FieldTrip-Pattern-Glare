function [itc] = average_itc(data)


    itc = [];
    itc.label = data{1}.label;
    itc.freq = data{1}.freq;
    itc.time = data{1}.time;
    itc.dimord = 'chan_freq_time';

    itpc = zeros(size(data{1}.itpc));
    itlc = zeros(size(data{1}.itlc));

    for index = 1:numel(data)

        itpc = itpc + data{index}.itpc;
        itlc = itlc+ data{index}.itlc;
    end

    itc.itpc = itpc/numel(data);
    itc.itlc = itlc/numel(data);

end