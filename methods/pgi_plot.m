function pgi_plot(data1, data2, data3, electrode)

    lines = line_getter(data1, "PGI", electrode);
    lines.append(line_getter(data2, "PGI", electrode));
    lines.append(line_getter(data3, "PGI", electrode));
    % plot_erp_all(lines,["PGI P1","PGI P2","PGI P3"],"PGI Through Partitions",);

end