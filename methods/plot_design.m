function plot_design(design_matrix1, design_matrix2, design_matrix3, results, factor)
    clf;
    maxm = max([design_matrix1, design_matrix2, design_matrix3]) + 0.5;
    minm = min([design_matrix1, design_matrix2, design_matrix3]) - 0.5;
    plot(design_matrix1, 'LineWidth', 3);
    ylim([minm, maxm]);
    hold on;
    plot(design_matrix2, 'LineWidth', 3);
    plot(design_matrix3, 'LineWidth', 3);
    tit = strrep(factor, '-',' ');
    expression = '(^|[\. ])\s*.';
    replace = '${upper($0)}';
    tit = regexprep(tit,expression,replace);
    title(tit);

    if length(design_matrix1) > 34

        point = length(design_matrix1)/3;


        xline(point,'--', 'Onsets 2,3');
        xline(2*point, '--', 'Onsets 4,5');
        xline(3*point, '--', 'Onsets 6,7');
        
    end
    legend("Partition 1", "Partition 2", "Partition 3",'Location','northeastoutside');
    set(gcf, 'Position',  [100, 100, 500, 300]);
    name = strcat(results, "/general/", factor, 'partitions_designmtx.png');
    saveas(gcf, name);
    
    hold on;

end