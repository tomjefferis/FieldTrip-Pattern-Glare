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
end


for i = 0:length(parts) 
    if strcmp(parts(i),'discomfort')
    elseif strcmp(parts(i),'headache')
    elseif strcmp(parts(i),'visual')
    elseif strcmp(parts(i),'onsets') && ~isthreeway
        if strcmp(parts(i),figname{1})
        else
        end
    elseif strcmp(parts(i),'partitions') && ~isthreeway
        ispart = true;
    elseif strcmp(parts(i),'partitions') && isthreeway
    elseif strcmp(parts(i),'habituation')
    elseif strcmp(parts(i),'sensitization')
    end
end
    

if ispart
elseif isthreeway
else
end


end