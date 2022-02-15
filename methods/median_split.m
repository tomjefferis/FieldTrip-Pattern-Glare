function [low, high] = median_split(data, order, design_matrix)

    [design_vals, order] = sort(design_matrix);
    half = round(length(design_matrix) / 2);

    lower_scores = design_vals(1:half);
    upper_scores = design_vals(half + 1:end);

    lower = order(1:half);
    upper = order(half + 1:end);

    lower_data = {};
    upper_data = {};

    for index = 1:length(data)

        if ismember(index, lower)
            lower_data{end + 1} = data{index};
        elseif ismember(index, upper)
            upper_data{end + 1} = data{index};
        end

    end

    low.scores = lower_scores;
    low.data = lower_data;

    high.scores = upper_scores;
    high.data = upper_data;

end