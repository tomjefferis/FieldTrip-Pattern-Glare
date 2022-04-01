%% creates a topographic map highlighting the peak electrode
function plot_peak_electrode(stat, peak_electrode, save_dir)
    
    if ~isstring(peak_electrode)
        pos_peak_level_stats = peak_electrode;
        peak_electrode = pos_peak_level_stats.electrode;
    end

    elecs = zeros(size(stat.elec.chanpos,1), 1);
    e_idx = find(contains(stat.label,peak_electrode));
    elecs(e_idx)=1;
    
    save_dir = save_dir + "/" + peak_electrode +"_highlighted_electrode.png";
    figure;
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
    b = gca; legend(b,'off');
    set(gcf,'Position',[100 100 250 250])
    exportgraphics(gcf,save_dir,'Resolution',500);
    close;

end
