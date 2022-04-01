function plot_baseline(data, time_window, significant_electrode, baseline_period)
    [thin, med, thick] = split_data(data);
    electrode_index = get_electrode_index(data, significant_electrode);
    cfg = [];
    cfg.latency = time_window;
    %get grand average erps for conditions
    grandavgthin = ft_timelockgrandaverage(cfg, thin{:});
    grandavgmed = ft_timelockgrandaverage(cfg, med{:});
    grandavgthick = ft_timelockgrandaverage(cfg, thick{:});

    x = grandavgthin.time;
    thinfit = polyfit(x,grandavgthin.avg(electrode_index, :),1);
    medfit = polyfit(x,grandavgmed.avg(electrode_index, :),1);
    thickfit = polyfit(x,grandavgthick.avg(electrode_index, :),1);
    y1 = polyval(thinfit,grandavgthin.time);%*mean(grandavgthin.avg(electrode_index, :));
    y2 = polyval(medfit,grandavgthin.time);%*mean(grandavgmed.avg(electrode_index, :));
    y3 = polyval(thickfit,grandavgthin.time);%*mean(grandavgthick.avg(electrode_index, :));
    %x = datas{1}.time(103:1639);


    plot(x,y1, 'Color', '#0072BD', 'LineWidth', 2);
    hold on;
    plot(x,y2, 'Color', '#D95319', 'LineWidth', 2);
    plot(x,y3, 'Color', '#EDB120', 'LineWidth', 2);

    patchline(x,grandavgthin.avg(electrode_index,:), 'edgecolor', '#0072BD', 'LineWidth', 2,'edgealpha',0.3);
    patchline(x,grandavgmed.avg(electrode_index,:), 'edgecolor', '#D95319', 'LineWidth', 2,'edgealpha',0.3);
    patchline(x,grandavgthick.avg(electrode_index,:), 'edgecolor', '#EDB120', 'LineWidth', 2,'edgealpha',0.3);
    grid on;
    xlim(time_window);
    ylim([-2,4]);
    title(strcat("ERP with best fit at ",significant_electrode.electrode," Baseline = ",string(baseline_period(1))," - ",string(baseline_period(2)),"s"));
    thinname = strcat("Thin ∇=", string(thinfit(1)));
    medname = strcat("Medium ∇=", string(medfit(1)));
    thickname = strcat("Thick ∇=", string(thickfit(1)));
    legend([thinname,medname,thickname]);
end