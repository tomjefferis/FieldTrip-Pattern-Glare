function dynamictimewarper(data,design)
% Dynamic Time Warper is a function that gets the DTW distance from each
% electrode to the average of all PGI

cfg = [];
cfg.parameter = 'med';
pgi = ft_timelockgrandaverage(cfg, data{:});
pgiData = pgi.var;


dtwDistances = [];
for i = 1:numel(data)
    dtwDistances(i) = dtw(data{i}.med,pgiData);
end
figure;
scatter(dtwDistances,design)

end

