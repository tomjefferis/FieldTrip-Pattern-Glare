function tab = freq_analysis(single_trial_filename, time, n_participants, baseline_period, ...
        spatial_roi, posneg, stat_run, wavelet_width, frequency_range, clust_volume, topograpic_map_plot, ...
        median_split_plots, spect_plot, plot_designs, factor_scores, ...
        onsets_part, type_of_effect, testing)

    %% Experiment setup
    [results_dir, main_path] = getFolderPath();
    % If the factors are all then it sets all the factors
    if strcmp(factor_scores{1}, 'all')
        factor_scores = {'none', 'headache', 'visual-stress', 'discomfort'};
    end

    %setting folder path to output to time or freq folders
    results_dir = strcat(results_dir, "/", 'frequency');

    %% sets up stat return scores
    stat_scores = struct('Factor_Name', {}, 'Positive_Cluster', {}, 'Negative_Cluster', {});

    if strcmp(onsets_part, 'onsets') || strcmp(onsets_part, 'partition1')
        clf;

        filename_precomposed = strcat(string(wavelet_width), "-cyc-pow-",onsets_part ,"-decomposed_dat.mat");

        [datas,orders] = load_freq_decomp(main_path, single_trial_filename, filename_precomposed, n_participants, wavelet_width);

        %cfg = [];
        %grandavg = ft_freqgrandaverage(cfg, datas{:});

        %for every time windows
        for index = 1:size(time, 1)
            % gets the time window, either selected by the roi finder or
            start_time = time(index, 1);
            end_time = time(index, 2);
            % for every factor score
            for factor = factor_scores

            
                % gets the design matrix
                [design_matrix, data] = get_design_matrix(factor, datas, orders);

                % only runs the stat if spec
                if clust_volume || topograpic_map_plot || stat_run  
                    stat = stat_test(data, factor, start_time, end_time, design_matrix, "freq", frequency_range, testing);

                    % adding stat result to the list
                    stat_name = strcat(factor, " ", string(start_time), "-", string(end_time));
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


                %% Median split
                if median_split_plots && ~contains(factor, "none")
                    Negative_Cluster = stat.negclusters.prob;
                    Positive_Cluster = stat.posclusters.prob;

                    if Negative_Cluster <= 0.2
                        significant_electrode = compute_best_electrode(stat, "negative");
                        clf;
                        freq_power_median_split(data, orders, design_matrix, significant_electrode, frequency_range, [start_time end_time], factor, results_dir)
                    end

                    if Positive_Cluster <= 0.2
                        significant_electrode = compute_best_electrode(stat, "positive");
                        clf;
                        freq_power_median_split(data,orders, design_matrix, significant_electrode, frequency_range, [start_time end_time], factor, results_dir)
                    else
                        fprintf("No significant clusters to plot");
                    end

                end

            end

        end

        savedir = strcat(results_dir, "/", "stat_results", "/", "Onsets_Stat_Results.xls");
        tab = struct2table(stat_scores)
        writetable(tab, savedir);

    end

end
