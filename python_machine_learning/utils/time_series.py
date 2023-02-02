import numpy as np
import mne


##################################################
## Calculating the PGI of the FieldTrip Data
##################################################
## {License_info}
##################################################
## Author: Tom Jefferis
## Email: tfjj2@kent.ac.uk
##################################################

# gets the pattern glare index
def get_pgi(thin, med=None, thick=None):
    if med is None and thick is None:
        return get_pgi(thin["data"]["thin"], thin["data"]["med"], thin["data"]["thick"])
    else:
        return np.subtract(med, np.divide(np.add(thin, thick), 2))


## ERP
def shorten_data(data, lower=0.0, upper=4.0):
    for i in range(0, len(data)):
        data[i] = data[i].crop(lower, upper)

    return data


def shorten_time_series(data, lower=0.0, upper=4.0):
    lower_time = find_nearest_idx(data['times'], lower)
    upper_time = find_nearest_idx(data['times'], upper)

    data['times'] = data['times'][lower_time:upper_time]
    data['data'] = data['data'][lower_time:upper_time]

    return data


def find_nearest_idx(array, value):
    array = np.asarray(array)
    idx = (np.abs(array - value)).argmin()
    return idx
