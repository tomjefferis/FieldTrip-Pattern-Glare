function data = baseline_freq(data, baseline_period)

% Baselines freq data to the db scale before creating pgi in the frequency domain
% 
% Use as:
%       baseline_freq(data)
% 

    cfg.baseline = baseline_period;
    cfg.baselinetype = 'db';
    data = ft_freqbaseline(cfg, data);
end