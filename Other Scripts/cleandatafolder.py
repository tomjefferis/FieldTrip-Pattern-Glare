import os

datafolder = 'W:\\PhD\\PatternGlareData\\participants\\participant_'

for i in range(1, 40):
    currentfolder = datafolder + str(i)
    if os.path.exists(currentfolder):
        for file in os.listdir(currentfolder):
        # if file doesnt contain '-Deci_ready_for_ft'
            if not '-Deci_ready_for_ft' in file:
                os.remove(os.path.join(currentfolder, file))

