function plot_erp_all(lines, legends, title, time, xlim, ylim, colours, confidence_ints)

    hold on;
    yline(0, '--');
    xline(3, '--', {'Stimulus Off'});
    ylim(ylim);
    xlim(xlim);
    title(title);

    for index = 1:length(lines)
        plot(lines(index), time, colours(index), 'DisplayName', legends(index), 'LineWidth', 1.4);

        if ~isempty(confidence_ints)
            h = patch([time fliplr(time)], [confidence_ints(index, 1, :) fliplr(confidence_ints(index, 2, :))], colours(index));
            set(h, 'facealpha', .01);
        end

    end

end