% freq_power_median_split - Plot the median split power for a given frequency range.
%
% Syntax: 
%   plots = freq_power_median_split(data, order, design_matrix, elec, frequency_range, time, factor, save_dir, paper_plot, font_size)
%
% Inputs:
%   data - FieldTrip data structure.
%   order - Order of the design matrix.
%   design_matrix - Design matrix.
%   elec - Electrode information.
%   frequency_range - Frequency range of interest.
%   time - Time range of interest.
%   factor - Factor to multiply the y-axis by.
%   save_dir - Directory to save the plots.
%   paper_plot - Boolean to indicate whether to create a plot for publication.
%   font_size - Font size for the plot.
%
% Outputs:
%   plots - Plot handles for the median split power plots.
%
% Example:
%   plots = freq_power_median_split(data, order, design_matrix, elec, [8 12], [-0.5 1], 1, 'plots/', true, 12)
%
% Other m-files required: median_split.m, average_power.m, plot_median_split_power.m
% Subfunctions: None
% MAT-files required: None
%
% See also: median_split, average_power, plot_median_split_power
function plots = freq_power_median_split(data, order, design_matrix, elec, frequency_range, time, factor, save_dir, paper_plot, font_size, baseline)

    [low, high] = median_split(data, order, design_matrix);

    low = average_power(low.data, frequency_range);
    high = average_power(high.data, frequency_range);
    
    plots = plot_median_split_power(low, high,elec, time,factor, save_dir,paper_plot, font_size, baseline);
end