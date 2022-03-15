%% creates a topographic map highlighting the peak electrode
function plot_peak_electrode(stat, pos_peak_level_stats, save_dir)
    

    elecs = zeros(size(stat.elec.chanpos,1), 1);
    peak_electrode = pos_peak_level_stats.electrode;
    e_idx = find(contains(stat.label,peak_electrode));
    elecs(e_idx)=1;
    
    save_dir = save_dir + "/" + "highlighted_electrode.png";

    cfg = [];
    cfg.parameter = 'stat';
    cfg.zlim = [-5, 5];
    cg.colorbar = 'yes';
    cfg.marker = 'off';
    cfg.markersize = 1;
    cfg.highlight = 'on';
    cfg.highlightchannel = find(elecs);
    cfg.highlightcolor = {'r', [0 0 1]};
    cfg.highlightsize = 10;
    cfg.comment = 'no';
    cfg.style = 'blank';
    
    ft_topoplotER(cfg, stat);

    set(gcf,'Position',[100 100 250 250])
    exportgraphics(gcf,save_dir,'Resolution',500);
    close;

end
