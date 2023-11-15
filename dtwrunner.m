%% EEG pattern glare analysis - Author: Tom Jefferis
%% This file is used for running DTW on the EEG data
%% setting up paths to plugins and default folder
clear all;
restoredefaultpath;
addpath('./methods');
addpath('C:\Users\Tom\AppData\Roaming\MathWorks\MATLAB Add-Ons\Collections\Image Manipulation Toolbox\MIMT')

grand_avg_filename = 'time_domain_mean_intercept_onsets_2_3_4_5_6_7_8_grand-average.mat'; % file name within folder that has participant data

n_participants = 40; % number of participants
onsets_part = 'onsets'; % onsets to use for each participant
factor = 'discomfort'; % factor to use for each participant
baseline_period = [-0.2 0]; % baseline period to use for each participant

[results_dir, main_path] = getFolderPath();
[datas, orders] = load_data(main_path, grand_avg_filename, n_participants, onsets_part);
[design_matrix, data] = get_design_matrix(factor, datas, orders);
[datas] = rebaseline_data(datas, baseline_period);

%% DTW
dynamictimewarper(datas,design_matrix)


