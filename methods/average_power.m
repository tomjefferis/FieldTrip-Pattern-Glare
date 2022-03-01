function [itc] = average_power(data)


    itc = [];
    itc.label = data{1}.label;
    itc.freq = data{1}.freq;
    itc.time = data{1}.time;
    itc.dimord = 'chan_freq_time';

    itpc = zeros(size(data{1}.powspctrm));
    

    for index = 1:numel(data)

        itpc = itpc + data{index}.powspctrm;
        
    end

    itc.itpc = itpc/numel(data);
    

end