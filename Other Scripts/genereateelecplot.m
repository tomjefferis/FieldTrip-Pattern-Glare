clear all;
restoredefaultpath;
addpath('.\methods');

[results_dir, main_path] = getFolderPath();
results_dir = strcat(results_dir, "/elecplots/");


grand_avg_filename = 'time_domain_mean_intercept_onsets_2_3_4_5_6_7_8_grand-average.mat';

[data, order] = load_data(main_path, grand_avg_filename, 40, "onsets");

[design_matrix, data] = get_design_matrix("none", data, order);

stat = stat_test(data, "none", 3.09, 3.18, design_matrix, "time", [0 1], true);

elecs_to_plot = ["B32","B2","C1","A3"];

for elecs = elecs_to_plot
    plot_peak_electrode(stat, elecs, results_dir);
end