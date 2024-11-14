function plot = line_chart(low,high,electrode)
    % Extracting values based on electrode.max_indx for each group
    low_med_value = low.med(electrode.max_indx);
    low_thin_value = low.thin(electrode.max_indx);
    low_thick_value = low.thick(electrode.max_indx);

    high_med_value = high.med(electrode.max_indx);
    high_thin_value = high.thin(electrode.max_indx);
    high_thick_value = high.thick(electrode.max_indx);

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