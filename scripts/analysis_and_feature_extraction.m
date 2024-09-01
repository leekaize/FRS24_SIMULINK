% analysis_and_feature_extraction.m
clear all; close all; clc;

%% Get the project root directory
projectRoot = fileparts(fileparts(mfilename('fullpath')));

%% Add paths
addpath(fullfile(projectRoot, 'data'));
addpath(fullfile(projectRoot, 'models'));
addpath(fullfile(projectRoot, 'results'));
addpath(fullfile(projectRoot, 'scripts'));

% Change to project root directory
cd(projectRoot);

%% Load the simulation data
load('fan_simulation_data.mat');

%% Define constants
WINDOW_SIZE = 128;
STEP_SIZE = 64;
SAMPLING_RATE = 1000;

%% Initialize variables
num_scenarios = length(scenario_data);
all_features = cell(num_scenarios, 1);
feature_names = {'RMS', 'Peak-to-Peak', 'Kurtosis', 'Crest Factor', 'Shape Factor', 'Impulse Factor', ...
                 'Freq1', 'Freq2', 'Freq3', 'Freq4', 'Freq5', ...
                 'Mag1', 'Mag2', 'Mag3', 'Mag4', 'Mag5', ...
                 'Central Freq', 'Freq Variance'};

%% Create directories for saving results
resultsDir = fullfile(pwd, 'analysis_results');
if ~exist(resultsDir, 'dir')
    mkdir(resultsDir);
end

%% Create a single figure for all plots
fig_all = figure('Position', [50, 50, 1800, 900]);

%% Determine unique scenarios and voltage levels
scenarios = unique(cellfun(@(x) x.scenario, scenario_data, 'UniformOutput', false));
voltages = unique(cellfun(@(x) x.voltage, scenario_data));
num_scenarios = length(scenarios);
num_voltages = length(voltages);

%% Process each scenario
all_labels = cell(num_scenarios, 1);

for v = 1:num_voltages
    for s = 1:num_scenarios
        % Find the index of the current scenario and voltage
        idx = find(cellfun(@(x) strcmp(x.scenario, scenarios{s}) && x.voltage == voltages(v), scenario_data));
        if isempty(idx)
            continue; % Skip if this combination doesn't exist
        end
        
        current_data = scenario_data{idx};
        time = current_data.time;
        vibration_data = current_data.vibration;
        
        % Find indices for 10-30 second range
        start_idx = find(time >= 10, 1);
        end_idx = find(time <= 30, 1, 'last');
        
        time_range = time(start_idx:end_idx);
        vibration_range = vibration_data(start_idx:end_idx);
        
        % Compute features for all windows in the 10-30 second range
        features = compute_enhanced_features(vibration_range, SAMPLING_RATE, WINDOW_SIZE, STEP_SIZE);
        all_features{idx} = features;
        all_labels{idx} = repmat(idx-1, size(features, 1), 1); % Labels start from 0
        
        % Calculate subplot indices
        col = s;
        row = v * 2 - 1;
        
        % Create time domain subplot (10-30 seconds)
        subplot(num_voltages * 2, num_scenarios, (row-1) * num_scenarios + col);
        plot(time_range, vibration_range);
        title([scenarios{s}, ' (', num2str(voltages(v)), 'V)'], 'Interpreter', 'none');
        xlabel('Time (s)');
        ylabel('Amplitude');
        xlim([10, 30]);
        
        % Create average frequency domain subplot
        subplot(num_voltages * 2, num_scenarios, row * num_scenarios + col);
        
        % Compute average frequency spectrum using FFT
        num_windows = floor((length(vibration_range) - WINDOW_SIZE) / STEP_SIZE) + 1;
        P1_avg = zeros(WINDOW_SIZE/2 + 1, 1);
        
        for i = 1:num_windows
            start_win = (i-1)*STEP_SIZE + 1;
            end_win = start_win + WINDOW_SIZE - 1;
            window = vibration_range(start_win:end_win);
            
            Y = fft(window);
            P2 = abs(Y/WINDOW_SIZE);
            P1 = P2(1:WINDOW_SIZE/2+1);
            P1(2:end-1) = 2*P1(2:end-1);
            
            P1_avg = P1_avg + P1;
        end
        P1_avg = P1_avg / num_windows;
        
        f = SAMPLING_RATE * (0:(WINDOW_SIZE/2))/WINDOW_SIZE;
        
        % Calculate the correct frequency resolution
        freq_resolution = SAMPLING_RATE / WINDOW_SIZE;
        
        % Find indices for the frequency range 7.8125 Hz to 500 Hz
        start_freq_idx = find(f >= freq_resolution, 1);
        end_freq_idx = find(f <= 500, 1, 'last');
        
        % Plot the frequency spectrum
        plot(f(start_freq_idx:end_freq_idx), P1_avg(start_freq_idx:end_freq_idx));
        xlabel('Frequency (Hz)');
        ylabel('Average Magnitude');
        xlim([freq_resolution, 500]);
        title(sprintf('Average Frequency Spectrum (%.4f-500 Hz)', freq_resolution));
    end
end

% Adjust subplot layout
sgtitle('Time (10-30s) and Average Frequency Domain Analysis of All Scenarios');

% Save the figure with all plots
saveas(fig_all, fullfile(resultsDir, 'all_scenarios_analysis.png'));

%% Combine all features and labels
X = cell2mat(all_features);
y = cell2mat(all_labels);

%% Check for complex values in X
if ~isreal(X)
    disp('Warning: X contains complex values');
    [row, col] = find(imag(X) ~= 0);
    for i = 1:length(row)
        fprintf('Complex value found at row %d, column %d\n', row(i), col(i));
        fprintf('Value: %s\n', mat2str(X(row(i), col(i))));
    end
    
    % Replace complex values with their magnitudes
    X = abs(X);
    warning('Complex values have been replaced with their magnitudes');
end

%% Perform Kruskal-Wallis test
% Get scenario labels
scenario_labels = cellfun(@(x) repmat({[x.scenario, ' (', num2str(x.voltage), 'V)']}, size(all_features{1}, 1), 1), scenario_data, 'UniformOutput', false);
scenario_labels = vertcat(scenario_labels{:});

% Kruskal-Wallis test
p_values = zeros(1, size(X, 2));
for i = 1:size(X, 2)
    [p_values(i), ~, ~] = kruskalwallis(X(:,i), scenario_labels, 'off');
end

% Rank features based on Kruskal-Wallis test (lower p-value is better)
[sorted_p_values, kw_ranks] = sort(p_values);

%% Save Kruskal-Wallis results
fid = fopen(fullfile(resultsDir, 'kruskal_wallis_ranking.txt'), 'w');
fprintf(fid, 'Kruskal-Wallis Test Ranking:\n');
for i = 1:length(feature_names)
    fprintf(fid, '%d. %s (p-value = %e)\n', i, feature_names{kw_ranks(i)}, sorted_p_values(i));
end
fclose(fid);

%% Bar plot for Kruskal-Wallis results
figure('Position', [100, 100, 800, 600]);
bar(sorted_p_values);
title('Kruskal-Wallis Test: Feature p-values');
xlabel('Feature');
ylabel('p-value (lower is better)');
set(gca, 'XTick', 1:length(feature_names), 'XTickLabel', feature_names(kw_ranks), 'XTickLabelRotation', 90);
grid on;
saveas(gcf, fullfile(resultsDir, 'kruskal_wallis_pvalues_barplot.png'));

%% Create a structure to store scenario information
scenario_info = struct();
for i = 1:length(scenario_data)
    scenario = scenario_data{i};
    scenario_name = scenario.scenario;
    voltage = scenario.voltage;
    key = sprintf('scenario_%d', i-1);
    scenario_info.(key) = sprintf('%s (%dV)', scenario_name, voltage);
end

%% Create a structure to store feature rankings
feature_rankings = struct('names', {feature_names}, 'kw_ranks', kw_ranks, 'kw_p_values', sorted_p_values);

%% Save the processed data
save(fullfile(resultsDir, 'processed_fan_data.mat'), 'X', 'y', 'scenario_info', 'feature_rankings');
disp('Analysis and feature extraction complete. Data saved to processed_fan_data.mat');

%% Helper Function: Enhanced feature computation
function features = compute_enhanced_features(time_data, Fs, window_size, step_size)
    % Create windows
    num_windows = floor((length(time_data) - window_size) / step_size) + 1;
    features = zeros(num_windows, 18);  % 18 is the number of features

    % Calculate the correct frequency resolution
    freq_resolution = Fs / window_size;
    
    for i = 1:num_windows
        start_idx = (i-1)*step_size + 1;
        end_idx = start_idx + window_size - 1;
        window = time_data(start_idx:end_idx);
        
        % Time domain features
        rms_value = rms(window);
        peak_to_peak = max(window) - min(window);
        kurtosis_value = kurtosis(window);
        crest_factor = max(abs(window)) / rms_value;
        shape_factor = rms_value / mean(abs(window));
        impulse_factor = max(abs(window)) / mean(abs(window));
        
        % Frequency domain features using FFT
        Y = fft(window);
        P2 = abs(Y/window_size);
        P1 = P2(1:window_size/2+1);
        P1(2:end-1) = 2*P1(2:end-1);
        
        f = Fs * (0:(window_size/2))/window_size;
        
        % Find indices for the frequency range 7.8125 Hz to 500 Hz
        start_freq_idx = find(f >= freq_resolution, 1);
        end_freq_idx = find(f <= 500, 1, 'last');
        
        f_range = f(start_freq_idx:end_freq_idx);
        P1_range = P1(start_freq_idx:end_freq_idx);
        
        [sorted_magnitudes, sorted_indices] = sort(P1_range, 'descend');
        top_frequencies = f_range(sorted_indices(1:5));
        top_magnitudes = sorted_magnitudes(1:5);
        
        % Spectral moments (using element-wise operations)
        m0 = sum(P1_range.^2);
        m2 = sum((f_range.^2) .* (P1_range.^2)) ./ m0;
        m4 = sum((f_range.^4) .* (P1_range.^2)) ./ m0;
        
        fc = sqrt(m2); % Central frequency
        vf = sqrt(abs(m4 - (m2 .* m2))); % Frequency variance (using element-wise multiplication)
        
        % Ensure scalar values for feature vector
        fc = mean(fc);
        vf = mean(vf);
        
        features(i, :) = [rms_value, peak_to_peak, kurtosis_value, crest_factor, shape_factor, impulse_factor, ...
                          top_frequencies(1), top_frequencies(2), top_frequencies(3), top_frequencies(4), top_frequencies(5), ...
                          top_magnitudes(1), top_magnitudes(2), top_magnitudes(3), top_magnitudes(4), top_magnitudes(5), ...
                          fc, vf];
    end
end