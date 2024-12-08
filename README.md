# FieldTrip Pattern Glare

## Overview
This program is a complete pipeline for pattern-glare analysis in FieldTrip and was used to generate results for publications listed below.

### Publications
[Sensitization and Habituation of Hyper-Excitation to Constant Presentation of Pattern-Glare Stimuli](https://www.mdpi.com/3051632)

```bibtex
@Article{neurolint16060116,
  AUTHOR = {Jefferis, Thomas and Dogan, Cihan and Miller, Claire E. and Karathanou, Maria and Tempesta, Austyn and Schofield, Andrew J. and Bowman, Howard},
  TITLE = {Sensitization and Habituation of Hyper-Excitation to Constant Presentation of Pattern-Glare Stimuli},
  JOURNAL = {Neurology International},
  VOLUME = {16},
  YEAR = {2024},
  NUMBER = {6},
  PAGES = {1585--1610},
  URL = {https://www.mdpi.com/2035-8377/16/6/116},
  PubMedID = {39585075},
  ISSN = {2035-8377}
}
```

## Capabilities

### What Works:

| Experiment                        | Time Domain | Frequency Domain         |
|-----------------------------------|-------------|--------------------------|
| Average onsets statistics         | ✅          | ✅ Power & ❌ ITC         |
| Partitions statistics             | ✅          | ✅ Power & ❌ ITC         |
| Onsets 2,3 vs 4,5 vs 6,7 statistics | ✅          | ✅ Power & ❌ ITC         |
| Three-way interaction statistics  | ✅          | ⬜️ Power & ❌ ITC         |
| Global Field Power window finder  | ✅          | ✴️ Untested              |
| Topographic map plotting          | ✅          | ✅ Power & ITC           |
| ERP Plotting                      | ✅          | ✅ Power & ITC           |
| Cluster Volume Plots              | ✅          | ✅ Power & ITC           |
| Frequency spectrum plots          | N/A         | ✅ Power & ❌ ITC         |

## Installation and Setup

1. Clone this repository.
2. Add the FieldTrip Repository to MATLAB path.

## Preprocessing

- Preprocess data using the included [preprocessing script](premade_scripts/freq_run_baselinehelper.m) in `premade_scripts`.

## Configuration

- Setup file paths in [main.m](main.m):
  - Lines 8-20 are needed for preprocessed filenames.
  - Method [getFolderPath](methods/getFolderPath.m) needs changing to your path (found in `methods/getFolderPath.m`).
  - Fill out config parameters on lines 21-55.

## Running the Program

- Press run.
