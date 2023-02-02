from os.path import exists

import mne
import numpy as np
from mne.channels import montage
from numpy import median
from utils.time_series import *
from utils.get_elec_label import get_elec_label
from pymatreader import read_mat
from utils.which_folder import which_folder
import os


##################################################
# Getting FieldTrip data and converting to MNE
##################################################
# {License_info}
##################################################
# Author: Tom Jefferis
# Email: tfjj2@kent.ac.uk
##################################################

# This function reads in the FieldTrip format participant average PGI and makes MNE data from it
#
# 4 arrays are returned:
# 0 = PGI
# 1 = thin
# 2 = med
# 3 = thick
#
# Examples:
# data = ft_load.get_participant(participant_data_name, num_participants=40, baseline=(2.8, 3))[0] -- Gets PGI only
# data = ft_load.get_participant(participant_data_name, num_participants=40, baseline=(2.8, 3))[1:3] -- gets 3 values, thin, med, and thick


def get_participant(filename, num_participants, baseline=(-0.2, 0), tmin=-0.2, sfreq=512):
    data = []
    thin = []
    med = []
    thick = []

    folder = which_folder()

    info = mne.create_info(
        ch_names=get_elec_label(),
        sfreq=sfreq,
        ch_types=['eeg'] * len(get_elec_label()))

    sensor_locs = mne.channels.make_standard_montage("biosemi128")

    for i in range(1, num_participants + 1):
        folder_loc = folder + str(i)
        filename_loc = os.path.join(folder_loc, filename)
        # just cos 36 doesnt have a score for some reason so excluded for ease
        if exists(filename_loc) :
            file = read_mat(filename_loc)
            pgi = get_pgi(file)
            item = mne.EvokedArray(pgi, info, tmin=tmin, baseline=baseline)
            item.set_montage(sensor_locs)
            data.append(item)

            thin_file = mne.EvokedArray(
                file["data"]["thin"], info, tmin=tmin, baseline=baseline).set_montage(sensor_locs)
            med_file = mne.EvokedArray(
                file["data"]["med"], info, tmin=tmin, baseline=baseline).set_montage(sensor_locs)
            thick_file = mne.EvokedArray(
                file["data"]["thick"], info, tmin=tmin, baseline=baseline).set_montage(sensor_locs)

            thin.append(thin_file)
            med.append(med_file)
            thick.append(thick_file)

    return data, thin, med, thick


def get_participant_epoch(data, time=(2.8, 4), baseline=(2.8, 3), sfreq=512):
    info = mne.create_info(
        ch_names=get_elec_label(),
        sfreq=sfreq,
        ch_types=['eeg'] * len(get_elec_label()))
    sensor_locs = mne.channels.make_standard_montage("biosemi128")
    time_series = []

    for i in range(0, len(data)):
        time_series.append(data[i].get_data(tmin=time[0], tmax=time[1]))

    time_series = np.dstack(time_series).transpose(2, 0, 1)
    return mne.EpochsArray(time_series, info=info, tmin=time[0], baseline=baseline).set_montage(sensor_locs)


def get_design_matrix(factor):
    arr = np.ones((31, 2))
    vspartitions = [-0.108600000000000, -0.510200000000000, 1.13360000000000, -0.639500000000000, -1.21470000000000, -0.330100000000000, 0.752400000000000, -0.390300000000000, -0.722100000000000, -0.769000000000000, -1.06300000000000, -0.898500000000000, -1.46720000000000, -1.19870000000000, 0.154200000000000, 0.586700000000000, 1.00080000000000, -0.116900000000000, 1.72090000000000, -0.748300000000000, 0.673900000000000, -0.0237000000000000, 0.0364000000000000, 0.699600000000000, -0.299800000000000, -0.650000000000000, 0.0262000000000000, -0.588300000000000, 2.33320000000000, 2.26670000000000]
    vsscores = [
        -0.264, 0.4459, -0.49781, 1.77666, -0.55638, 0.87174, -0.68504, 0.92835, -0.80581, -0.87505, 0.39111, -0.76054,
        -0.68987, 1.60776, 1.13956, 1.53606, 0.12186, 0.08428, 0.61663, -1.47958, 2.28422, -0.80891, -0.55738, -0.93291,
        0.3791, -0.63074, 2.14683, -1.49948, 1.21954, -0.79734, -1.0687, -1.02592, -0.87653, 0.444
    ]

    if factor == "visual_stress":
        for i in range(0, len(arr)):
            arr[i][1] = vsscores[i]
    elif factor == "stress_partitions":
        if factor == "visual_stress":
            for i in range(0, len(arr)):
                arr[i][1] = vspartitions[i]
    return np.array(arr)


def get_median_split(factor, data):
    factor = factor[:, 1].tolist()
    low = []
    high = []
    combined = sorted(list(zip(factor, data)), key=lambda x: x[0])
    data_len = len(data)
    mid = round(data_len / 2)

    for i in range(0, data_len):
        if i < mid:
            low.append(combined[i])
        else:
            high.append(combined[i])

    disc, low = map(list, zip(*low))
    disc, high = map(list, zip(*high))
    return low, high


def get_partitions(filename, num_participants, baseline=(-0.2, 0), tmin=-0.2, sfreq=512):
    part1 = []
    part2 = []
    part3 = []
    order = []

    folder = which_folder()

    info = mne.create_info(
        ch_names=get_elec_label(),
        sfreq=sfreq,
        ch_types=['eeg'] * len(get_elec_label()))

    sensor_locs = mne.channels.make_standard_montage("biosemi128")

    for i in range(1, num_participants + 1):
        folder_loc = folder + str(i)
        filename_loc = os.path.join(folder_loc, filename)
        # just cos 36 doesnt have a score for some reason so excluded for ease
        if exists(filename_loc) and i != 36:
            order.append(i)
            file = read_mat(filename_loc)
            p1_file = mne.EvokedArray(
                file["data"]["p1_pgi"], info, tmin=tmin, baseline=baseline).set_montage(sensor_locs)
            p2_file = mne.EvokedArray(
                file["data"]["p2_pgi"], info, tmin=tmin, baseline=baseline).set_montage(sensor_locs)
            p3_file = mne.EvokedArray(
                file["data"]["p3_pgi"], info, tmin=tmin, baseline=baseline).set_montage(sensor_locs)

            part1.append(p1_file)
            part2.append(p2_file)
            part3.append(p3_file)
    return part1, part2, part3, order


def get_trials(filename, num_participants, baseline=(-0.2, 0), tmin=-0.2, sfreq=512):
    data = []
    order = []

    folder = which_folder()

    info = mne.create_info(
        ch_names=get_elec_label(),
        sfreq=sfreq,
        ch_types=['eeg'] * len(get_elec_label()))

    sensor_locs = mne.channels.make_standard_montage("biosemi128")
    label_dict = {'thin': 1, 'medium': 2, 'thick': 3}

    for i in range(1, num_participants + 1):
        folder_loc = folder + str(i)
        filename_loc = os.path.join(folder_loc, filename)
        if i != 18:
            if exists(filename_loc):
                order.append(i-1) # files start at 1 but scores at 0
                file = read_mat(filename_loc)
                markers, array = get_epoch_format(file)
                item = mne.EpochsArray(
                    array, info, markers, event_id=label_dict, tmin=tmin, baseline=baseline)
                item.set_montage(sensor_locs)
                data.append(item)
                print("Participant " + str(i) + " loaded")
    return data, order

# makes one series of all conditions
# def combine_array(thin, med=None, thick=None)


def get_epoch_format(data):
    thin = data["data"]["thin"]
    med = data["data"]["med"]
    thick = data["data"]["thick"]

    thin.pop(0)
    med.pop(0)
    thick.pop(0)

    len_thin = [1] * len(thin)
    len_med = [2] * len(med)
    len_thick = [3] * len(thick)
    markers = np.array(len_thin + len_med + len_thick).reshape(-1, 1)
    we = np.arange(len(markers)).reshape(-1, 1)
    to = np.zeros(len(markers)).reshape(-1, 1)
    markers = np.concatenate((we, to, markers), axis=1).astype(int)

    return markers, np.dstack(thin + med + thick).transpose(2, 0, 1)
