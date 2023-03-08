function retfigname = paper_figure_name(figname, onsets_part,starttime, endtime)

delim = '-';
parts = split(figname,delim);

ispart = false;
isthreeway = false;

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
elseif contains(parts{1},'visual')
    parts{1} = 'Visual Stress';
end


temp = parts{1};
temp(1) = upper(temp(1));
factor = temp;


if ~isthreeway
for i = 1:length(parts) 
    
    if strcmp(parts(i),'onsets') && ~isthreeway
        if strcmp(parts(i),figname{1})
        else
        end
    elseif strcmp(parts(i),'partitions') && ~isthreeway
        ispart = true;
    elseif strcmp(parts(i),'habituation')
        if isthreeway && i==length(parts)
            direction2 = direction1;
            direction1 = 'Habituation';
        else
            direction1 = 'Habituation';
        end
    elseif strcmp(parts(i),'sensitization')
        if isthreeway && i==length(parts)
            direction2 = direction1;
            direction1 = 'Sensitization';
        else
            direction1 = 'Sensitization';
        end
    end
end
end

if ispart
    retfigname = strcat("Partitions by ",factor," Factor by ",direction1," ",string(starttime),"-",string(endtime));
elseif isthreeway
    retfigname = strcat("Partitions vs Onsets by ",factor," Factor by ",direction1," by ",direction2," ",string(starttime),"-",string(endtime));
else
    retfigname = strcat("Onsets 2-8 For ",factor," Factor ",string(starttime),"-",string(endtime));
end


end