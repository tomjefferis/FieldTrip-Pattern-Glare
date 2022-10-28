function plot_design(design_matrix1, design_matrix2, design_matrix3, results, factor)
    

    if length(design_matrix1) > 34

        point = length(design_matrix1)/3;

        % design_matrix1 = first third of all 3 design matrix
        design_matrix1t = [design_matrix1(1:point), design_matrix2(1:point), design_matrix3(1:point)];
        design_matrix2t = [design_matrix1(point+1:2*point), design_matrix2(point+1:2*point), design_matrix3(point+1:2*point)];
        design_matrix3t = [design_matrix1(2*point+1:end), design_matrix2(2*point+1:end), design_matrix3(2*point+1:end)];


       design_matrix1 = design_matrix1t;
       design_matrix2 = design_matrix2t;
       design_matrix3 = design_matrix3t;
    end

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

    legend("Partition 1", "Partition 2", "Partition 3",'Location','northeastoutside');


    if length(design_matrix1) > 34
         xline(point,'--', 'Partition 1');
        xline(2*point, '--', 'Partition 2');
        xline(3*point, '--', 'Partition 3');
        legend("Onsets 2,3", "Onsets 4,5", "Onsets 6,7",'Location','northeastoutside');
        set(gcf, 'Position',  [100, 100, 800, 400]);
    else
        set(gcf, 'Position',  [100, 100, 500, 300]);
    end

    
    name = strcat(results, "/general/", factor, 'partitions_designmtx.png');
    saveas(gcf, name);
    
    hold on;

end