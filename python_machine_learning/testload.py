# Test file for testing the functionality of MNE loading the FT data format
import mne
from matplotlib import pyplot as plt
import utils.time_series as ts
import utils.data as ft_load
import pandas as pd
import numpy as np


partition_data_name = "time_domain_partitions_partitioned_onsets_2_3_4_5_6_7_8_grand-average_partitions.mat"
p1,p2,p3 = ft_load.get_partitions(partition_data_name, num_participants=40, baseline=(2.8,3.0))

design = ft_load.get_design_matrix("stress_partitions")
p1_low, p1_high = ft_load.get_median_split(design,p1)
p2_low, p2_high = ft_load.get_median_split(design,p2)
p3_low, p3_high = ft_load.get_median_split(design,p3)
# setting up plots
fig, axes = plt.subplots(nrows=3, ncols=1, figsize=(20, 16))
fig.patch.set_facecolor('white')

#p1 =  mne.grand_average(p1);
#p2 =  mne.grand_average(p2);
#p3 =  mne.grand_average(p3);

lower = 2.8
upper = 4

low_evokeds = dict(Low=ts.shorten_data(p1_low,lower,upper),High=ts.shorten_data(p1_high,lower,upper))
mne.viz.plot_compare_evokeds(low_evokeds,vlines=[3],title="Partition 1 PGI @ D22", picks=['D22'], ci=True, axes=axes[0],show=False,truncate_xaxis=False)
for text in list(axes[0].texts):
        text.remove()
low_evokeds = dict(Low=ts.shorten_data(p2_low,lower,upper),High=ts.shorten_data(p2_high,lower,upper))
mne.viz.plot_compare_evokeds(low_evokeds,vlines=[3],title="Partition 2 PGI @ D22", picks=['D22'], ci=True, axes=axes[1],show=False,truncate_xaxis=False)
for text in list(axes[0].texts):
        text.remove()
low_evokeds = dict(Low=ts.shorten_data(p3_low,lower,upper),High=ts.shorten_data(p3_high,lower,upper))
mne.viz.plot_compare_evokeds(low_evokeds,vlines=[3],title="Partition 3 PGI @ D22", picks=['D22'], ci=True, axes=axes[2],show=False,truncate_xaxis=False)
for text in list(axes[0].texts):
        text.remove()

for plots in range(0,len(axes)):
    for text in list(axes[plots].texts):
        text.remove()

axes[0].get_lines()[0].set_linewidth(2)
axes[1].get_lines()[0].set_linewidth(2)
axes[2].get_lines()[0].set_linewidth(2)
axes[1].grid(b=True, which='major', color='#999999', linestyle='-',alpha=0.2)
axes[0].grid(b=True, which='major', color='#999999', linestyle='-',alpha=0.2)
axes[2].grid(b=True, which='major', color='#999999', linestyle='-',alpha=0.2)
axes[0].title.set_text('ERP Parrtition 1 D22')
axes[1].title.set_text('ERP Parrtition 2 D22')
axes[2].title.set_text('ERP Parrtition 3 D22')
fig.tight_layout()
plt.savefig("images/D22_ERP_partitions.png")
plt.show()



