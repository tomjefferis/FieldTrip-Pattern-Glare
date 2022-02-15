function plot_design(design_matrix1, design_matrix2, design_matrix3, results, factor)
    clf;
    maxm = max([design_matrix1, design_matrix2, design_matrix3]) + 0.5;
    minm = min([design_matrix1, design_matrix2, design_matrix3]) - 0.5;
    plot(design_matrix1, 'LineWidth', 2);
    ylim([minm, maxm]);
    hold on;
    plot(design_matrix2, 'LineWidth', 2);
    plot(design_matrix3, 'LineWidth', 2);
    legend("Partition 1", "Partition 2", "Partition 3");
    title(factor);
    name = strcat(results, "/general/", factor, 'partitions_designmtx.png');
    saveas(gcf, name);

    hold on;

end