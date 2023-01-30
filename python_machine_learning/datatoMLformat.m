clear all;
restoredefaultpath;
addpath('../methods');

single_trial_filename = 'time_domain_mean_intercept_onsets_2_3_4_5_6_7_8_trial-level.mat'; % file name for single trial data

[results_dir, main_path] = getFolderPath();
[ft_data, order] = load_data(main_path, single_trial_filename, 40, 'onsets');



%make 4 arrays, thin medium thick and scores (scores is 1 for thin, 2 for medium, 3 for thick)
thin = [];
medium = [];
thick = [];
scores = [];

%get label index for Oz for first participant
oz_index = find(strcmp(ft_data{1}.label, 'A23'));

%loop through all data and append to the correct array
for i = 1:length(ft_data)
    thin = [thin ft_data{i}.thin];
    medium = [medium ft_data{i}.med];
    thick = [thick ft_data{i}.thick];
end

for index = 1:length(thin)
    temp = thin{index};
    thin{index} = temp(oz_index,:);
end

for index = 1:length(medium)
    temp = medium{index};
    medium{index} = temp(oz_index,:);
end

for index = 1:length(thick)
    temp = thick{index};
    thick{index} = temp(oz_index,:);
end

for i = 1:length(thin)
   thinflat(i,:) = thin{i};
end

for i = 1:length(medium)
   mediumflat(i,:) = medium{i};
end

for i = 1:length(thick)
   thickflat(i,:) = thick{i};
end

tn_scores = ones(size(thinflat,1),1);
md_scores = 2 * ones(size(mediumflat,1),1);
tk_scores = 3 * ones(size(thickflat,1),1);
scores = [tn_scores;md_scores;tk_scores];
%combine thin medium and thick arrays into one array
data = [thinflat; mediumflat; thickflat];

resampdata = [];
%resample each row of data from 512hz to 256hz
for i = 1:size(data,1)
    resampdata(i,:) = resample(data(i,:), 1, 2);
end
data = resampdata;

%export data and scores to csv
writematrix(data, 'W:\PhD\PatternGlareCode\FieldTrip-Pattern-Glare\python_machine_learning\ml_data.csv');
writematrix(scores,'W:\PhD\PatternGlareCode\FieldTrip-Pattern-Glare\python_machine_learning\ml_scores.csv');

