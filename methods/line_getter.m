% gets timeseries of line
function [lines] = line_getter(data, lines, electrode)

    if numel(data) ~= 1
        cfg = [];
        cfg.channel = 'all';
        cfg.latency = 'all';
        electode = get_electrode_index(data, electode);
        data = ft_timelockgrandaverage(cfg, data);
    else
        electode = get_electrode_index({data}, electode);
    end

    lines = [];

    for line = lines
        lines.append(ll_line_getter(data, line, electrode))
    end

end