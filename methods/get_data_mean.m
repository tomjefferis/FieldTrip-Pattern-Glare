function [mean] = get_data_mean(data)

% gets average for time series used in bootstrapping
% 
% Use as:
%       get_data_mean(data)
%   Where data is a single timeseries from one electrode
%   
%


    divider = numel(data);
    mean = data{1};

    for index = 2:numel(data)
        datas = data{index};
        mean = mean + datas;
    end

    mean = mean / divider;
end