# FieldTrip Pattern Glare
## This program is a complete pipeline for pattern-glare analysis in FieldTrip.
### What Works:
Experiment  | Time Domain  | Frequency Domain
------------- | ------------- | -------------
Average onsets statistics | ✅| ✅ Power & ❌ ITC
Partitions statistics | ✅| ✅ Power & ❌ ITC
Onsets 2,3 vs 4,5 vs 6,7 statistics | ✅| ✅ Power & ❌ ITC
Three-way interaction statistics | ✅| ⬜️ Power & ❌ ITC
Global Field Power window finder | ✅| ✴️ Untested
Topographic map plotting | ✅| ✅ Power & ITC
ERP Plotting | ✅| ✅ Power & ITC
Cluster Volume Plots | ✅| ⬜️ Power & ITC
Frequency spectrum plots | ❌| ⬜️ Power & ITC

### To run:
* Clone repository
* Add FieldTrip Repository to MATLAB path
* Preprocess data using included preprocessing script in premade_scripts
* Setup filepaths in main.mat 
  * Lines 8-20 are needed for preprocessed filenames
  * Method getFolderPath needs changing to your path (found in methods/getFolderPath)
  * fill out config parameters lines 21-55
* Press run
