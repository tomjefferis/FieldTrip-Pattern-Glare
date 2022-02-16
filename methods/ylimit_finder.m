function [high, low] = ylimit_finder(data,electrode)

    %% This method finds the y limits for ERPs


    elec_index = get_electrode_index(data(1),electrode);

    cfg = [];
    unit = data(1);
    unit = unit{1};

    time = true;

    if (isfield(unit, 'med'))
        cfg.parameter = ['avg', 'thin', 'med', 'thick'];
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
        for index = 1:length(data)
            temp = ft_timelockgrandaverage(cfg, data(index));

            tempseries = []
            for item = 1:length(cfg.parameter)
                tempseries(item,:) = get_timeseries_data_electrode(temp,elec_index,cfg.parameter(item));
            end

            nums(index,:) = [max(tempseries,'all'), min(tempseries,'all'),];


        end
    else
        for index = 1:length(data)
            temp = ft_freqgrandaverage(cfg, data(index));

            tempseries = []
            for item = 1:length(cfg.parameter)
                tempseries(item,:) = get_timeseries_data_electrode(temp,elec_index,cfg.parameter(item));
            end

            nums(index,:) = [max(tempseries,'all'), min(tempseries,'all'),];

        end
    end


    high = round(max(nums,'all')) + 0.2;
    low = round(min(nums,'all')) - 0.2;


end
