function stat = stat_test(data, factor, start_time, end_time, design_matrix, timefreq, freqrange, testing)

    randomizer = 5000;

    if testing
        randomizer = 500;
    end

    %prepare neighbors so the test know what electrodes are where in space
    cfg = [];
    cfg.feedback = 'no';
    cfg.method = 'distance';
    cfg.elec = data{1}.elec;
    neighbours = ft_prepare_neighbours(cfg);
    % setting up the config for perm test
    cfg = [];
    cfg.latency = [start_time, end_time];
    cfg.channel = 'all';
    cfg.method = 'montecarlo';
    cfg.correctm = 'cluster';
    cfg.neighbours = neighbours;
    cfg.clusteralpha = 0.025;
    cfg.numrandomization = randomizer;
    cfg.design = design_matrix;
    cfg.computeprob = 'yes';
    cfg.alpha = 0.05;

    if strcmp(timefreq, 'time')
        % no factor rins a t-test between the PGI and zero data to find significance between Medium and thick/thin
        if strcmp(factor, 'none')
            cfg.statistic = 'ft_statfun_depsamplesT';
            null_data = set_values_to_zero(data);
            cfg.ivar = 2; % the 1st row in cfg.design contains the independent variable
            cfg.uvar = 1; % the 2nd row in cfg.design contains the subject number
            stat = ft_timelockstatistics(cfg, data{:}, null_data{:});
        else
            % if there is a condition a t-test is done with independant samples to find significance on factors
            cfg.statistic = 'ft_statfun_indepsamplesregrT';
            cfg.ivar = 1;
            stat = ft_timelockstatistics(cfg, data{:});
        end

    else
        % no factor rins a t-test between the PGI and zero data to find significance between Medium and thick/thin
        if strcmp(factor, 'none')
            cfg.statistic = 'ft_statfun_depsamplesT';
            null_data = set_values_to_zero(data);
            cfg.avgoverfreq = 'yes';
            cfg.ivar = 2; % the 1st row in cfg.design contains the independent variable
            cfg.uvar = 1; % the 2nd row in cfg.design contains the subject number
            cfg.frequency = freqrange;
            stat = ft_freqstatistics(cfg, data{:}, null_data{:});
            stat.prob = squeeze(stat.prob);

            try
                stat.posclusterslabelmat = squeeze(stat.posclusterslabelmat);
                stat.negclusterslabelmat = squeeze(stat.negclusterslabelmat);
            catch e

            end

            stat.cirange = squeeze(stat.cirange);
            stat.mask = squeeze(stat.mask);
            stat.stat = squeeze(stat.stat);
            stat.ref = squeeze(stat.ref);

        else
            % if there is a condition a t-test is done with independant samples to find significance on factors
            cfg.statistic = 'ft_statfun_indepsamplesregrT';
            cfg.avgoverfreq = 'yes';
            cfg.ivar = 1;
            cfg.frequency = freqrange;
            stat = ft_freqstatistics(cfg, data{:});
            stat.prob = squeeze(stat.prob);
            stat.cirange = squeeze(stat.cirange);
            stat.mask = squeeze(stat.mask);
            stat.stat = squeeze(stat.stat);
            stat.ref = squeeze(stat.ref);

            try
                stat.posclusterslabelmat = squeeze(stat.posclusterslabelmat);
                stat.negclusterslabelmat = squeeze(stat.negclusterslabelmat);
            catch e

            end

        end

    end

end