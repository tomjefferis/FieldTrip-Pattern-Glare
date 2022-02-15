function [answer] = contains_struct(struct, value)

% returns true if there is a value specified in the struct
% Use as:
%       contains_struct(peakwindows, value)
%   
%   Only used in GFP window placer



    answer = false;
    names = fieldnames(struct(1));

    for index = 1:numel(struct)

        for i = 1:length(names)

            if getfield(struct(index), names{i}) == value
                answer = true;
            end

        end

    end

end