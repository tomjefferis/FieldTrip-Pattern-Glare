function tab = pgi_analysis(grand_avg_filename, single_trial_filename, grand_avg_partitions_filename, single_trial_freq_partitions_filename, time_window, n_participants, baseline_period, ...
        aggregated_roi, max_windows, spatial_roi, posneg, stat_run, wavelet_width, frequency_range, decimate, power_itc, tfr_plots, clust_volume, topograpic_map_plot, ...
        plot_erps, median_split_plots, gfp_plot, plot_designs, plot_partitions_erps, generate_ci, time_freq, factor_scores, ...
        onsets_part, type_of_effect, three_way_type, orthoganilized_partitions, testing, paper_figs)

    %% Experiment setup
    [results_dir, main_path] = getFolderPath();
    % If the factors are all then it sets all the factors
    if strcmp(factor_scores{1}, 'all') && ~contains(orthoganilized_partitions, 'orthog')
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
            % do if baseline isnt [2.8 3.0] and time data
            if (sum(baseline_period == [2.8 3.0]) < 2)
                datas = rebaseline_data(datas, baseline_period);
            end
        elseif strcmp(time_freq, 'time') && strcmp(onsets_part, 'partition1')
            [datas, orders] = load_data(main_path, grand_avg_partitions_filename, n_participants, onsets_part);
            % do if baseline isnt [2.8 3.0] and time data
            if (sum(baseline_period == [2.8 3.0]) < 2)
                datas = rebaseline_data(datas, baseline_period);
            end
        else

            filename_precomposed = strcat(results_dir, "/", onsets_part, "/", string(wavelet_width), "-cyc-", power_itc, "-", string(frequency_range(1)), "-", string(frequency_range(2)), "-", string(time_window(1)), "-", string(time_window(2)), "-", onsets_part, "-", "decomposed_dat.mat");

            if ~exist(filename_precomposed, 'file')
                disp("Decomposed File Not Found");
                [datas, orders] = load_data(main_path, single_trial_filename, n_participants, onsets_part);
                % do if baseline isnt [2.8 3.0] and time data
                [datas] = freq_power_decopmosition(datas, wavelet_width, decimate, filename_precomposed, time_window, frequency_range, baseline_period);
                decomposed.data = datas;
                decomposed.order = orders;
                save(filename_precomposed, "decomposed", '-v7.3');
            else
                disp("Loaded Decomposed File");
                data = load(filename_precomposed).decomposed;
                datas = data.data;
                orders = data.order;
                data = []; % clearing memory for this var
            end

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
                if clust_volume || topograpic_map_plot || stat_run || plot_erps || paper_figs
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
                        [~] = plot_topo_map(stat, start_time, end_time, "negative", factor, results_dir, false);
                    end

                    if Positive_Cluster <= 0.2
                        [~] = plot_topo_map(stat, start_time, end_time, "positive", factor, results_dir, false);
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
                        [~] = plot_cluster_vol(stat, factor, start_time, end_time, "negative", results_dir, false);
                    end

                    if Positive_Cluster <= 0.2
                        [~] = plot_cluster_vol(stat, factor, start_time, end_time, "positive", results_dir, false);
                    else
                        fprintf("No significant clusters to plot");
                    end

                end

                %% TFR plots
                if tfr_plots && contains(power_itc, "pow") && ~contains(time_freq, "time")

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
                        tfr_plotter(datas, significant_electrode, factor, results_dir, "Negative", true);
                    end

                    if Positive_Cluster <= 0.2
                        significant_electrode = compute_best_electrode(stat, "positive");
                        tfr_plotter(datas, significant_electrode, factor, results_dir, "Positive", true);
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
                        [~] = plot_peak_electrode(stat, significant_electrode, results_dir, false);
                        clf;
                        [~] = generate_erp_plot(results_dir, start_time, end_time, data, significant_electrode, factor, generate_ci, "negative", false);
                        clf;
                        [~] = generate_erp_pgi(results_dir, start_time, end_time, data, significant_electrode, factor, generate_ci, "negative", false);
                    end

                    if Positive_Cluster <= 0.2
                        significant_electrode = compute_best_electrode(stat, "positive");
                        [~] = plot_peak_electrode(stat, significant_electrode, results_dir, false);
                        clf;
                        [~] = generate_erp_plot(results_dir, start_time, end_time, data, significant_electrode, factor, generate_ci, "positive", false);
                        clf;
                        [~] = generate_erp_pgi(results_dir, start_time, end_time, data, significant_electrode, factor, generate_ci, "positive", false);
                    else
                        fprintf("No significant clusters to plot");
                    end

                end

                %% Median split
                if median_split_plots && ~contains(factor, "none")

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

                    [low, high] = median_split(data, 1, design_matrix);

                    if Negative_Cluster <= 0.2
                        significant_electrode = compute_best_electrode(stat, "negative");
                        [~] = plot_peak_electrode(stat, significant_electrode, results_dir, false);
                        clf;

                        if contains(time_freq, "time")
                            [~] = plot_medium_split(high, low, significant_electrode, factor, start_time, end_time, generate_ci, results_dir,paper_figs)
                        else
                            freq_power_median_split(data, orders, design_matrix, significant_electrode, frequency_range, [start_time end_time], factor, results_dir)
                        end

                    end

                    if Positive_Cluster <= 0.2
                        significant_electrode = compute_best_electrode(stat, "positive");
                        [~] = plot_peak_electrode(stat, significant_electrode, results_dir, false);
                        clf;

                        if contains(time_freq, "time")
                            [~] = plot_medium_split(high, low, significant_electrode, factor, start_time, end_time, generate_ci, results_dir,paper_figs)
                        else
                            freq_power_median_split(data, orders, design_matrix, significant_electrode, frequency_range, [start_time end_time], factor, results_dir)
                        end

                    else
                        fprintf("No significant clusters to plot");
                    end

                end

                if paper_figs
                    if strcmp(time_freq,'time')
                            frequency_range = 'time';
                    end

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

                    if Negative_Cluster <= 0.1 && Positive_Cluster <= 0.1
                        stat1 = stat;
                        stat1.negclusters(1).prob = 1;
                        paper_figures(data, stat1, design_matrix, onsets_part, factor, start_time, end_time, generate_ci, results_dir,frequency_range);
                        stat1 = stat;
                        stat1.posclusters(1).prob = 1;
                        paper_figures(data, stat1, design_matrix, onsets_part, factor, start_time, end_time, generate_ci, results_dir,frequency_range);
                    
                    elseif Negative_Cluster <= 0.1 || Positive_Cluster <= 0.1
                        paper_figures(data, stat, design_matrix, onsets_part, factor, start_time, end_time, generate_ci, results_dir,frequency_range);
                    end

                end

            end

        end

        if contains(time_freq, "time")
            savedir = strcat(results_dir, "/", "stat_results", "/", onsets_part, "_", factor, "_", string(start_time), "_", string(end_time), "_", string(orthoganilized_partitions), "_Onsets_Stat_Results.xls");
        else
            savedir = strcat(results_dir, "/", "stat_results", "/", string(wavelet_width), "-cyc-", power_itc, "-", string(frequency_range(1)), "-", string(frequency_range(2)), onsets_part, "_", factor, "_", string(start_time), "_", string(end_time), "_", string(orthoganilized_partitions), "_Onsets_Stat_Results.xls");
        end

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
                        filename_precomposed = strcat(results_dir, "/", onsets_part, "/", string(wavelet_width), "-cyc-", power_itc, "-", string(frequency_range(1)), "-", string(frequency_range(2)), "-", string(time_window(1)), "-", string(time_window(2)), "-", onsets_part, "-", "decomposed_dat.mat");

                        if strcmp(onsets_part, 'partitions')

                            if ~exist(filename_precomposed, 'file')
                                disp("Decomposed File Not Found");
                                [datas, orders] = load_data(main_path, single_trial_freq_partitions_filename, n_participants, onsets_part);
                                [datas] = freq_power_decopmosition(datas, wavelet_width, decimate, filename_precomposed, time_window, frequency_range, baseline_period);
                                decomposed.data = datas;
                                decomposed.order = orders;
                                save(filename_precomposed, "decomposed", '-v7.3');
                            else
                                disp("Loaded Decomposed File");
                                data = load(filename_precomposed).decomposed;
                                datas = data.data;
                                orders = data.order;
                                data = []; % clearing memory for this var
                            end

                        else

                            if ~exist(filename_precomposed, 'file')
                                disp("Decomposed File Not Found");
                                [datas, orders] = load_data(main_path, single_trial_filename, n_participants, onsets_part);
                                [datas] = freq_power_decopmosition(datas, wavelet_width, decimate, filename_precomposed, time_window, frequency_range, baseline_period);
                                decomposed.data = datas;
                                decomposed.order = orders;
                                save(filename_precomposed, "decomposed", '-v7.3');
                            else
                                disp("Loaded Decomposed File");
                                data = load(filename_precomposed).decomposed;
                                datas = data.data;
                                orders = data.order;
                                data = []; % clearing memory for this var
                            end

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

                    if (sum(baseline_period == [2.8 3.0]) < 2) && strcmp(time_freq, 'time')
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
                            [~] = plot_topo_map(stat, start_time, end_time, "negative", factors, results_dir, false);
                        end

                        if Positive_Cluster <= 0.1
                            [~] = plot_topo_map(stat, start_time, end_time, "positive", factors, results_dir, false);
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
                            [~] = plot_cluster_vol(stat, factors, start_time, end_time, "negative", results_dir, false);
                        end

                        if Positive_Cluster <= 0.2
                            [~] = plot_cluster_vol(stat, factors, start_time, end_time, "positive", results_dir, false);
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
                            [~] = plot_peak_electrode(stat, electrode, results_dir, false);

                            if contains(factors, "none")
                                [~] = plot_partitions_regressor(data1, data2, data3, electrode, design_matrix2, factors, results_dir, start_time, end_time, generate_ci, false);
                            else

                                if contains(time_freq, "time")
                                    [~] = plot_partitions_erp(data1, data2, data3, electrode, design_matrix2, factors, results_dir, start_time, end_time, generate_ci, false);
                                else
                                    plot_partitions_freq_power(data1, data2, data3, electrode, design_matrix2, factors, results_dir, start_time, end_time)
                                end

                            end

                        end

                        if Positive_Cluster <= 0.08
                            electrode = compute_best_electrode(stat, "positive");
                            [~] = plot_peak_electrode(stat, electrode, results_dir, false);

                            if contains(factors, "none")
                                [~] = plot_partitions_regressor(data1, data2, data3, electrode, design_matrix2, factors, results_dir, start_time, end_time, generate_ci, false);
                            else

                                if contains(time_freq, "time")
                                    [~] = plot_partitions_erp(data1, data2, data3, electrode, design_matrix2, factors, results_dir, start_time, end_time, generate_ci, false);
                                else
                                    plot_partitions_freq_power(data1, data2, data3, electrode, design_matrix2, factors, results_dir, start_time, end_time)
                                end

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
                            [~] = plot_peak_electrode(stat, significant_electrode, results_dir, false);
                            [~] = generate_erp_plot(results_dir, start_time, end_time, data, significant_electrode, factors, generate_ci, "negative", false);
                            [~] = generate_erp_pgi(results_dir, start_time, end_time, data, significant_electrode, factors, generate_ci, "negative", false)
                        end

                        if Positive_Cluster <= 0.2
                            significant_electrode = compute_best_electrode(stat, "positive");
                            [~] = plot_peak_electrode(stat, significant_electrode, results_dir, false);
                            [~] = generate_erp_plot(results_dir, start_time, end_time, data, significant_electrode, factors, generate_ci, "positive", false);
                            [~] = generate_erp_pgi(results_dir, start_time, end_time, data, significant_electrode, factors, generate_ci, "positive", false)
                        else
                            fprintf("No significant clusters to plot");
                        end

                    end

                    if paper_figs
                    if strcmp(time_freq,'time')
                            frequency_range = 'time';
                    end

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

                    if Negative_Cluster <= 0.1 && Positive_Cluster <= 0.1
                        stat1 = stat;
                        stat1.negclusters(1).prob = 1;
                        paper_figures(data, stat1, design_matrix, onsets_part, factors, start_time, end_time, generate_ci, results_dir,frequency_range);
                        stat1 = stat;
                        stat1.posclusters(1).prob = 1;
                        paper_figures(data, stat1, design_matrix, onsets_part, factors, start_time, end_time, generate_ci, results_dir,frequency_range);
                    
                    elseif Negative_Cluster <= 0.1 || Positive_Cluster <= 0.1
                        paper_figures(data, stat, design_matrix, onsets_part, factors, start_time, end_time, generate_ci, results_dir,frequency_range);
                    end

                end

                end

            end

        end

        if contains(time_freq, "time")
            savedir = strcat(results_dir, "/", "stat_results", "/", onsets_part, "_", factor, "_", string(start_time), "_", string(end_time), "_", string(orthoganilized_partitions), "_Onsets_Stat_Results.xls");
        else
            savedir = strcat(results_dir, "/", "stat_results", "/", string(wavelet_width), "-cyc-", power_itc, "-", string(frequency_range(1)), "-", string(frequency_range(2)), onsets_part, "_", factor, "_", string(start_time), "_", string(end_time), "_", string(orthoganilized_partitions), "_Onsets_Stat_Results.xls");
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

        if contains(time_freq, "time")
            savedir = strcat(results_dir, "/", "stat_results", "/", onsets_part, "_", factor, "_", string(start_time), "_", string(end_time), "_", string(orthoganilized_partitions), type_of_effect, "_Stat_Results.xls");
        else
            savedir = strcat(results_dir, "/", "stat_results", "/", string(wavelet_width), "-cyc-", power_itc, "-", string(frequency_range(1)), "-", string(frequency_range(2)), type_of_effect, onsets_part, "_", factor, "_", string(start_time), "_", string(end_time), "_", string(orthoganilized_partitions), "_Stat_Results.xls");
        end

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

                        
                            filename_precomposed = strcat(results_dir, "/",string(wavelet_width), "-cyc-", power_itc, "-", string(frequency_range(1)), "-", string(frequency_range(2)), "-", string(time_window(1)), "-", string(time_window(2)), onsets_part, "-decomposed_dat.mat");

                            if ~exist(filename_precomposed, 'file')
                                disp("Decomposed File Not Found");
                                [datas, orders] = load_data(main_path, single_trial_freq_partitions_filename, n_participants, onsets_part);
                                [datas1] = freq_power_decopmosition(datas.part1, wavelet_width, decimate, filename_precomposed, time_window, frequency_range, baseline_period);
                                [datas2] = freq_power_decopmosition(datas.part2, wavelet_width, decimate, filename_precomposed, time_window, frequency_range, baseline_period);
                                [datas3] = freq_power_decopmosition(datas.part3, wavelet_width, decimate, filename_precomposed, time_window, frequency_range, baseline_period);
                                datas.part1 = datas1;
                                datas.part2 = datas2;
                                datas.part3 = datas3;
                                decomposed.data = datas;
                                decomposed.order = orders;
                                save(filename_precomposed, "decomposed", '-v7.3');
                            else
                               disp("Loaded Decomposed File");
                                data = load(filename_precomposed).decomposed;
                                datas = data.data;
                                orders = data.order;
                                data = []; % clearing memory for this var
                            end

                        

                    end

                    % sets up the factor for partitions
                    factors = strcat(three_way_type, '-', factor, '-', onsets_part, '-', orthoganilized_partitions, '-', effect);
                    % gets the design matrix
                    [design_matrix, data] = get_design_matrix(factors, datas, orders);
                    % splitting the data to seperate vars
                    data1 = data.one;
                    data2 = data.two;
                    data3 = data.three;

                    if sum(baseline_period == [2.8 3.0]) < 2 && strcmp(time_freq, 'time')
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
                            [~] = plot_topo_map(stat, start_time, end_time, "negative", factors, results_dir, false);
                        end

                        if Positive_Cluster <= 0.1
                            [~] = plot_topo_map(stat, start_time, end_time, "positive", factors, results_dir, false);
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
                            [~] = plot_cluster_vol(stat, factors, start_time, end_time, "negative", results_dir, false);
                        end

                        if Positive_Cluster <= 0.2
                            [~] = plot_cluster_vol(stat, factors, start_time, end_time, "positive", results_dir, false);
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
                            [~] = plot_peak_electrode(stat, electrode, results_dir, false);

                            [~] = plot_three_way(data1, data2, data3, electrode, design_matrix2, factor, results_dir, start_time, end_time, generate_ci, paper_figs)

                        end

                        if Positive_Cluster <= 0.08
                            electrode = compute_best_electrode(stat, "positive");
                            [~] = plot_peak_electrode(stat, electrode, results_dir, false);

                            [~] = plot_three_way(data1, data2, data3, electrode, design_matrix2, factor, results_dir, start_time, end_time, generate_ci, paper_figs)

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
                            [~] = plot_peak_electrode(stat, significant_electrode, results_dir, false);
                            [~] = generate_erp_plot(results_dir, start_time, end_time, data, significant_electrode, factors, generate_ci, "negative", false);
                            [~] = generate_erp_pgi(results_dir, start_time, end_time, data, significant_electrode, factors, generate_ci, "negative", false);
                        end

                        if Positive_Cluster <= 0.2
                            significant_electrode = compute_best_electrode(stat, "positive");
                            [~] = plot_peak_electrode(stat, significant_electrode, results_dir, false);
                            [~] = generate_erp_plot(results_dir, start_time, end_time, data, significant_electrode, factors, generate_ci, "positive", false);
                            [~] = generate_erp_pgi(results_dir, start_time, end_time, data, significant_electrode, factors, generate_ci, "positive", false);
                        else
                            fprintf("No significant clusters to plot");
                        end

                    end

                    if paper_figs

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

                       if Negative_Cluster <= 0.1 && Positive_Cluster <= 0.1
                        stat1 = stat;
                        stat1.negclusters(1).prob = 1;
                        paper_figures(data, stat1, design_matrix, onsets_part, factors, start_time, end_time, generate_ci, results_dir, time_freq)
                        stat1 = stat;
                        stat1.posclusters(1).prob = 1;
                        paper_figures(data, stat1, design_matrix, onsets_part, factors, start_time, end_time, generate_ci, results_dir, time_freq)
                    
                    elseif Negative_Cluster || 0.1 && Positive_Cluster <= 0.1
                        paper_figures(data, stat, design_matrix, onsets_part, factors, start_time, end_time, generate_ci, results_dir, time_freq);
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

        if contains(time_freq, "time")
            savedir = strcat(results_dir, "/", "stat_results", "/", onsets_part, "_", factor, "_", string(start_time), "_", string(end_time), "_", string(orthoganilized_partitions), "_Onsets_Stat_Results.xls");
        else
            savedir = strcat(results_dir, "/", "stat_results", "/", string(wavelet_width), "-cyc-", power_itc, "-", string(frequency_range(1)), "-", string(frequency_range(2)), onsets_part, "_", factor, "_", string(start_time), "_", string(end_time), "_", string(orthoganilized_partitions), "_Onsets_Stat_Results.xls");
        end

        if contains(time_freq, "time")
            savedir = strcat(results_dir, "/", "stat_results", "/", onsets_part, "_", factor, "_", string(start_time), "_", string(end_time), "_", string(orthoganilized_partitions), "_Stat_Results.xls");
        else
            savedir = strcat(results_dir, "/", "stat_results", "/", string(wavelet_width), "-cyc-", power_itc, "-", string(frequency_range(1)), "-", string(frequency_range(2)), onsets_part, "_", factor, "_", string(start_time), "_", string(end_time), "_", string(orthoganilized_partitions), "_Stat_Results.xls");
        end

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
                                    [~] = plot_cluster_vol(stat, factors, start_time, end_time, "negative", results_dir, false);
                                end

                                if Positive_Cluster <= 0.2
                                    [~] = plot_cluster_vol(stat, factors, start_time, end_time, "positive", results_dir, false);
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
                                    [~] = generate_erp_plot(results_dir, 2.8, 3.9, data, significant_electrode, factor, generate_ci, "negative", false);
                                    hold on;
                                    legend("HEOG", "REOG", "VEOG", "", "", "", 'location', 'northwest');
                                    tit = strcat("Eye confounds in the offset: HEOG, REOG, VEOG");
                                    title(tit);
                                end

                                if Positive_Cluster <= 0.2
                                    significant_electrode = compute_best_electrode(stat, "positive");
                                    [~] = generate_erp_plot(results_dir, 2.8, 3.9, data, significant_electrode, factor, generate_ci, "positive", false);
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
