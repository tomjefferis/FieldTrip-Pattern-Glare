function plots = line_chart_through_time(low1,low2,low3,high1,high2,high3,electrode, flag)
    cfg = [];
    cfg.channel = 'all';
    cfg.latency = 'all';
if strcmp(flag, 'med')
    cfg.parameter = "med";
end

    low1 = ft_timelockgrandaverage(cfg, low1{:});
    low2 = ft_timelockgrandaverage(cfg, low2{:});
    low3 = ft_timelockgrandaverage(cfg, low3{:});

    high1 = ft_timelockgrandaverage(cfg, high1{:});
    high2 = ft_timelockgrandaverage(cfg, high2{:});
    high3 = ft_timelockgrandaverage(cfg, high3{:});


% Determine which field to use based on the flag
if strcmp(flag, 'pgi')
    low_med_value = low1.avg(electrode.max_indx);
    low_thin_value = low2.avg(electrode.max_indx);
    low_thick_value = low3.avg(electrode.max_indx);
    
    high_med_value = high1.avg(electrode.max_indx);
    high_thin_value = high2.avg(electrode.max_indx);
    high_thick_value = high3.avg(electrode.max_indx);
elseif strcmp(flag, 'med')
    low_med_value = low1.med(electrode.max_indx);
    low_thin_value = low2.med(electrode.max_indx);
    low_thick_value = low3.med(electrode.max_indx);
    
    high_med_value = high1.med(electrode.max_indx);
    high_thin_value = high2.med(electrode.max_indx);
    high_thick_value = high3.med(electrode.max_indx);
else
    error('Invalid flag. Please use either ''pgi'' or ''med''.');
end


% Creating the x-axis values for plotting
x_values_low = [1, 2]; % Two points per pair
x_values_high = [1, 2];

% Plotting low group data
plot(x_values_low, [low_med_value(1), low_thin_value(1)], '-o', 'DisplayName','Low_Med_Thin');
hold on;
plot(x_values_low, [low_med_value(2), low_thick_value(2)], '-x', 'DisplayName','Low_Med_Thick');

% Plotting high group data
plot(x_values_high + 1, [high_med_value(1), high_thin_value(1)], '--o', 'DisplayName','High_Med_Thin');
plot(x_values_high + 1, [high_med_value(2), high_thick_value(2)], '--x', 'DisplayName','High_Med_Thick');

% Adding labels and title
xlabel('Index');
ylabel('Value');
end
