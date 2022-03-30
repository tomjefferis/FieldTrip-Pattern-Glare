function [results_dir, main_path] = getFolderPath()

    % returns what filesystem you need
    % This should be changed depending on your filesystem

    if ismac
        % Code to run on Mac platform
        results_dir = '/Users/tomjefferis/Documents/PhD/Results'; % path to results
        main_path = '/Users/tomjefferis/Documents/PhD/EEG Data/participants/participant_';
        addpath('/Users/tomjefferis/Documents/PhD/MatlabPlugins/fieldtrip-20210906'); % path to fieldtrip
        addpath('/Users/tomjefferis/Documents/PhD/MatlabPlugins/spm12') % path to spm
        addpath("/Users/tomjefferis/Library/Application Support/MathWorks/MATLAB Add-Ons/Functions/Patchline/") %path to patchline plot
    elseif ispc
        % Code to run on Windows platform
        results_dir = 'W:\PhD\PatternGlareData\Results'; % path to results
        main_path = 'W:\PhD\PatternGlareData\participants\participant_';
        addpath('W:\PhD\MatlabPlugins\fieldtrip-20210906'); % path to fieldtrip
        addpath('W:\PhD\MatlabPlugins\spm12') % path to spm
        addpath("C:\Users\Tom\AppData\Roaming\MathWorks\MATLAB Add-Ons\Functions\Patchline") 
    else
        fprintf('Unsupported System');
    end

    ft_defaults;

end