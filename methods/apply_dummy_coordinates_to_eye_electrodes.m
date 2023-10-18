% Apply dummy coordinates to eye electrodes
%
% This function applies dummy coordinates to eye electrodes in the given
% data. It sets the channel type to 'eeg', channel unit to 'V', and assigns
% the dummy coordinates to the channel and electrode positions. It also
% updates the labels and averages for the participant data.
%
% Input:
%   - data: a cell array of participant data
%
% Output:
%   - data: a cell array of participant data with dummy coordinates applied
%
% FILEPATH: w:\PhD\PatternGlareCode\FieldTrip-Pattern-Glare\methods\apply_dummy_coordinates_to_eye_electrodes.m
function data = apply_dummy_coordinates_to_eye_electrodes(data)

    for i = 1:numel(data)
        participant = data{i};
        elec = participant.elec;
        elec.label = participant.label;

        REOG_build = participant.avg;
        REOG = (REOG_build(2, :) + REOG_build(3, :) + REOG_build(4, :) + REOG_build(5, :)) / 4 - REOG_build(1, :);

        HEOG = REOG_build(6, :);
        VEOG = REOG_build(7, :);

        participant.thin_all = participant.thin(6:7,:);
        participant.med_all = participant.med(6:7,:);
        participant.thick_all = participant.thick(6:7,:);
        

        elec.chantype = {'eeg'};

        elec.chanunit = {'V'};
        dummy_coordinates = [
                        [39.0041, 73.3611, 14.3713], % C16
                        ];
        elec.chanpos = dummy_coordinates;
        elec.elecpos = dummy_coordinates;
        elec.label = {'A19'};
        participant.elec = elec;
        participant.label = {'A19'};
        participant.avg = REOG;
        participant.thin = HEOG;
        participant.med = REOG;
        participant.thick = VEOG;
        data{i} = participant;
    end

end