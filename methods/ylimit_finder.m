function [high, low] = ylimit_finder(data,electrode)

    %% This method finds the y limits for ERPs

    if isstruct(data)
        if (isfield(data, 'med'))
            
        elseif (isfield(data, 'data'))
            data = data.data;
        end
    end


    elec_index = get_electrode_index(data,electrode);

    if electrode.time >= 3.06
        start_time = 2.8;
        end_time = 3.99;
    else
        start_time = 0;
        end_time = 3.0;
    end

    [~, start_idx] = min(abs(data{1}.time - start_time));
    [~, end_idx] = min(abs(data{1}.time - end_time));


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
        cfg.parameter = ['powspctrm'];
    else
        time = false;
        cfg.parameter = ['powspctrm'];
    end

    nums = [];

    if time

        if ~(isfield(unit, 'PGI'))
            [thin,med,thick] = split_data(data);

            temp = [data,thin,med,thick];
        else
            temp = data;
        end

            tempseries = [];
            for item = 1:numel(temp)
                x = get_timeseries_data_electrode(temp{item},elec_index,'avg');
                x = x(start_idx:end_idx);
                tempseries(item,:) = x;
            end


             nums = prctile(tempseries,[5,95],1);


          

            
        
    else
        if ~isstruct(data)
        for index = 1:length(data)
            temp = ft_freqgrandaverage(cfg, data{index});
            temp.powspctrm = squeeze(mean(temp.powspctrm(:, :, :), 2));
              

            tempseries = []
            for item = 1:length(cfg.parameter)
                tempseries(item,:) = get_timeseries_data_electrode(temp,elec_index,cfg.parameter);
            end

            nums(index,:) = [max(max(tempseries)), min(min(tempseries))];

        end
        else
            temp = ft_freqgrandaverage(cfg, data);

            tempseries = []
            for item = 1:length(cfg.parameter)
                tempseries(item,:) = get_timeseries_data_electrode(temp,elec_index,cfg.parameter);
            end

            nums(index,:) = [max(max(tempseries)), min(min(tempseries))];
        end
    end


     high = (round((max(prctile(nums,95,2)))*2)/2) -1;
     low = (round((min(prctile(nums,5,2)))*2)/2) +1;


end
