function [design_matrix, participant_data] = get_design_matrix(factor, data, order)
    % if there is no factor it returns a design matrix of 64 len, 32 1's and 32 0's
    if strcmp(factor, 'none')
        n_part = numel(data);
        design_matrix = [1:n_part 1:n_part; ones(1, n_part) 2 * ones(1, n_part)];
        participant_data = data;
    else
        % if there is a factor it returns the factor scores for the participants as the design matrix
        if contains(factor, '-partitions') || contains(factor, 'onsets-23-45-67')

            [design_matrix1, data1] = get_factor_scores(factor, order, data.part1);
            [design_matrix2, data2] = get_factor_scores(factor, order, data.part2);
            [design_matrix3, data3] = get_factor_scores(factor, order, data.part3);

        else
            [design_matrix, participant_data] = get_factor_scores(factor, order, data);
            return
        end

        if ~contains(factor, 'none')
            min_n = min([design_matrix1, design_matrix2, design_matrix3]);
            design_matrix1 = design_matrix1 - min_n;
            design_matrix2 = design_matrix2 - min_n;
            design_matrix3 = design_matrix3 - min_n;
        end

        if contains(factor, 'habituation')
            design_matrix1 = design_matrix1 * 2.72;
            design_matrix2 = design_matrix2 * 1.65;
            design_matrix3 = design_matrix3 * 1.00;

        elseif contains(factor, 'sensitization')

            design_matrix1 = design_matrix1 * 1.00;
            design_matrix2 = design_matrix2 * 1.65;
            design_matrix3 = design_matrix3 * 2.72;
        end

        [~, n_participants] = size(design_matrix1);

        for k = 1:n_participants

            if contains(factor, 'habituation')
                to_remove = design_matrix3(k);
            elseif contains(factor, 'sensitization')
                to_remove = design_matrix1(k);
            end

            design_matrix1(k) = design_matrix1(k) - to_remove;
            design_matrix2(k) = design_matrix2(k) - to_remove;
            design_matrix3(k) = design_matrix3(k) - to_remove;

        end

        min_n = mean([design_matrix1, design_matrix2, design_matrix3]);
        design_matrix1 = design_matrix1 - min_n;
        design_matrix2 = design_matrix2 - min_n;
        design_matrix3 = design_matrix3 - min_n;

        design_matrix.one = design_matrix1;
        design_matrix.two = design_matrix2;
        design_matrix.three = design_matrix3;

        participant_data.one = data1;
        participant_data.two = data2;
        participant_data.three = data3;

    end

end