function [design_matrix, participant_data] = get_design_matrix(factor, data, order)
    % if there is no factor it returns a design matrix of 64 len, 32 1's and 32 0's
    if strcmp(factor, 'none')
        n_part = numel(data);
        design_matrix = [1:n_part 1:n_part; ones(1, n_part) 2 * ones(1, n_part)];
        participant_data = data;
    else
        % if there is a factor it returns the factor scores for the participants as the design matrix
        if ~contains(factor, 'partitions-vs')&&(contains(factor, '-partitions') || contains(factor, 'onsets-23-45-67'))

            [design_matrix1, data1] = get_factor_scores(factor, order, data.part1);
            [design_matrix2, data2] = get_factor_scores(factor, order, data.part2);
            [design_matrix3, data3] = get_factor_scores(factor, order, data.part3);


            
        elseif contains(factor, '-partitions-vs-onsets')

        %fix bug
        if iscell(factor)
            factor = factor{1};
        end


            if factor(1) == 'h'
                type_effect = 'habituation';
            else
                type_effect = 'sensitization';
            end



            if contains(factor, 'headache')

                [design_matrix1, data1] = get_design_matrix(strcat('headache-partitions-',type_effect), data.part1, order);
                [design_matrix2, data2] = get_design_matrix(strcat('headache-partitions-',type_effect), data.part2, order);
                [design_matrix3, data3] = get_design_matrix(strcat('headache-partitions-',type_effect), data.part3, order);

                
                

            elseif contains(factor, 'discomfort')

                [design_matrix1, data1] = get_design_matrix(strcat('discomfort-partitions-',type_effect), data.part1, order);
                [design_matrix2, data2] = get_design_matrix(strcat('discomfort-partitions-',type_effect), data.part2, order);
                [design_matrix3, data3] = get_design_matrix(strcat('discomfort-partitions-',type_effect), data.part3, order);


            elseif contains(factor, 'visual-stress')

                [design_matrix1, data1] = get_design_matrix(strcat('visual-stress-partitions-',type_effect), data.part1, order);
                [design_matrix2, data2] = get_design_matrix(strcat('visual-stress-partitions-',type_effect), data.part2, order);
                [design_matrix3, data3] = get_design_matrix(strcat('visual-stress-partitions-',type_effect), data.part3, order);
                
            end

                design_matrix1 = [design_matrix1.one, design_matrix1.two, design_matrix1.three];
                design_matrix2 = [design_matrix2.one, design_matrix2.two, design_matrix2.three];
                design_matrix3 = [design_matrix3.one, design_matrix3.two, design_matrix3.three];

                data1 = [data1.one, data1.two, data1.three];
                data2 = [data2.one, data2.two, data2.three];
                data3 = [data3.one, data3.two, data3.three];



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

        %fix bug
        if iscell(factor)
            factor = factor{1};
        end
        % another bug fix... matlab sometimes thinks factor var is function
        % so crashes when factor(end-5) == 'u' is called
        try(factor(end-5)== 'u')
        catch
            factor = char(factor); % dodgy fix
        end

        if factor(end-5) == 'u'
            design_matrix1 = design_matrix1 * 2.72;
            design_matrix2 = design_matrix2 * 1.65;
            design_matrix3 = design_matrix3 * 1.00;

        else

            design_matrix1 = design_matrix1 * 1.00;
            design_matrix2 = design_matrix2 * 1.65;
            design_matrix3 = design_matrix3 * 2.72;
        end

        [~, n_participants] = size(design_matrix1);

        for k = 1:n_participants

            if factor(end-5) == 'u'
                to_remove = design_matrix3(k);
            else
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

        if contains(factor, 'orthog')

            


            if ~contains(factor, 'partitions-vs')&&(contains(factor, '-partitions') || contains(factor, 'onsets-23-45-67'))

                if contains(factor, 'habituation')
                g = 'habituation';
            elseif contains(factor, 'sensitization')
                g = 'sensitization';
            end

                [vs, datas] = get_design_matrix(strcat('visual-stress-partitions','-',g), data, order);
                vs = [vs.one,vs.two,vs.three];
    
                [hd, datas] = get_design_matrix(strcat('headache-partitions','-',g), data, order);
                hd = [hd.one,hd.two,hd.three];
    
                [diss, datas] = get_design_matrix(strcat('discomfort-partitions','-',g), data, order);
                diss = [diss.one,diss.two,diss.three];
            elseif contains(factor, 'partitions-vs-onsets')


                if factor(end-5) == 'u'
                g = 'habituation';
                else
                g = 'sensitization';
                end

                [vs, datas] = get_design_matrix(strcat(type_effect,'-','visual-stress-partitions-vs-onsets-normal','-',g), data, order);
                vs = [vs.one,vs.two,vs.three];

            [hd, datas] = get_design_matrix(strcat(type_effect,'-','headache-partitions-vs-onsets-normal','-',g), data, order);
            hd = [hd.one,hd.two,hd.three];

            [diss, datas] = get_design_matrix(strcat(type_effect,'-','discomfort-partitions-vs-onsets-normal','-',g), data, order);
            diss = [diss.one,diss.two,diss.three];


            end


            X1(:,1) = vs;
            X1(:,2) = hd;
            X1(:,3) = diss;

            orthog_data = gschmidt(X1, 1);
            num = length(order);

            if contains(factor, 'visual-stress')
                dm = orthog_data(:,1);
            elseif contains(factor, 'headache')
                dm = orthog_data(:,2);
            elseif contains(factor, 'discomfort')
                dm = orthog_data(:,3);
            end


            if~(contains(factor, 'partitions-vs-onsets'))
            dm = reshape(dm,num,[]);

            design_matrix.one = rot90(dm(:,1));
            design_matrix.two = rot90(dm(:,2));
            design_matrix.three = rot90(dm(:,3));
            else
               dm = reshape(dm,(num*3),[]);

                design_matrix.one = rot90(dm(:,1));
                design_matrix.two = rot90(dm(:,2));
                design_matrix.three = rot90(dm(:,3));                
            end

           
        else
            design_matrix.one = design_matrix1;
            design_matrix.two = design_matrix2;
            design_matrix.three = design_matrix3;
        end
        participant_data.one = data1;
        participant_data.two = data2;
        participant_data.three = data3;

    end

end