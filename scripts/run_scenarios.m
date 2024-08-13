%% run_scenarios.m
%% Load the fan model
model = 'fan_predictive_maintenance';
load_system(model);

%% Define parameters
% Define fault values
normal_bearing_friction = 0.1;
high_bearing_friction = 0.5;
normal_blade_imbalance = 0.05;
high_blade_imbalance = 0.3;
normal_winding_degradation = 0.1;
high_winding_degradation = 0.5;

% Define voltage levels
voltage_levels = [180, 210, 240];

% GY521 accelerometer parameters
ACCEL_RANGE = 8;  % ±8g range
ACCEL_SENSITIVITY = 4096;  % LSB/g for ±8g range
SAMPLING_RATE = 1000;  % 1 kHz sampling rate
NYQUIST_FREQ = SAMPLING_RATE / 2;
HIGHPASS_FREQ = 0.5;  % 0.5 Hz highpass filter
LOWPASS_FREQ = 260;   % 260 Hz lowpass filter (based on MPU6050 bandwidth)

%% Define function to run simulation and collect data
function [time, voltage, current, speed, vibration] = run_simulation(model, input_voltage, bearing_friction, blade_imbalance, winding_degradation, accel_params)
    % Set input voltage
    set_param([model '/Input Voltage'], 'Value', num2str(input_voltage));
    
    % Set fault conditions
    set_param([model '/Fan System/Bearing Friction'], 'visc_coef', num2str(bearing_friction));
    set_param([model '/Fan System/Vibration Generator/Natural Frequency'], 'Amplitude', num2str(blade_imbalance));
    set_param([model '/Fan System/Winding Degradation'], 'Rmin', num2str(winding_degradation));

    % Run simulation
    sim_out = sim(model);

    % Collect data
    time = sim_out.voltage.Time;
    voltage = sim_out.voltage.Data;
    current = sim_out.current.Data;
    speed = sim_out.speed.Data;
    raw_vibration = sim_out.vibration.Data;
    
    % Process vibration data to mimic GY521 output
    vibration = process_vibration(raw_vibration, time, accel_params);
end

%% Function to process vibration data
function processed_vibration = process_vibration(raw_vibration, time, accel_params)
    % Convert to acceleration in g
    acceleration_g = raw_vibration * accel_params.ACCEL_RANGE;
    
    % Convert to ADC values
    adc_values = round(acceleration_g * accel_params.ACCEL_SENSITIVITY);
    
    % Clip to 16-bit signed integer range
    adc_values = max(min(adc_values, 32767), -32768);
    
    % Design filters
    [b_high, a_high] = butter(2, accel_params.HIGHPASS_FREQ / accel_params.NYQUIST_FREQ, 'high');
    [b_low, a_low] = butter(6, accel_params.LOWPASS_FREQ / accel_params.NYQUIST_FREQ, 'low');
    
    % Apply filters
    filtered_values = filter(b_low, a_low, filter(b_high, a_high, adc_values));
    
    % Convert back to g
    processed_vibration = filtered_values / accel_params.ACCEL_SENSITIVITY;
end

%% Define scenarios
scenarios = {
    'All normal', normal_bearing_friction, normal_blade_imbalance, normal_winding_degradation;
    'High bearing friction', high_bearing_friction, normal_blade_imbalance, normal_winding_degradation;
    'High imbalance', normal_bearing_friction, high_blade_imbalance, normal_winding_degradation;
    'High winding degradation', normal_bearing_friction, normal_blade_imbalance, high_winding_degradation
};

% Initialize a cell array to store data for each scenario
scenario_data = cell(length(voltage_levels) * size(scenarios, 1), 1);

% Accelerometer parameters struct
accel_params = struct('ACCEL_RANGE', ACCEL_RANGE, 'ACCEL_SENSITIVITY', ACCEL_SENSITIVITY, ...
                      'SAMPLING_RATE', SAMPLING_RATE, 'NYQUIST_FREQ', NYQUIST_FREQ, ...
                      'HIGHPASS_FREQ', HIGHPASS_FREQ, 'LOWPASS_FREQ', LOWPASS_FREQ);

%% Run simulations for each scenario and voltage level
scenario_index = 1;
for v = 1:length(voltage_levels)
    for s = 1:size(scenarios, 1)
        [time, voltage, current, speed, vibration] = run_simulation(model, voltage_levels(v), ...
            scenarios{s,2}, scenarios{s,3}, scenarios{s,4}, accel_params);
        
        scenario_data{scenario_index} = struct('scenario', scenarios{s,1}, ...
                                               'voltage', voltage_levels(v), ...
                                               'time', time, ...
                                               'voltage_data', voltage, ...
                                               'current', current, ...
                                               'speed', speed, ...
                                               'vibration', vibration);
        
        fprintf('Completed scenario: %s at %dV\n', scenarios{s,1}, voltage_levels(v));
        scenario_index = scenario_index + 1;
    end
end

%% Compute and store FFT data with time information
fft_data = cell(size(scenario_data));
window_size = 1000; % 1 second window (assuming 1000 Hz sampling rate)
overlap = 500; % 50% overlap

for i = 1:length(scenario_data)
    data = scenario_data{i};
    vibration = data.vibration;
    time = data.time;
    
    % Initialize arrays to store FFT results
    num_windows = floor((length(vibration) - overlap) / (window_size - overlap));
    fft_magnitudes = zeros(num_windows, window_size/2 + 1);
    window_times = zeros(num_windows, 1);
    
    % Compute FFT for each window
    for j = 1:num_windows
        start_idx = (j-1)*(window_size-overlap) + 1;
        end_idx = start_idx + window_size - 1;
        
        window_data = vibration(start_idx:end_idx);
        window_times(j) = time(start_idx);
        
        % Compute FFT
        Y = fft(window_data);
        P2 = abs(Y/window_size);
        P1 = P2(1:window_size/2+1);
        P1(2:end-1) = 2*P1(2:end-1);
        
        fft_magnitudes(j, :) = P1;
    end
    
    % Compute frequency array (same for all windows)
    f = SAMPLING_RATE * (0:(window_size/2)) / window_size;
    
    fft_data{i} = struct('scenario', data.scenario, ...
                         'voltage', data.voltage, ...
                         'time', window_times, ...
                         'frequency', f, ...
                         'magnitude', fft_magnitudes);
end

%% Save Data
% Save the collected data
save(fullfile(dataDir, 'fan_simulation_data.mat'), 'scenario_data', 'accel_params');

% Save the frequency domain data
save(fullfile(dataDir, 'fan_simulation_frequency_data.mat'), 'fft_data', 'accel_params');

%% Plot results for each scenario
figure;
for i = 1:length(scenario_data)
    data = scenario_data{i};
    
    subplot(4,1,1);
    plot(data.time, data.voltage_data);
    hold on;
    title('Voltage');
    xlabel('Time (s)');
    ylabel('Voltage (V)');
    
    subplot(4,1,2);
    plot(data.time, data.current);
    hold on;
    title('Current');
    xlabel('Time (s)');
    ylabel('Current (A)');
    
    subplot(4,1,3);
    plot(data.time, data.speed);
    hold on;
    title('Speed');
    xlabel('Time (s)');
    ylabel('Speed (rad/s)');
    
    subplot(4,1,4);
    plot(data.time, data.vibration);
    hold on;
    title('Vibration');
    xlabel('Time (s)');
    ylabel('Acceleration (g)');
end
legend(cellfun(@(x,y) sprintf('%s (%dV)', x.scenario, x.voltage), scenario_data, 'UniformOutput', false));

%% Perform FFT on vibration data and plot
for v = 1:length(voltage_levels)
    figure('Name', sprintf('Frequency Spectrum - %dV', voltage_levels(v)));
    
    % Filter scenarios for the current voltage level
    current_voltage_scenarios = cellfun(@(x) x.voltage == voltage_levels(v), fft_data);
    current_fft_data = fft_data(current_voltage_scenarios);
    
    num_scenarios = length(current_fft_data);
    
    for i = 1:num_scenarios
        data = current_fft_data{i};
        
        % Calculate average magnitude across all time windows
        avg_magnitude = mean(data.magnitude, 1);
        
        % Plot average frequency spectrum
        subplot(num_scenarios, 1, i);
        plot(data.frequency, avg_magnitude);
        title(sprintf('%s (%dV)', data.scenario, data.voltage));
        xlabel('Frequency (Hz)');
        ylabel('Magnitude');
        xlim([0 LOWPASS_FREQ]);  % Limit x-axis to 0-260 Hz for better visibility
        grid on;
    end
    
    % Adjust subplot spacing
    sgtitle(sprintf('Frequency Spectrum - %dV', voltage_levels(v)));
    set(gcf, 'Position', get(0, 'Screensize'));  % Maximize figure window
end

%% Save time domain plots
saveas(gcf, fullfile(resultsDir, 'time_domain_plots.fig'));
saveas(gcf, fullfile(resultsDir, 'time_domain_plots.png'));

% Save frequency domain plots
for v = 1:length(voltage_levels)
    saveas(gcf, fullfile(resultsDir, sprintf('frequency_spectrum_%dV.fig', voltage_levels(v))));
    saveas(gcf, fullfile(resultsDir, sprintf('frequency_spectrum_%dV.png', voltage_levels(v))));
end

%% Close the model
close_system(model, 0);