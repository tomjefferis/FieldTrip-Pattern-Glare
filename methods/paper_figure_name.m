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
        if strcmp(onsets_part, "onsets-23-45-67")
            isonestsvs = true;
        end
    elseif strcmp(parts(i),'partitions') && ~isthreeway
        ispart = true;
    elseif strcmp(parts(i),'habituation')
        if isthreeway && i==length(parts)
            direction2 = 'Decrease';
        else
            direction1 = 'Decrease';
        end
    elseif strcmp(parts(i),'sensitization')
        if isthreeway && i==length(parts)
            direction2 = 'Increase';
        else
            direction1 = 'Increase';
        end
    elseif strcmp(parts(i),'normal')
        orthog = 'Unorthogonalized';
    elseif strcmp(parts(i),'orthog')
        orthog = 'Orthogonalized';
    
    end
end

if isonestsvs
    if strcmp(factor,'none')
        retfigname = strcat("Onsets Interaction x ",direction1," for Onsets 2,3 vs 4,5 vs 6,7 ",string(starttime),"-",string(endtime),'s');
    else
        retfigname = strcat(orthog," ",factor," x ",direction1," for Onsets 2,3 vs 4,5 vs 6,7 ",string(starttime),"-",string(endtime),'s');
    end
elseif ispart
    if strcmp(factor,'none')
        retfigname = strcat("Partitions Interaction x ",direction1," for Partitions ",string(starttime),"-",string(endtime),'s');
    else
        retfigname = strcat(orthog," ",factor," x ",direction1," for Partitions ",string(starttime),"-",string(endtime),'s');
    end
elseif isthreeway
    retfigname = strcat(orthog," Partitions vs Onsets for ",factor," factor ",string(starttime),"-",string(endtime),'s');
else
    retfigname = strcat("Onsets 2-8 for ",factor," factor ",string(starttime),"-",string(endtime),'s');
end


end