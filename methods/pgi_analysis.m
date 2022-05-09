function tab = pgi_analysis(grand_avg_filename, single_trial_filename, grand_avg_partitions_filename, time_window, n_participants, baseline_period, ...
        aggregated_roi, max_windows, spatial_roi, posneg, stat_run, wavelet_width, frequency_range, clust_volume, topograpic_map_plot, ...
        plot_erps, median_split_plots, gfp_plot, plot_designs, plot_partitions_erps, generate_ci, time_freq, factor_scores, ...
        onsets_part, type_of_effect,three_way_type, orthoganilized_partitions, testing)

    %% Experiment setup
    [results_dir, main_path] = getFolderPath();
    % If the factors are all then it sets all the factors
    if strcmp(factor_scores{1}, 'all') && ~contains(orthoganilized_partitions, 'orthog') && (contains(onsets_part, 'onsets') || contains(onsets_part, 'partition1'))
        factor_scores = {'none', 'headache', 'visual-stress', 'discomfort'};
    elseif strcmp(factor_scores{1}, 'all') && contains(orthoganilized_partitions, 'orthog')
        factor_scores = {'headache', 'visual-stress', 'discomfort'};
    end

    %setting folder path to output to time or freq folders
    results_dir = strcat(results_dir, "/", time_freq);

    % Global field power setup
    global_start_time = min(min(time_window));
    global_end_time = max(max(time_window));
    % will use this to split into seperate analysis windows
    if aggregated_roi
        time = aggregated_roi_finder(main_path, single_trial_filename, n_participants, global_start_time, global_end_time, baseline_period, max_windows, results_dir, gfp_plot); % use inputs for size of window to look at, peak or any integer of samples/s
    else
        time = time_window;
    end

    %% sets up stat return scores
    stat_scores = struct('Factor_Name', {}, 'Positive_Cluster', {}, 'Negative_Cluster', {});

    %% The Main Program Loop
    if strcmp(onsets_part, 'onsets') || strcmp(onsets_part, 'partition1')
        clf;
        % Loads Averaged data (1 timeseries per conditon per patricipant)
        if strcmp(time_freq, 'time') && ~strcmp(onsets_part, 'partition1')
            [datas, orders] = load_data(main_path, grand_avg_filename, n_participants, onsets_part);
        elseif strcmp(time_freq, 'time') && strcmp(onsets_part, 'partition1')
            [datas, orders] = load_data(main_path, grand_avg_partitions_filename, n_participants, onsets_part);
        else

            filename_precomposed = strcat(results_dir, "/", onsets_part, "/", string(wavelet_width), "-cyc-pow-", "decomposed_dat.mat");

            if ~exist(filename_precomposed, 'file')
                [datas, orders] = load_data(main_path, single_trial_filename, n_participants, onsets_part);

                [datas] = freq_power_decopmosition(datas, wavelet_width, filename_precomposed);

            else
                data = load(filename_precomposed).decomposed;
                datas = data.data;
                orders = data.order;
                data = []; % clearing memory for this var
            end

            %cfg = [];
            %grandavg = ft_freqgrandaverage(cfg, datas{:});
        end

        if sum(baseline_period == [2.8 3.0]) < 2
            datas = rebaseline_data(datas, baseline_period);
        end

        %for every time windows
        for index = 1:size(time, 1)
            % gets the time window, either selected by the roi finder or
            start_time = time(index, 1);
            end_time = time(index, 2);
            % for every factor score
            for factor = factor_scores

                if spatial_roi && ~strcmp(factor{1}, 'none')
                    % finds spatial ROI
                    datas_pure = datas;
                    datas = roi_mask(datas, orders, start_time, end_time, results_dir, time_freq, frequency_range, posneg, main_path, grand_avg_filename, n_participants, onsets_part);
                end

                % gets the design matrix
                [design_matrix, data] = get_design_matrix(factor, datas, orders);

                % only runs the stat if spec
                if clust_volume || topograpic_map_plot || stat_run || plot_erps
                    stat = stat_test(data, factor, start_time, end_time, design_matrix, time_freq, frequency_range, testing);

                    for cluster = 1:3
                        % adding stat result to the list
                        stat_name = strcat(factor, " ", string(start_time), "-", string(end_time), " Cluster: ", string(cluster));
                        [~, jindex] = size(stat_scores);
                        stat_scores(jindex + 1).Factor_Name = stat_name;

                        try
                            elec = compute_best_electrode(stat, "positive", cluster);

                            cohens_d = round((2 * elec.t_value) / sqrt(stat.df), 2);
                            effect_size = round(sqrt((elec.t_value * elec.t_value) / ((elec.t_value * elec.t_value) + stat.df)), 2);

                            tempvar = [stat.posclusters.prob];
                            stat_scores(jindex + 1).Positive_Cluster = tempvar(cluster);
                            stat_scores(jindex + 1).Positive_Cluster_Electrode = {elec.electrode};
                            stat_scores(jindex + 1).Positive_Electrode_T = {elec.t_value};
                            stat_scores(jindex + 1).Positive_Electrode_Time = {elec.time};
                            stat_scores(jindex + 1).Positive_Effect_size = effect_size;
                            stat_scores(jindex + 1).Positive_Cohens_D = cohens_d;
                        catch E
                            stat_scores(jindex + 1).Positive_Cluster = 'N/A';
                            stat_scores(jindex + 1).Positive_Cluster_Electrode = 'N/A';
                            stat_scores(jindex + 1).Positive_Electrode_T = 'N/A';
                            stat_scores(jindex + 1).Positive_Electrode_Time = 'N/A';
                            stat_scores(jindex + 1).Positive_Effect_size = 'N/A';
                            stat_scores(jindex + 1).Positive_Cohens_D = 'N/A';
                        end

                        try
                            elec = compute_best_electrode(stat, "negative", cluster);

                            cohens_d = round((2 * elec.t_value) / sqrt(stat.df), 2);
                            effect_size = round(sqrt((elec.t_value * elec.t_value) / ((elec.t_value * elec.t_value) + stat.df)), 2);

                            tempvar = [stat.negclusters.prob];
                            stat_scores(jindex + 1).Negative_Cluster = tempvar(cluster);
                            stat_scores(jindex + 1).Negative_Cluster_Electrode = {elec.electrode};
                            stat_scores(jindex + 1).Negative_Electrode_T = {elec.t_value};
                            stat_scores(jindex + 1).Negative_Electrode_Time = {elec.time};
                            stat_scores(jindex + 1).Negative_Effect_size = effect_size;
                            stat_scores(jindex + 1).Negative_Cohens_D = cohens_d;
                        catch E
                            stat_scores(jindex + 1).Negative_Cluster = 'N/A';
                            stat_scores(jindex + 1).Negative_Cluster_Electrode = 'N/A';
                            stat_scores(jindex + 1).Negative_Electrode_T = 'N/A';
                            stat_scores(jindex + 1).Negative_Electrode_Time = 'N/A';
                            stat_scores(jindex + 1).Negative_Effect_size = 'N/A';
                            stat_scores(jindex + 1).Negative_Cohens_D = 'N/A';
                        end

                    end

                end

                if spatial_roi && ~strcmp(factor{1}, 'none')
                    % finds spatial ROI
                    datas = datas_pure;
                end

                %% Topomap plotter
                if topograpic_map_plot

                    try
                        Negative_Cluster = stat.negclusters.prob;
                    catch e
                        Negative_Cluster = 1;
                    end

                    try
                        Positive_Cluster = stat.posclusters.prob;

                    catch e
                        Positive_Cluster = 1;

                    end

                    if Negative_Cluster <= 0.2
                        plot_topo_map(stat, start_time, end_time, "negative", factor, results_dir);
                    end

                    if Positive_Cluster <= 0.2
                        plot_topo_map(stat, start_time, end_time, "positive", factor, results_dir);
                    else
                        fprintf("Nothing significant to plot on a topographic map");
                    end

                end

                %% plot design matrix
                if plot_designs
                    plot_design_onsets(design_matrix, results_dir, factor);
                end

                %% cluster volume over time plotter
                if clust_volume

                    try
                        Negative_Cluster = stat.negclusters.prob;
                    catch
                        Negative_Cluster = 1;
                    end

                    try
                        Positive_Cluster = stat.posclusters.prob;
                    catch
                        Positive_Cluster = 1;
                    end

                    if Negative_Cluster <= 0.2
                        plot_cluster_vol(stat, factor, start_time, end_time, "negative", results_dir);
                    end

                    if Positive_Cluster <= 0.2
                        plot_cluster_vol(stat, factor, start_time, end_time, "positive", results_dir);
                    else
                        fprintf("No significant clusters to plot");
                    end

                end

                %% Standard erp plots
                if plot_erps %&& contains(factor,"none")

                    try
                        Negative_Cluster = stat.negclusters.prob;
                    catch
                        Negative_Cluster = 1;
                    end

                    try
                        Positive_Cluster = stat.posclusters.prob;
                    catch
                        Positive_Cluster = 1; median_split_plots
                    end

                    if Negative_Cluster <= 0.2
                        significant_electrode = compute_best_electrode(stat, "negative");
                        plot_peak_electrode(stat, significant_electrode, results_dir);
                        clf;
                        generate_erp_plot(results_dir, start_time, end_time, data, significant_electrode, factor, generate_ci, "negative");
                        clf;
                        generate_erp_pgi(results_dir, start_time, end_time, data, significant_electrode, factor, generate_ci, "negative");
                    end

                    if Positive_Cluster <= 0.2
                        significant_electrode = compute_best_electrode(stat, "positive");
                        plot_peak_electrode(stat, significant_electrode, results_dir);
                        clf;
                        generate_erp_plot(results_dir, start_time, end_time, data, significant_electrode, factor, generate_ci, "positive");
                        clf;
                        generate_erp_pgi(results_dir, start_time, end_time, data, significant_electrode, factor, generate_ci, "positive");
                    else
                        fprintf("No significant clusters to plot");
                    end

                end

                %% Median split
                if median_split_plots && ~contains(factor, "none")
                    Negative_Cluster = stat.negclusters.prob;
                    Positive_Cluster = stat.posclusters.prob;
                    [low, high] = median_split(data, 1, design_matrix);

                    if Negative_Cluster <= 0.2
                        significant_electrode = compute_best_electrode(stat, "negative");
                        plot_peak_electrode(stat, significant_electrode, results_dir);
                        clf;
                        plot_medium_split(high, low, significant_electrode, factor, start_time, end_time, generate_ci, results_dir)
                    end

                    if Positive_Cluster <= 0.2
                        significant_electrode = compute_best_electrode(stat, "positive");
                        plot_peak_electrode(stat, significant_electrode, results_dir);
                        clf;
                        plot_medium_split(high, low, significant_electrode, factor, start_time, end_time, generate_ci, results_dir)
                    else
                        fprintf("No significant clusters to plot");
                    end

                end

            end

        end

        savedir = strcat(results_dir, "/", "stat_results", "/", onsets_part, "_", factor, "_", string(start_time), "_", string(end_time), "_Onsets_Stat_Results.xls");
        tab = struct2table(stat_scores)
        writetable(tab, savedir);

    elseif strcmp(onsets_part, 'partitions') || strcmp(onsets_part, 'onsets-23-45-67')
        %for every time windows
        for index = 1:size(time, 1)

            % gets the time window, either selected by the roi finder or
            start_time = time(index, 1);
            end_time = time(index, 2);
            % for every factor score
            for factor = factor_scores

                for effect = type_of_effect
                    % Loads Averaged data (1 timeseries per conditon per patricipant)
                    if strcmp(time_freq, 'time')

                        if strcmp(onsets_part, 'partitions')
                            [datas, orders] = load_data(main_path, grand_avg_partitions_filename, n_participants, onsets_part);
                        else
                            [datas, orders] = load_data(main_path, grand_avg_filename, n_participants, onsets_part);
                        end

                    else

                        if strcmp(onsets_part, 'partitions')
                            filename_precomposed = strcat(results_dir, "/", onsets_part, "/decomposed_dat.mat");

                            if ~exist(filename_precomposed, 'file')
                                [datas, orders] = load_data(main_path, single_trial_freq_partitions_filename, n_participants, onsets_part);

                                [datas, orders] = freq_decopmosition(datas, orders, wavelet_width, filename_precomposed);

                            else
                                data = load(filename_precomposed).decomposed;
                                datas = data.data;
                                orders = data.order;
                                data = []; % clearing memory for this var
                            end

                        else
                            [datas, orders] = load_data(main_path, single_trial_filename, n_participants, onsets_part);
                        end

                    end

                    % sets up the factor for partitions
                    factors = strcat(factor, '-', onsets_part, '-', effect, '-', orthoganilized_partitions);
                    % gets the design matrix
                    [design_matrix, data] = get_design_matrix(factors, datas, orders);
                    % splitting the data to seperate vars
                    data1 = data.one;
                    data2 = data.two;
                    data3 = data.three;

                    if sum(baseline_period == [2.8 3.0]) < 2
                        data1 = rebaseline_data(data1, baseline_period);
                        data2 = rebaseline_data(data2, baseline_period);
                        data3 = rebaseline_data(data3, baseline_period);
                    end

                    % ROI
                    if spatial_roi && ~strcmp(factor{1}, 'none')
                        % finds spatial ROI

                        data1_pure = data1;
                        data2_pure = data2;
                        data3_pure = data3;

                        data1 = roi_mask(data1, orders, start_time, end_time, results_dir, time_freq, frequency_range, posneg, main_path, grand_avg_filename, n_participants, onsets_part);
                        data2 = roi_mask(data2, orders, start_time, end_time, results_dir, time_freq, frequency_range, posneg, main_path, grand_avg_filename, n_participants, onsets_part);
                        data3 = roi_mask(data3, orders, start_time, end_time, results_dir, time_freq, frequency_range, posneg, main_path, grand_avg_filename, n_participants, onsets_part);
                    end

                    % splitting the design matricies
                    design_matrix1 = design_matrix.one;
                    design_matrix2 = design_matrix.two;
                    design_matrix3 = design_matrix.three;
                    % combining each for the stat tests
                    data = [data1, data2, data3];
                    design_matrix = [design_matrix1, design_matrix2, design_matrix3];
                    % only runs the stat if specified
                    if clust_volume || topograpic_map_plot || stat_run || plot_erps
                        stat = stat_test(data, factors, start_time, end_time, design_matrix, time_freq, frequency_range, testing);
                        % adding stat result to the list
                        for cluster = 1:3
                            % adding stat result to the list
                            stat_name = strcat(factor, " ", string(start_time), "-", string(end_time), " Cluster: ", string(cluster));
                            [~, jindex] = size(stat_scores);
                            stat_scores(jindex + 1).Factor_Name = stat_name;

                            try
                                elec = compute_best_electrode(stat, "positive", cluster);

                                cohens_d = round((2 * elec.t_value) / sqrt(stat.df), 2);
                                effect_size = round(sqrt((elec.t_value * elec.t_value) / ((elec.t_value * elec.t_value) + stat.df)), 2);

                                tempvar = [stat.posclusters.prob];
                                stat_scores(jindex + 1).Positive_Cluster = tempvar(cluster);
                                stat_scores(jindex + 1).Positive_Cluster_Electrode = {elec.electrode};
                                stat_scores(jindex + 1).Positive_Electrode_T = {elec.t_value};
                                stat_scores(jindex + 1).Positive_Electrode_Time = {elec.time};
                                stat_scores(jindex + 1).Positive_Effect_size = effect_size;
                                stat_scores(jindex + 1).Positive_Cohens_D = cohens_d;
                            catch E
                                stat_scores(jindex + 1).Positive_Cluster = 'N/A';
                                stat_scores(jindex + 1).Positive_Cluster_Electrode = 'N/A';
                                stat_scores(jindex + 1).Positive_Electrode_T = 'N/A';
                                stat_scores(jindex + 1).Positive_Electrode_Time = 'N/A';
                                stat_scores(jindex + 1).Positive_Effect_size = 'N/A';
                                stat_scores(jindex + 1).Positive_Cohens_D = 'N/A';
                            end

                            try
                                elec = compute_best_electrode(stat, "negative", cluster);

                                cohens_d = round((2 * elec.t_value) / sqrt(stat.df), 2);
                                effect_size = round(sqrt((elec.t_value * elec.t_value) / ((elec.t_value * elec.t_value) + stat.df)), 2);

                                tempvar = [stat.negclusters.prob];
                                stat_scores(jindex + 1).Negative_Cluster = tempvar(cluster);
                                stat_scores(jindex + 1).Negative_Cluster_Electrode = {elec.electrode};
                                stat_scores(jindex + 1).Negative_Electrode_T = {elec.t_value};
                                stat_scores(jindex + 1).Negative_Electrode_Time = {elec.time};
                                stat_scores(jindex + 1).Negative_Effect_size = effect_size;
                                stat_scores(jindex + 1).Negative_Cohens_D = cohens_d;
                            catch E
                                stat_scores(jindex + 1).Negative_Cluster = 'N/A';
                                stat_scores(jindex + 1).Negative_Cluster_Electrode = 'N/A';
                                stat_scores(jindex + 1).Negative_Electrode_T = 'N/A';
                                stat_scores(jindex + 1).Negative_Electrode_Time = 'N/A';
                                stat_scores(jindex + 1).Negative_Effect_size = 'N/A';
                                stat_scores(jindex + 1).Negative_Cohens_D = 'N/A';
                            end

                        end

                    end

                    if spatial_roi && ~strcmp(factor{1}, 'none')
                        % finds spatial ROI
                        data1 = data1_pure;
                        data2 = data2_pure;
                        data3 = data3_pure;
                    end

                    %% Topomap plotter
                    if topograpic_map_plot

                        try
                            Negative_Cluster = stat.negclusters.prob;
                        catch
                            Negative_Cluster = 1;
                        end

                        try
                            Positive_Cluster = stat.posclusters.prob;
                        catch
                            Positive_Cluster = 1;
                        end

                        if Negative_Cluster <= 0.1
                            plot_topo_map(stat, start_time, end_time, "negative", factors, results_dir);
                        end

                        if Positive_Cluster <= 0.1
                            plot_topo_map(stat, start_time, end_time, "positive", factors, results_dir);
                        else
                            fprintf("Nothing significant to plot on a topographic map");
                        end

                    end

                    %% cluster volume over time plotter
                    if clust_volume

                        try
                            Negative_Cluster = stat.negclusters.prob;
                        catch
                            Negative_Cluster = 1;
                        end

                        try
                            Positive_Cluster = stat.posclusters.prob;
                        catch
                            Positive_Cluster = 1;
                        end

                        if Negative_Cluster <= 0.2
                            plot_cluster_vol(stat, factors, start_time, end_time, "negative", results_dir);
                        end

                        if Positive_Cluster <= 0.2
                            plot_cluster_vol(stat, factors, start_time, end_time, "positive", results_dir);
                        else
                            fprintf("No significant clusters to plot");
                        end

                    end

                    %% plot design matrix
                    if plot_designs
                        plot_design(design_matrix1, design_matrix2, design_matrix3, results_dir, factors);
                    end

                    %% plot 10x2 erp median split
                    if plot_partitions_erps

                        try
                            Negative_Cluster = stat.negclusters.prob;
                        catch
                            Negative_Cluster = 1;
                        end

                        try
                            Positive_Cluster = stat.posclusters.prob;
                        catch
                            Positive_Cluster = 1;
                        end

                        if Negative_Cluster <= 0.08
                            electrode = compute_best_electrode(stat, "negative");
                            plot_peak_electrode(stat, electrode, results_dir);

                            if contains(factors, "none")
                                plot_partitions_regressor(data1, data2, data3, electrode, design_matrix2, factors, results_dir, start_time, end_time, generate_ci);
                            else
                                plot_partitions_erp(data1, data2, data3, electrode, design_matrix2, factors, results_dir, start_time, end_time, generate_ci);
                            end

                        end

                        if Positive_Cluster <= 0.08
                            electrode = compute_best_electrode(stat, "positive");
                            plot_peak_electrode(stat, electrode, results_dir);

                            if contains(factors, "none")
                                plot_partitions_regressor(data1, data2, data3, electrode, design_matrix2, factors, results_dir, start_time, end_time, generate_ci);
                            else
                                plot_partitions_erp(data1, data2, data3, electrode, design_matrix2, factors, results_dir, start_time, end_time, generate_ci);
                            end

                        else
                            fprintf("No significant clusters to plot");
                        end

                    end

                    %% Standard erp plots
                    if plot_erps && contains(factor, "none")

                        Negative_Cluster = stat.negclusters.prob;
                        Positive_Cluster = stat.posclusters.prob;

                        if Negative_Cluster <= 0.2
                            significant_electrode = compute_best_electrode(stat, "negative");
                            plot_peak_electrode(stat, significant_electrode, results_dir);
                            generate_erp_plot(results_dir, start_time, end_time, data, significant_electrode, factors, generate_ci, "negative");
                            generate_erp_pgi(results_dir, start_time, end_time, data, significant_electrode, factors, generate_ci, "negative")
                        end

                        if Positive_Cluster <= 0.2
                            significant_electrode = compute_best_electrode(stat, "positive");
                            plot_peak_electrode(stat, significant_electrode, results_dir);
                            generate_erp_plot(results_dir, start_time, end_time, data, significant_electrode, factors, generate_ci, "positive");
                            generate_erp_pgi(results_dir, start_time, end_time, data, significant_electrode, factors, generate_ci, "positive")
                        else
                            fprintf("No significant clusters to plot");
                        end

                    end

                end

            end

        end

        if contains(factor, "visual")
            results_fact = "visual-stress";
        elseif contains(factor, "headache")
            results_fact = "headache";
        elseif contains(factor, "discomfort")
            results_fact = "discomfort";
        else
            results_fact = "none";
        end

        savedir = strcat(results_dir, "/", "stat_results", "/", onsets_part, "_", factor, "_", string(start_time), "_", string(end_time), "_Stat_Results.xls");
        tab = struct2table(stat_scores)
        writetable(tab, savedir);

    elseif strcmp(onsets_part, "partitions-vs-onsets")
        %for every time windows
        for index = 1:size(time, 1)

            % gets the time window, either selected by the roi finder or
            start_time = time(index, 1);
            end_time = time(index, 2);
            % for every factor score
            for factor = factor_scores

                for effect = type_of_effect
                    % Loads Averaged data (1 timeseries per conditon per patricipant)
                    if strcmp(time_freq, 'time')

                        if strcmp(onsets_part, 'partitions')
                            [datas, orders] = load_data(main_path, grand_avg_partitions_filename, n_participants, onsets_part);
                        else
                            [datas, orders] = load_data(main_path, grand_avg_partitions_filename, n_participants, onsets_part);
                        end

                    else

                        if strcmp(onsets_part, 'partitions')
                            filename_precomposed = strcat(results_dir, "/", onsets_part, "/decomposed_dat.mat");

                            if ~exist(filename_precomposed, 'file')
                                [datas, orders] = load_data(main_path, single_trial_freq_partitions_filename, n_participants, onsets_part);

                                [datas, orders] = freq_decopmosition(datas, orders, wavelet_width, filename_precomposed);

                            else
                                data = load(filename_precomposed).decomposed;
                                datas = data.data;
                                orders = data.order;
                                data = []; % clearing memory for this var
                            end

                        else
                            [datas, orders] = load_data(main_path, single_trial_filename, n_participants, onsets_part);
                        end

                    end

                    % sets up the factor for partitions
                    factors = strcat(three_way_type,'-',factor, '-', onsets_part, '-', orthoganilized_partitions, '-', effect);
                    % gets the design matrix
                    [design_matrix, data] = get_design_matrix(factors, datas, orders);
                    % splitting the data to seperate vars
                    data1 = data.one;
                    data2 = data.two;
                    data3 = data.three;

                    if sum(baseline_period == [2.8 3.0]) < 2
                        data1 = rebaseline_data(data1, baseline_period);
                        data2 = rebaseline_data(data2, baseline_period);
                        data3 = rebaseline_data(data3, baseline_period);
                    end

                    % ROI
                    if spatial_roi && ~strcmp(factor{1}, 'none')
                        % finds spatial ROI

                        data1_pure = data1;
                        data2_pure = data2;
                        data3_pure = data3;

                        data1 = roi_mask(data1, orders, start_time, end_time, results_dir, time_freq, frequency_range, posneg, main_path, grand_avg_filename, n_participants, onsets_part);
                        data2 = roi_mask(data2, orders, start_time, end_time, results_dir, time_freq, frequency_range, posneg, main_path, grand_avg_filename, n_participants, onsets_part);
                        data3 = roi_mask(data3, orders, start_time, end_time, results_dir, time_freq, frequency_range, posneg, main_path, grand_avg_filename, n_participants, onsets_part);
                    end

                    % splitting the design matricies
                    design_matrix1 = design_matrix.one;
                    design_matrix2 = design_matrix.two;
                    design_matrix3 = design_matrix.three;
                    % combining each for the stat tests
                    data = [data1, data2, data3];
                    design_matrix = [design_matrix1, design_matrix2, design_matrix3];
                    % only runs the stat if specified
                    if clust_volume || topograpic_map_plot || stat_run || plot_erps
                        stat = stat_test(data, factors, start_time, end_time, design_matrix, time_freq, frequency_range, testing);
                        % adding stat result to the list
                        for cluster = 1:3
                            % adding stat result to the list
                            stat_name = strcat(factor, " ", string(start_time), "-", string(end_time), " Cluster: ", string(cluster));
                            [~, jindex] = size(stat_scores);
                            stat_scores(jindex + 1).Factor_Name = stat_name;

                            try
                                elec = compute_best_electrode(stat, "positive", cluster);

                                cohens_d = round((2 * elec.t_value) / sqrt(stat.df), 2);
                                effect_size = round(sqrt((elec.t_value * elec.t_value) / ((elec.t_value * elec.t_value) + stat.df)), 2);

                                tempvar = [stat.posclusters.prob];
                                stat_scores(jindex + 1).Positive_Cluster = tempvar(cluster);
                                stat_scores(jindex + 1).Positive_Cluster_Electrode = {elec.electrode};
                                stat_scores(jindex + 1).Positive_Electrode_T = {elec.t_value};
                                stat_scores(jindex + 1).Positive_Electrode_Time = {elec.time};
                                stat_scores(jindex + 1).Positive_Effect_size = effect_size;
                                stat_scores(jindex + 1).Positive_Cohens_D = cohens_d;
                            catch E
                                stat_scores(jindex + 1).Positive_Cluster = 'N/A';
                                stat_scores(jindex + 1).Positive_Cluster_Electrode = 'N/A';
                                stat_scores(jindex + 1).Positive_Electrode_T = 'N/A';
                                stat_scores(jindex + 1).Positive_Electrode_Time = 'N/A';
                                stat_scores(jindex + 1).Positive_Effect_size = 'N/A';
                                stat_scores(jindex + 1).Positive_Cohens_D = 'N/A';
                            end

                            try
                                elec = compute_best_electrode(stat, "negative", cluster);

                                cohens_d = round((2 * elec.t_value) / sqrt(stat.df), 2);
                                effect_size = round(sqrt((elec.t_value * elec.t_value) / ((elec.t_value * elec.t_value) + stat.df)), 2);

                                tempvar = [stat.negclusters.prob];
                                stat_scores(jindex + 1).Negative_Cluster = tempvar(cluster);
                                stat_scores(jindex + 1).Negative_Cluster_Electrode = {elec.electrode};
                                stat_scores(jindex + 1).Negative_Electrode_T = {elec.t_value};
                                stat_scores(jindex + 1).Negative_Electrode_Time = {elec.time};
                                stat_scores(jindex + 1).Negative_Effect_size = effect_size;
                                stat_scores(jindex + 1).Negative_Cohens_D = cohens_d;
                            catch E
                                stat_scores(jindex + 1).Negative_Cluster = 'N/A';
                                stat_scores(jindex + 1).Negative_Cluster_Electrode = 'N/A';
                                stat_scores(jindex + 1).Negative_Electrode_T = 'N/A';
                                stat_scores(jindex + 1).Negative_Electrode_Time = 'N/A';
                                stat_scores(jindex + 1).Negative_Effect_size = 'N/A';
                                stat_scores(jindex + 1).Negative_Cohens_D = 'N/A';
                            end

                        end

                    end

                    if spatial_roi && ~strcmp(factor{1}, 'none')
                        % finds spatial ROI
                        data1 = data1_pure;
                        data2 = data2_pure;
                        data3 = data3_pure;
                    end

                    %% Topomap plotter
                    if topograpic_map_plot

                        try
                            Negative_Cluster = stat.negclusters.prob;
                        catch
                            Negative_Cluster = 1;
                        end

                        try
                            Positive_Cluster = stat.posclusters.prob;
                        catch
                            Positive_Cluster = 1;
                        end

                        if Negative_Cluster <= 0.1
                            plot_topo_map(stat, start_time, end_time, "negative", factors, results_dir);
                        end

                        if Positive_Cluster <= 0.1
                            plot_topo_map(stat, start_time, end_time, "positive", factors, results_dir);
                        else
                            fprintf("Nothing significant to plot on a topographic map");
                        end

                    end

                    %% cluster volume over time plotter
                    if clust_volume

                        try
                            Negative_Cluster = stat.negclusters.prob;
                        catch
                            Negative_Cluster = 1;
                        end

                        try
                            Positive_Cluster = stat.posclusters.prob;
                        catch
                            Positive_Cluster = 1;
                        end

                        if Negative_Cluster <= 0.2
                            plot_cluster_vol(stat, factors, start_time, end_time, "negative", results_dir);
                        end

                        if Positive_Cluster <= 0.2
                            plot_cluster_vol(stat, factors, start_time, end_time, "positive", results_dir);
                        else
                            fprintf("No significant clusters to plot");
                        end

                    end

                    %% plot design matrix
                    if plot_designs
                        plot_design(design_matrix1, design_matrix2, design_matrix3, results_dir, factors);
                    end

                    %% plot 10x2 erp median split
                    if plot_partitions_erps

                        try
                            Negative_Cluster = stat.negclusters.prob;
                        catch
                            Negative_Cluster = 1;
                        end

                        try
                            Positive_Cluster = stat.posclusters.prob;
                        catch
                            Positive_Cluster = 1;
                        end

                        if Negative_Cluster <= 0.08
                            electrode = compute_best_electrode(stat, "negative");
                            plot_peak_electrode(stat, electrode, results_dir);

                            if contains(factors, "none")
                                plot_partitions_regressor(data1, data2, data3, electrode, design_matrix2, factors, results_dir, start_time, end_time, generate_ci);
                            else
                                plot_partitions_erp(data1, data2, data3, electrode, design_matrix2, factors, results_dir, start_time, end_time, generate_ci);
                            end

                        end

                        if Positive_Cluster <= 0.08
                            electrode = compute_best_electrode(stat, "positive");
                            plot_peak_electrode(stat, electrode, results_dir);

                            if contains(factors, "none")
                                plot_partitions_regressor(data1, data2, data3, electrode, design_matrix2, factors, results_dir, start_time, end_time, generate_ci);
                            else
                                plot_partitions_erp(data1, data2, data3, electrode, design_matrix2, factors, results_dir, start_time, end_time, generate_ci);
                            end

                        else
                            fprintf("No significant clusters to plot");
                        end

                    end

                    %% Standard erp plots
                    if plot_erps && contains(factor, "none")

                        Negative_Cluster = stat.negclusters.prob;
                        Positive_Cluster = stat.posclusters.prob;

                        if Negative_Cluster <= 0.2
                            significant_electrode = compute_best_electrode(stat, "negative");
                            plot_peak_electrode(stat, significant_electrode, results_dir);
                            generate_erp_plot(results_dir, start_time, end_time, data, significant_electrode, factors, generate_ci, "negative");
                            generate_erp_pgi(results_dir, start_time, end_time, data, significant_electrode, factors, generate_ci, "negative")
                        end

                        if Positive_Cluster <= 0.2
                            significant_electrode = compute_best_electrode(stat, "positive");
                            plot_peak_electrode(stat, significant_electrode, results_dir);
                            generate_erp_plot(results_dir, start_time, end_time, data, significant_electrode, factors, generate_ci, "positive");
                            generate_erp_pgi(results_dir, start_time, end_time, data, significant_electrode, factors, generate_ci, "positive")
                        else
                            fprintf("No significant clusters to plot");
                        end

                    end

                end

            end

        end

        if contains(factor, "visual")
            results_fact = "visual-stress";
        elseif contains(factor, "headache")
            results_fact = "headache";
        elseif contains(factor, "discomfort")
            results_fact = "discomfort";
        else
            results_fact = "none";
        end

        savedir = strcat(results_dir, "/", "stat_results", "/", onsets_part, "_", factor, "_", string(start_time), "_", string(end_time), "_Stat_Results.xls");
        tab = struct2table(stat_scores)
        writetable(tab, savedir);

    elseif strcmp(onsets_part, 'eyes')
        %for every time windows
        for index = 1:size(time, 1)

            % gets the time window, either selected by the roi finder or
            start_time = time(index, 1);
            end_time = time(index, 2);
            % for every factor score
            for factor = factor_scores

                for effect = type_of_effect
                    % Loads Averaged data (1 timeseries per conditon per patricipant)
                    grand_avg_eyes = 'time_domain_eye_confound_onsets_2_3_4_5_6_7_8_grand-average.mat';
                    [datas, orders] = load_data(main_path, grand_avg_eyes, n_participants, onsets_part);
                    datas = apply_dummy_coordinates_to_eye_electrodes(datas);
                    % gets the design matrix
                    [design_matrix, data] = get_design_matrix(factor, datas, orders);
                    % splitting the data to seperate vars
                    [thin, med, thick] = split_data(data);
                    % only runs the stat if specified
                    if clust_volume || topograpic_map_plot || stat_run || plot_erps
                        stat_REOG = stat_test(data, factor, start_time, end_time, design_matrix, time_freq, frequency_range, testing);
                        stat_HEOGVEOG = stat_test(med, factor, start_time, end_time, design_matrix, time_freq, frequency_range, testing);
                        stat_HEOG = stat_test(thin, factor, start_time, end_time, design_matrix, time_freq, frequency_range, testing);
                        stat_VEOG = stat_test(thick, factor, start_time, end_time, design_matrix, time_freq, frequency_range, testing);

                        stats = {stat_REOG, stat_HEOG, stat_VEOG, stat_HEOGVEOG};
                        stat_names = ["REOG", "HEOG", "VEOG", "HEOG + VEOG"];

                        for i = 1:length(stats)
                            stat = stats{i};
                            % adding stat result to the list
                            stat_name = strcat(factor, " ", string(start_time), "-", string(end_time), " ", stat_names(i));
                            [~, jindex] = size(stat_scores);
                            stat_scores(jindex + 1).Factor_Name = stat_name;

                            try
                                elec = compute_best_electrode(stat, "positive");

                                cohens_d = round((2 * elec.t_value) / sqrt(stat.df), 2);
                                effect_size = round(sqrt((elec.t_value * elec.t_value) / ((elec.t_value * elec.t_value) + stat.df)), 2);

                                stat_scores(jindex + 1).Positive_Cluster = stat.posclusters.prob;
                                stat_scores(jindex + 1).Positive_Cluster_Electrode = elec.electrode;
                                stat_scores(jindex + 1).Positive_Electrode_T = elec.t_value;
                                stat_scores(jindex + 1).Positive_Electrode_Time = elec.time;

                                stat_scores(jindex + 1).Positive_Effect_size = effect_size;
                            catch E
                                stat_scores(jindex + 1).Positive_Cluster = 'N/A';
                                stat_scores(jindex + 1).Positive_Cluster_Electrode = 'N/A';
                                stat_scores(jindex + 1).Positive_Electrode_T = 'N/A';
                                stat_scores(jindex + 1).Positive_Electrode_Time = 'N/A';

                                stat_scores(jindex + 1).Positive_Effect_size = 'N/A';
                            end

                            try
                                elec = compute_best_electrode(stat, "negative");

                                cohens_d = round((2 * elec.t_value) / sqrt(stat.df), 2);
                                effect_size = round(sqrt((elec.t_value * elec.t_value) / ((elec.t_value * elec.t_value) + stat.df)), 2);

                                stat_scores(jindex + 1).Negative_Cluster = stat.negclusters.prob;
                                stat_scores(jindex + 1).Negative_Cluster_Electrode = elec.electrode;
                                stat_scores(jindex + 1).Negative_Electrode_T = elec.t_value;
                                stat_scores(jindex + 1).Negative_Electrode_Time = elec.time;

                                stat_scores(jindex + 1).Negative_Effect_size = effect_size;
                            catch E
                                stat_scores(jindex + 1).Negative_Cluster = 'N/A';
                                stat_scores(jindex + 1).Negative_Cluster_Electrode = 'N/A';
                                stat_scores(jindex + 1).Negative_Electrode_T = 'N/A';
                                stat_scores(jindex + 1).Negative_Electrode_Time = 'N/A';

                                stat_scores(jindex + 1).Negative_Effect_size = 'N/A';
                            end

                            %% cluster volume over time plotter
                            if clust_volume
                                Negative_Cluster = stat.negclusters.prob;
                                Positive_Cluster = stat.posclusters.prob;

                                if Negative_Cluster <= 0.2
                                    plot_cluster_vol(stat, factors, start_time, end_time, "negative", results_dir);
                                end

                                if Positive_Cluster <= 0.2
                                    plot_cluster_vol(stat, factors, start_time, end_time, "positive", results_dir);
                                else
                                    fprintf("No significant clusters to plot");
                                end

                            end

                            %% Standard erp plots
                            if plot_erps %&& contains(factor,"none")

                                try
                                    Negative_Cluster = stat.negclusters.prob;
                                catch
                                    Negative_Cluster = 1;
                                end

                                try
                                    Positive_Cluster = stat.posclusters.prob;
                                catch
                                    Positive_Cluster = 1;
                                end

                                if Negative_Cluster <= 0.2
                                    significant_electrode = compute_best_electrode(stat, "negative");
                                    generate_erp_plot(results_dir, 2.8, 3.9, data, significant_electrode, factor, generate_ci, "negative");
                                    hold on;
                                    legend("HEOG", "REOG", "VEOG", "", "", "", 'location', 'northwest');
                                    tit = strcat("Eye confounds in the offset: HEOG, REOG, VEOG");
                                    title(tit);
                                end

                                if Positive_Cluster <= 0.2
                                    significant_electrode = compute_best_electrode(stat, "positive");
                                    generate_erp_plot(results_dir, 2.8, 3.9, data, significant_electrode, factor, generate_ci, "positive");
                                    hold on;
                                    legend("HEOG", "REOG", "VEOG", "", "", "", 'location', 'northwest');
                                    tit = strcat("Eye confounds in the offset: HEOG, REOG, VEOG");
                                    title(tit);
                                else
                                    fprintf("No significant clusters to plot");
                                end

                            end

                        end

                    end

                end

            end

        end

        savedir = strcat(results_dir, "/", "stat_results", "/", "Eye_Stat_Results.xls");
        tab = struct2table(stat_scores)
        writetable(tab, savedir);
    end

end
