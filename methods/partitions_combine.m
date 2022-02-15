function [data] = partitions_combine(data1, data2, data3, pgi)

% combines data series from partitions to be used in standard erp plotting fucntions 
% Use as:
%       partitions_combine(data1, data2, data3, pgi)
%   Where data1, data2, and data3 is a cell array containing FT data objects returned from FT_TIMELOCKANALYSIS
%   and pgi is a string to denote weather we are wanting to combine the pattern glare index or the medium series




    if strcmp(pgi, "PGI")
        data = data1;

        for idx = 1:numel(data)
            participant_data = data{idx};
            participant_data.thin = data1{idx}.avg;
            participant_data.med = data2{idx}.avg;
            participant_data.thick = data3{idx}.avg;
            data{idx} = participant_data;
        end

    else
        data = data1;

        for idx = 1:numel(data)
            participant_data = data{idx};
            participant_data.thin = data1{idx}.med;
            participant_data.med = data2{idx}.med;
            participant_data.thick = data3{idx}.med;
            data{idx} = participant_data;
        end

    end

end