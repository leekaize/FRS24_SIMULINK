%% test_tinyml_accuracy.m

%% Get the project root directory
projectRoot = fileparts(fileparts(mfilename('fullpath')));

% Change to project root directory
cd(projectRoot);

%% Add paths
addpath(fullfile(projectRoot, 'data'));
addpath(fullfile(projectRoot, 'models'));
addpath(fullfile(projectRoot, 'results'));
addpath(fullfile(projectRoot, 'scripts'));

% Load the processed data
load('data/updated_processed_fan_data.mat', 'X', 'y', 'scenario_info');

% Load the TFLite model
tfliteModel = loadTFLiteModel('models/fan_fault_detection.tflite');
tfliteModel.Mean = 0;
tfliteModel.StandardDeviation = 1;

% Initialize arrays to store predictions
all_predictions = zeros(size(y));

% Process each sample in X
for i = 1:size(X, 1)
    % Ensure features are in the correct shape (6x1 column vector)
    features = single(X(i, :)');
    
    % Model Inference
    prediction = predict(tfliteModel, features);
    [~, class_prediction] = max(prediction);
    all_predictions(i) = class_prediction - 1; % Adjust for 0-based indexing
end

% Calculate accuracy
accuracy = sum(all_predictions == y) / numel(y);
fprintf('TFLite Model Accuracy: %.4f\n', accuracy);

y = double(y);

% Generate confusion matrix
num_classes = numel(unique(y));
conf_matrix = confusionmat(y, all_predictions);

% Plot confusion matrix
figure;
imagesc(conf_matrix);
colorbar;
title('Confusion Matrix');
xlabel('Predicted Class');
ylabel('True Class');
axis square;

% Calculate precision, recall, and F1-score for each class
precision = diag(conf_matrix) ./ sum(conf_matrix, 1)';
recall = diag(conf_matrix) ./ sum(conf_matrix, 2);
f1_score = 2 * (precision .* recall) ./ (precision + recall);

% Display classification report
fprintf('\nClassification Report:\n');
fprintf('Class\tPrecision\tRecall\t\tF1-Score\n');
for i = 0:(num_classes-1)  % Start from 0 to match Python indexing
    fprintf('%d\t\t%.4f\t\t%.4f\t\t%.4f\n', i, precision(i+1), recall(i+1), f1_score(i+1));
end

% Calculate accuracy for each scenario
scenario_accuracies = zeros(num_classes, 1);
for i = 0:(num_classes-1)  % Start from 0 to match Python indexing
    scenario_mask = y == i;
    scenario_accuracy = sum(all_predictions(scenario_mask) == y(scenario_mask)) / sum(scenario_mask);
    scenario_accuracies(i+1) = scenario_accuracy;
end

% Display accuracy for each scenario
fprintf('\nAccuracy for each scenario:\n');
scenario_names = fieldnames(scenario_info);
for i = 1:num_classes
    fprintf('%s: %.4f\n', scenario_info.(scenario_names{i}), scenario_accuracies(i));
end