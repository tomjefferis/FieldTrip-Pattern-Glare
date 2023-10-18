% FILEPATH: w:\PhD\PatternGlareCode\FieldTrip-Pattern-Glare\methods\ft_plot_baseline.m
%
% ft_plot_baseline - Plot two baselines of the given data and electrode.
%
% Usage:
%   ft_plot_baseline(data, baseline_1, baseline_2, electrode)
%
% Inputs:
%   data        - The data to plot the baselines for.
%   baseline_1  - The first baseline to plot.
%   baseline_2  - The second baseline to plot.
%   electrode   - The electrode to plot the baselines for.
%
% Outputs:
%   None
%
% See also:
%   rebaseline_data, gradient_finder, ylimit_finder, plot_baseline
function ft_plot_baseline(data, baseline_1,baseline_2, electrode)

    
   data1 = rebaseline_data(data, baseline_1);
   gradients1 = gradient_finder(data1, electrode);
    
  
   data2 = rebaseline_data(data, baseline_2);
   gradients2 = gradient_finder(data2, electrode);

  [highl,lowl] = ylimit_finder(data,electrode);
    ylimit = [-1,1];

%%    [h,p,ci,stats] = ttest2(gradients1,gradients2);

    figure
    subplot(2, 1, 1);
    plot_baseline(data1, baseline_1, electrode, baseline_1);
    ylim(ylimit);

    subplot(2, 1, 2);
    plot_baseline(data2, baseline_2, electrode, baseline_2);
    ylim(ylimit);

    set(gcf, 'Position', [100, 100, 850, 400]);

end