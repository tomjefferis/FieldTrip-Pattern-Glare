import platform

##################################################
## Config files for data directory
##################################################
## {License_info}
##################################################
## Author: Tom Jefferis
## Email: tfjj2@kent.ac.uk
##################################################

def which_folder():
    system = platform.system()
    if system == "Darwin":
        return "/Users/tomjefferis/Documents/PhD/EEG Data/participant_"
    elif system == "Windows":
        return "W:\PhD\PatternGlareData\participants\participant_"
    elif system == "Linux":
        return "./PatternGlareData/participant_"
    else:
        return "Not Valid System"


