function retfigname = paper_figure_name(figname, onsets_part,starttime, endtime)

delim = '-';
parts = split(figname,delim);

ispart = false;
isthreeway = false;
isonestsvs = false;

factor = '';
onsets = '';
direction1 = '';
direction2 = '';
orthog = '';

if contains(onsets_part, 'partitions-vs-onsets')
    isthreeway = true;
    parts = [parts(2:end); parts(1)];
end

if contains(parts{1},'discomfort')
    parts{1} = 'Discomfort';
elseif contains(parts{1},'headache')
    parts{1} = 'Headache';
elseif contains(parts{1},'none')
    parts{1} = 'Intercept';
elseif contains(parts{1},'visual')
    parts{1} = 'Visual Stress';
end


temp = parts{1};
temp(1) = upper(temp(1));
factor = temp;



for i = 1:length(parts) 
    
    if strcmp(parts(i),'onsets') && ~isthreeway
        if strcmp(parts(i+1), "23")
            isonestsvs = true;
        else

        end
    elseif strcmp(parts(i),'partitions') && ~isthreeway
        ispart = true;
    elseif strcmp(parts(i),'habituation')
        if isthreeway && i==length(parts)
            direction2 = direction1;
            direction1 = 'decrease';
        else
            direction1 = 'decrease';
        end
    elseif strcmp(parts(i),'sensitization')
        if isthreeway && i==length(parts)
            direction2 = direction1;
            direction1 = 'increase';
        else
            direction1 = 'increase';
        end
    end
end

if isonestsvs
    retfigname = strcat("Onsets 2,3 vs 4,5 vs 6,7 by ",factor," factor with an ",direction1," effect ",string(starttime),"-",string(endtime));
elseif ispart
    retfigname = strcat("Partitions by ",factor," factor with a ",direction1," effect ",string(starttime),"-",string(endtime));
elseif isthreeway
    retfigname = strcat("Partitions vs Onsets for ",factor," factor with an ",direction1," in partitions and an ",direction2," in onsets ",string(starttime),"-",string(endtime));
else
    retfigname = strcat("Onsets 2-8 for ",factor," factor ",string(starttime),"-",string(endtime));
end


end