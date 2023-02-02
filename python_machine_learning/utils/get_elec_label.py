import csv

##################################################
## Getting the electrode names for the Biosemi 128 cap
##################################################
## {License_info}
##################################################
## Author: Tom Jefferis
## Email: tfjj2@kent.ac.uk
##################################################

def get_elec_label():
    with open('utils/label.csv', newline='\n') as f:
        reader = csv.reader(f)
        data = [row[0] for row in reader]
        return data
