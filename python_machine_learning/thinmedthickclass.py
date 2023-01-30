import tensorflow as tf
import utils.data as ft_load


participant_data_name = "time_domain_mean_intercept_onsets_2_3_4_5_6_7_8_trial-level_onsets.mat"
data, order = ft_load.get_trials(participant_data_name, num_participants=3)

# data is a list of 3 MNE objects, each with 25 trials
labels = []