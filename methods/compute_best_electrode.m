function [significant_electrode] = compute_best_electrode(stat, type, cluster)

    if ~exist('cluster','var')
        cluster = 1;
    end

    % if isfield(stat,"freq")
    %    t_values = stat.stat;
    %    t_values = squeeze(sum(t_values,2));
    % else
    %
    % end

    peak_level_stats = containers.Map;
    t_values = stat.stat;
    time = stat.time;
    electrodes = stat.label;

    % defines what clusters we are looking for
    if contains(type, 'positive')
        cluster_matrix_locations = stat.posclusterslabelmat;
    elseif contains(type, 'negative')
        cluster_matrix_locations = stat.negclusterslabelmat;
    end

    [rows, columns] = size(cluster_matrix_locations);

    for col = 1:columns

        for row = 1:rows

            t_value = t_values(row, col);
            t = time(col);
            electrode = electrodes{row};

            which_cluster = cluster_matrix_locations(row, col);

            if which_cluster == cluster
                keys = peak_level_stats.keys;

                if any(strcmp(keys, electrode))
                    previous_values = peak_level_stats(electrode);
                    previous_t = previous_values{2};

                    if t_value > previous_t && contains(type, 'positive')
                        peak_level_stats(electrode) = {t, t_value};
                    elseif t_value < previous_t && contains(type, 'negative')
                        peak_level_stats(electrode) = {t, t_value};
                    end

                else
                    peak_level_stats(electrode) = {0, 0};
                end

            end

        end

    end

    keys = peak_level_stats.keys;

    significant_electrode.electrode = '';
    significant_electrode.time = 0;
    significant_electrode.t_value = 0;

    for i = 1:numel(keys)
        electrode = keys{i};
        stats = peak_level_stats(electrode);
        t_value = stats{2};
        time = stats{1};

        if t_value > significant_electrode.t_value && contains(type, 'positive')
            significant_electrode.electrode = electrode;
            significant_electrode.time = time;
            significant_electrode.t_value = t_value;
        elseif t_value < significant_electrode.t_value && contains(type, 'negative')
            significant_electrode.electrode = electrode;
            significant_electrode.time = time;
            significant_electrode.t_value = t_value;
        end

    end


    start_clus= -1;
    end_clus = -1;
    for col = 1:columns
        if any(cluster_matrix_locations(:,col) == 1)
            if start_clus == -1
                start_clus = col;
            else
                end_clus = col;
            end
        end
    end
significant_electrode.sig_start = stat.time(start_clus);
try
    significant_electrode.sig_end =  stat.time(end_clus);
catch
    significant_electrode.sig_end =  stat.time(end);
end
    

end