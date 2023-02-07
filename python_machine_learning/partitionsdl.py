import utils.data as ft_load
import pandas as pd
import numpy as np
from utils.scores import *
from utils.classifier_gen import *
import mne



participant_data_name = "time_domain_partitions_partitioned_onsets_2_3_4_5_6_7_8_trial-level_partitions.mat"
part1, part2, part3, order = ft_load.get_partitions(participant_data_name, num_participants=3)

data = [part1, part2, part3]

#get partition scores for discomfort
scores = getPartitionsScores(order,'discomfort','habituation')

for index in range(0,len(data)):
    freqs = range(20,50)
    cycles = 5
    data[index] = mne.time_frequency.tfr_morlet(data[index], freqs, cycles, return_itc=False, average=True, n_jobs=1, use_fft=True, decim=4).data
    
