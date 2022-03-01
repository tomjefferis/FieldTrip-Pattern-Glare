function [itc] = compute_itc(data)

    itc = [];
    itc.label = data.label;
    itc.freq = data.freq;
    itc.time = data.time;
    itc.dimord = 'chan_freq_time';

    F = data.fourierspctrm; % copy the Fourier spectrum
    N = size(F, 1); % number of trials

    % compute inter-trial phase coherence (itpc)
    itc.itpc = F ./ abs(F); % divide by amplitude
    itc.itpc = sum(itc.itpc, 1); % sum angles
    itc.itpc = abs(itc.itpc) / N; % take the absolute value and normalize
    itc.itpc = squeeze(itc.itpc); % remove the first singleton dimension

    % compute inter-trial linear coherence (itlc)
    itc.itlc = sum(F) ./ (sqrt(N * sum(abs(F).^2)));
    itc.itlc = abs(itc.itlc); % take the absolute value, i.e. ignore phase
    itc.itlc = squeeze(itc.itlc); % remove the first singleton dimension

end
