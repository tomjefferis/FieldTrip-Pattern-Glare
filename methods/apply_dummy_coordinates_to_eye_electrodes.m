function data = apply_dummy_coordinates_to_eye_electrodes(data)

    for i = 1:numel(data)
        participant = data{i};
        elec = participant.elec;
        elec.label = participant.label;

        REOG_build = participant.avg;
        REOG = (REOG_build(2, :) + REOG_build(3, :) + REOG_build(4, :) + REOG_build(5, :)) / 4 - REOG_build(1, :);

        HEOG = REOG_build(6, :);
        VEOG = REOG_build(7, :);

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
        participant.med = REOG + HEOG;
        participant.thick = VEOG;
        data{i} = participant;
    end

end