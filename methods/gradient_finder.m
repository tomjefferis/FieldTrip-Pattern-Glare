function [gradients] = gradient_finder(data, significant_electrode)

    electrode_index = get_electrode_index(data, significant_electrode);

    %% loop each item in data and find the gradient
    gradients = [];

    for index = 1:numel(data)
        % get the data for the current item
        current_data = data{index};
        % get the data for the current electrode
        current_electrode_data = current_data.avg(electrode_index, :);
        % fit a line to the data 
        [p, S] = polyfit(current_data.time, current_electrode_data, 1);
        % get the gradient
        gradient = p(1);
        % add the gradient to the list
        gradients = [gradients gradient];
    end

end
