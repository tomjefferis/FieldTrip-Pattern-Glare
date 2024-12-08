# FieldTrip Pattern Glare
## Overview
This program is a complete pipeline for pattern-glare analysis in FieldTrip and was used to generate results for publications listed below.

### Publications
[Sensitization and Habituation of Hyper-Excitation to Constant Presentation of Pattern-Glare Stimuli ](https://www.mdpi.com/3051632)

## Capabilities
### What Works:
Experiment  | Time Domain  | Frequency Domain
------------- | ------------- | -------------
Average onsets statistics | ✅ | ✅ Power & ❌ ITC
Partitions statistics | ✅ | ✅ Power & ❌ ITC
Onsets 2,3 vs 4,5 vs 6,7 statistics | ✅ | ✅ Power & ❌ ITC
Three-way interaction statistics | ✅ | ⬜️ Power & ❌ ITC
Global Field Power window finder | ✅ | ✴️ Untested
Topographic map plotting | ✅ | ✅ Power & ITC
ERP Plotting | ✅ | ✅ Power & ITC
Cluster Volume Plots | ✅ | ✅ Power & ITC
Frequency spectrum plots | N/A | ✅ Power & ❌ ITC


## Installation and Setup
* Clone this repository
* Add the FieldTrip Repository to MATLAB path

## Preprocessing
* Preprocess data using the included [preprocessing script](premade_scripts/freq_run_baselinehelper.m) in `premade_scripts`

## Configuration
* Setup filepaths in [main.m](main.m)
  * Lines 8-20 are needed for preprocessed filenames
  * Method [getFolderPath](methods/getFolderPath.m) needs changing to your path (found in `methods/getFolderPath.m`)
  * Fill out config parameters lines 21-55

## Running the Program
* Press run
