%% Get the project root directory
clear all; close all; clc;
projectRoot = fileparts(mfilename('fullpath'));

%% Create directories if they don't exist
dataDir = fullfile(projectRoot, 'data');
resultsDir = fullfile(projectRoot, 'results');
modelsDir = fullfile(projectRoot, 'models');

if ~exist(dataDir, 'dir')
    mkdir(dataDir);
end
if ~exist(resultsDir, 'dir')
    mkdir(resultsDir);
end
if ~exist(modelsDir, 'dir')
    mkdir(modelsDir);
end

%% Add paths
addpath(fullfile(projectRoot, 'scripts'));
addpath(fullfile(projectRoot, 'data'));
addpath(fullfile(projectRoot, 'results'));
addpath(fullfile(projectRoot, 'models'));

% Change to project root directory
cd(projectRoot);

% Create fan model
fan_model_setup;

% Run scenarios
run_scenarios;

% Run analysis and feature extraction
analysis_and_feature_extraction;

disp('Simulation completed. Results saved in data/ and results/ folders.');