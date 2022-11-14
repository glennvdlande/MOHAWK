function calcABCD(basename)

%% Prepare Power Spectrum
% load paths and data
loadpaths

EEG = pop_loadset([filepath basename '.set']);
EEG = convertoft(EEG);

% Prepare Fieldtrip Configuration
cfg_freq            = [];
cfg_freq.method     = 'mtmfft';
cfg_freq.taper      = 'dpss';
cfg_freq.tapsmofrq  = 1;
cfg_freq.foi        = 1:.25:30;
cfg_freq.output     = 'pow';
cfg_freq.keeptrials = 'no';
cfg_freq.keeptapers = 'no';
cfg_freq.pad        = 'nextpow2';

% Perform calculations
freq = ft_freqanalysis(cfg_freq, EEG);

%% Plot Power Spectrum

% Init vars
if length(EEG.elec.label) > 130
    channels = [59, 81, 183, 86, 101, 162];
    channel_names = {'C3', 'Cz', 'C4', 'P3', 'Pz', 'P4'};
else
    channels = [121, 43, 23, 11, 10, 19];
    channel_names = {'C3', 'FCz', 'C4', 'P3', 'Pz', 'P4'};
end
plot_locations = [1, 2, 3, 7, 8, 9];
sizes = ones(length(EEG.elec.pnt),1)*30;
sizes(channels) = sizes(channels) * 3;

% create figure
figure
subplot(3,3,5)
scatter(EEG.elec.pnt(:,1), EEG.elec.pnt(:,2), sizes, sizes, 'filled')
for k = 1:length(channels)
    text(EEG.elec.pnt(channels(k),1), EEG.elec.pnt(channels(k),2), channel_names{k})
end
axis off
subplot(3,3,4)
plot(freq.freq, mean(freq.powspctrm, 1), 'r', 'LineWidth', 3)
title('Channel average')
xticks([2,5,10,15,20,24])
for ii = [5,10,15,20]
    xline(ii, '--')
end
xlim([2 24])
xlabel('Frequency (Hz)')
ylabel('Power (dB)')
for iChan = 1:length(channels)
    subplot(3, 3, plot_locations(iChan))
    plot(freq.freq, freq.powspctrm(channels(iChan),:), 'r', 'LineWidth', 3)
    title(channel_names(iChan))
    xticks([2,5,10,15,20,24])
    for ii = [5,10,15,20]
        xline(ii, '--')
    end
    xlim([2 24])
    xlabel('Frequency (Hz)')
    ylabel('Power (dB)')
end

%% Save figure

savefile = sprintf('%s%s_ABCD.png', filepath, basename);
saveas(gcf, savefile)

end % function