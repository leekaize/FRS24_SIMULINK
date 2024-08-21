%% vibration_data_analysis.m

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

% Initialize variables
num_scenarios = length(scenario_data);
all_features = cell(num_scenarios, 1);
feature_names = {'RMS', 'Peak-to-Peak', 'Kurtosis', 'Crest Factor', 'Shape Factor', 'Impulse Factor', ...
                 'Freq1', 'Freq2', 'Freq3', 'Mag1', 'Mag2', 'Mag3', ...
                 'Central Freq', 'RMS Freq', 'Freq Variance'};

%% Create directories for saving results
resultsDir = fullfile(pwd, 'analysis_results');
if ~exist(resultsDir, 'dir')
    mkdir(resultsDir);
end

%% Create a single figure for all plots
fig_all = figure('Position', [50, 50, 1800, 900]);

% Determine unique scenarios and voltage levels
scenarios = unique(cellfun(@(x) x.scenario, scenario_data, 'UniformOutput', false));
voltages = unique(cellfun(@(x) x.voltage, scenario_data));
num_scenarios = length(scenarios);
num_voltages = length(voltages);

%% Process each scenario
for v = 1:num_voltages
    for s = 1:num_scenarios
        % Find the index of the current scenario and voltage
        idx = find(cellfun(@(x) strcmp(x.scenario, scenarios{s}) && x.voltage == voltages(v), scenario_data));
        
        if isempty(idx)
            continue; % Skip if this combination doesn't exist
        end
        
        current_data = scenario_data{idx};
        vibration_data = current_data.vibration;
        
        % Compute FFT
        Fs = 1 / mean(diff(current_data.time)); % Sampling frequency
        L = length(vibration_data);
        Y = fft(vibration_data);
        P2 = abs(Y/L);
        P1 = P2(1:L/2+1);
        P1(2:end-1) = 2*P1(2:end-1);
        f = Fs*(0:(L/2))/L;
        
        % Compute features
        all_features{idx} = compute_enhanced_features(vibration_data, Fs);
        
        % Calculate subplot indices
        col = s;
        row = v * 2 - 1;
        
        % Create time domain subplot
        subplot(num_voltages * 2, num_scenarios, (row-1) * num_scenarios + col);
        plot(current_data.time, vibration_data);
        title([scenarios{s}, ' (', num2str(voltages(v)), 'V)'], 'Interpreter', 'none');
        xlabel('Time (s)');
        ylabel('Amplitude');
        
        % Create frequency domain subplot
        subplot(num_voltages * 2, num_scenarios, row * num_scenarios + col);
        plot(f, P1);
        xlabel('Frequency (Hz)');
        ylabel('Magnitude');
        xlim([0, 500]); % Adjust as needed
    end
end

% Adjust subplot layout
sgtitle('Time and Frequency Domain Analysis of All Scenarios');

% Save the figure with all plots
saveas(fig_all, fullfile(resultsDir, 'all_scenarios_analysis.png'));

%% Convert cell array to matrix for easier analysis
feature_matrix = cell2mat(all_features);

%% Create and save enhanced box plots
figure('Position', [50, 50, 1200, 600]);
boxplot(feature_matrix, 'Labels', feature_names, 'Orientation', 'horizontal');
title('Feature Comparison Across Scenarios');
xlabel('Feature Value');
saveas(gcf, fullfile(resultsDir, 'enhanced_feature_boxplot.png'));

%% Perform robust statistical analysis
% Get scenario labels
scenario_labels = cellfun(@(x) x.scenario, scenario_data, 'UniformOutput', false);
unique_scenarios = unique(scenario_labels);

% Kruskal-Wallis test
p_values = zeros(1, size(feature_matrix, 2));
for i = 1:size(feature_matrix, 2)
    [p_values(i), ~, ~] = kruskalwallis(feature_matrix(:,i), scenario_labels, 'off');
end

% Save Kruskal-Wallis results
fid = fopen(fullfile(resultsDir, 'kruskal_wallis_results.txt'), 'w');
fprintf(fid, 'Kruskal-Wallis Test Results:\n');
for i = 1:length(feature_names)
    fprintf(fid, '%s: p-value = %e\n', feature_names{i}, p_values(i));
end
fclose(fid);

%% Perform feature selection using ReliefF algorithm
% ReliefF algorithm
[~, weights] = relieff(feature_matrix, scenario_labels, 10);

% Plot feature weights
figure('Position', [50, 50, 800, 600]);
bar(weights(ranks));
xlabel('Feature Rank');
ylabel('Feature Weight');
title('ReliefF Feature Weights');
xticks(1:length(feature_names));
xticklabels(feature_names(ranks));
xtickangle(45);
saveas(gcf, fullfile(resultsDir, 'relieff_feature_weights.png'));

%% Box plot analysis (using interquartile range as a measure of spread)
iqr_values = iqr(feature_matrix);

%% Scoring
% Normalize scores to a 0-1 range
kw_scores = 1 - (p_values / max(p_values));
relief_scores = (weights - min(weights)) / (max(weights) - min(weights));
iqr_scores = (iqr_values - min(iqr_values)) / (max(iqr_values) - min(iqr_values));
% Combine scores (adjust weights if needed)
combined_scores = 0.5 * relief_scores + 0.45 * kw_scores + 0.05 * iqr_scores;

%% Feature Selection
% Rank features
[sorted_scores, feature_ranks] = sort(combined_scores, 'descend');

% Select top N features (adjust N as needed)
N = 10;
selected_features = feature_ranks(1:N);

% Display ranking results
disp('Feature Ranking:');
for i = 1:length(feature_names)
    fprintf('%d. %s (Score: %.4f)\n', i, feature_names{feature_ranks(i)}, sorted_scores(i));
end

%% Create a heatmap of feature correlations
figure('Position', [50, 50, 800, 600]);
correlation_matrix = corrcoef(feature_matrix);
heatmap(correlation_matrix, 'XDisplayLabels', feature_names, 'YDisplayLabels', feature_names);
title('Feature Correlation Heatmap');
saveas(gcf, fullfile(resultsDir, 'feature_correlation_heatmap.png'));

%% Perform PCA on selected features
selected_feature_matrix = feature_matrix(:, selected_features);
[coeff, score, latent, tsquared, explained] = pca(selected_feature_matrix);

% Plot cumulative explained variance
figure('Position', [50, 50, 800, 600]);
plot(cumsum(explained), 'bo-');
xlabel('Number of Principal Components');
ylabel('Cumulative Variance Explained (%)');
title('PCA: Cumulative Variance Explained');
grid on;
saveas(gcf, fullfile(resultsDir, 'pca_cumulative_variance.png'));

% Plot first two principal components
figure('Position', [50, 50, 800, 600]);
gscatter(score(:,1), score(:,2), scenario_labels);
xlabel('First Principal Component');
ylabel('Second Principal Component');
title('PCA of Scenarios');
saveas(gcf, fullfile(resultsDir, 'pca_visualization.png'));

%% Print summary statistics
disp('Summary Statistics:');
summary_stats = array2table(quantile(feature_matrix, [0.25 0.5 0.75]), ...
    'VariableNames', feature_names, ...
    'RowNames', {'25th percentile', 'Median', '75th percentile'});
disp(summary_stats);

% Save summary statistics
writetable(summary_stats, fullfile(resultsDir, 'summary_statistics.csv'), 'WriteRowNames', true);

%% Helper Function: Enhanced feature computation
function features = compute_enhanced_features(time_data, Fs)
    % Time domain features
    rms_value = rms(time_data);
    peak_to_peak = max(time_data) - min(time_data);
    kurtosis_value = kurtosis(time_data);
    crest_factor = max(abs(time_data)) / rms_value;
    shape_factor = rms_value / mean(abs(time_data));
    impulse_factor = max(abs(time_data)) / mean(abs(time_data));
    
    % Frequency domain features
    [pxx, f] = periodogram(time_data, [], [], Fs);
    [sorted_magnitudes, sorted_indices] = sort(pxx, 'descend');
    top_frequencies = f(sorted_indices(1:3));
    top_magnitudes = sorted_magnitudes(1:3);
    
    % Spectral moments
    m0 = sum(pxx);
    m1 = sum(f .* pxx) / m0;
    m2 = sum((f.^2) .* pxx) / m0;
    m4 = sum((f.^4) .* pxx) / m0;
    
    fc = sqrt(m2 / m0);  % Central frequency
    rmsf = sqrt(m2);     % RMS frequency
    vf = sqrt(m4 / m2 - fc^2);  % Frequency variance
    
    % Ensure all features are scalar
    features = [rms_value, peak_to_peak, kurtosis_value, crest_factor, shape_factor, impulse_factor, ...
                top_frequencies(1), top_frequencies(2), top_frequencies(3), ...
                top_magnitudes(1), top_magnitudes(2), top_magnitudes(3), ...
                fc, rmsf, vf];
    
    % Check if all features are scalar
    if any(cellfun(@(x) ~isscalar(x), num2cell(features)))
        error('Not all features are scalar values. Check the computation of features.');
    end
end