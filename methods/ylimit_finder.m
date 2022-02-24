function [high, low] = ylimit_finder(data,electrode)

    %% This method finds the y limits for ERPs

    if isstruct(data)
        if (isfield(data, 'med'))
            
        elseif (isfield(data, 'data'))
            data = data.data;
        end
    end


    elec_index = get_electrode_index(data,electrode);

    cfg = [];
    unit = data(1);
    unit = unit{1};

    time = true;

    if (isfield(unit, 'med'))
        cfg.parameter = ['avg'];
    elseif (isfield(unit, 'avg'))
        cfg.parameter = ['avg'];
    elseif (isfield(unit, 'thin_powspctrm'))
        time = false;
        cfg.parameter = ['powspctrm','thin_powspctrm','med_powspctrm','thick_powspctrm'];
    else
        time = false;
        cfg.parameter = ['powspctrm'];
    end

    nums = [];

    if time

            [thin,med,thick] = split_data(data);

            

            temp = [data,thin,med,thick];

            tempseries = [];
            for item = 1:numel(temp)
                tempseries(item,:) = get_timeseries_data_electrode(temp{item},elec_index,'avg');
            end

          

            nums =  prctile(tempseries,[2,98],'all');
        
    else
        if ~isstruct(data)
        for index = 1:length(data)
            temp = ft_freqgrandaverage(cfg, data(index));

            tempseries = []
            for item = 1:length(cfg.parameter)
                tempseries(item,:) = get_timeseries_data_electrode(temp,elec_index,cfg.parameter(item));
            end

            nums(index,:) = [max(max(tempseries)), min(min(tempseries))];

        end
        else
            temp = ft_freqgrandaverage(cfg, data(index));

            tempseries = []
            for item = 1:length(cfg.parameter)
                tempseries(item,:) = get_timeseries_data_electrode(temp,elec_index,cfg.parameter(item));
            end

            nums(index,:) = [max(max(tempseries)), min(min(tempseries))];
        end
    end


    high = round((max(max(nums)) + 0.51)*2)/2;
    low = round((min(min(nums)) - 0.51)*2)/2;


end
