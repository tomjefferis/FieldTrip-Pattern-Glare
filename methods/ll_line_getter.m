function line = ll_line_getter(data, line, electrode)

    if strcmp(line, "PGI")
        line = data.avg(electrode, :);
    elseif strcmp(line, "thin")
        line = data.thin(electrode, :);
    elseif strcmp(line, "med")
        line = data.med(electrode, :);
    elseif strcmp(line, "thick")
        line = data.thick(electrode, :);
    end

end