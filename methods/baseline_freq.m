function data = baseline_freq(data)

% Baselines freq data to the db scale before creating pgi in the frequency domain
% 
% Use as:
%       baseline_freq(data)
% 

    cfg.baseline = [2.8 3.0];
    cfg.baselinetype = 'db';
    data = ft_freqbaseline(cfg, data);
end