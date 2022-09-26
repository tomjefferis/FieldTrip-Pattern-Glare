function plot_design_onsets(design_matrix1, results, factor)
    clf;

    if strcmp(factor, "none")
        design_matrix1 = design_matrix1(2, :);
    end

    maxm = max(design_matrix1) + 0.5;
    minm = min(design_matrix1) - 0.5;
    plot(design_matrix1, 'LineWidth', 3);
    ylim([minm, maxm]);
    hold on;
    
    tit = strrep(strcat(factor,' design matrix'), '-',' ');
    expression = '(^|[\. ])\s*.';
    replace = '${upper($0)}';
    tit = regexprep(tit,expression,replace);
    le = regexprep(factor,expression,replace);
    legend(le);
    title(tit);
    set(gcf, 'Position',  [100, 100, 500, 300]);
    name = strcat(results, "/general/", factor, 'onsets_designmtx.png');
    saveas(gcf, name);

    hold on;

end