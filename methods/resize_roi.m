function [part] = resize_roi(data, start_time, end_time, roi_mask)
    template = data{1};
    lower = interp1(template.time, 1:length(template.time), start_time, 'nearest');
    upper = interp1(template.time, 1:length(template.time), end_time, 'nearest');
    range = upper - lower;
    difference = length(roi_mask) - range;

    if ~(difference == 0)
        upper = upper + difference;
    end

    elec_size = size(template.label, 1);
    first = zeros(elec_size, lower);
    end_mat = zeros(elec_size, length(template.time) - (lower + length(roi_mask)));
    part = [first, roi_mask, end_mat];
end