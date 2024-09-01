%% run_scenarios.m

%% Load the fan model
model = 'fan_model';
load_system(model);

%% Define parameters
% Define fault values
normal_bearing_friction = 0.1;
high_bearing_friction = 0.4;
normal_blade_imbalance = 0.05;
high_blade_imbalance = 0.2;
normal_loose_blade = 0.05;
high_loose_blade = 0.2;

% Define voltage levels which is acting as the speed control level
voltage_levels = [180, 210, 240];

%% Define function to run simulation and collect data
function [time, voltage, current, speed, vibration] = run_simulation(model, input_voltage, bearing_friction, blade_imbalance, loose_blade)
    % Set input voltage
    set_param([model '/Input Voltage'], 'Value', num2str(input_voltage));
    
    % Set fault conditions
    set_param([model '/Fan System/Bearing Friction'], 'visc_coef', num2str(bearing_friction));
    set_param([model '/Fan System/Vibration Generator/Blade Imbalance'], 'Value', num2str(blade_imbalance));
    set_param([model '/Fan System/Vibration Generator/Loose Blade'], 'Value', num2str(loose_blade));

    % Run simulation
    sim_out = sim(model);

    % Collect data
    time = sim_out.voltage.Time;
    voltage = sim_out.voltage.Data;
    current = sim_out.current.Data;
    speed = sim_out.speed.Data;
    vibration = sim_out.vibration.Data;
end

%% Define scenarios
scenarios = {
    'All normal', normal_bearing_friction, normal_blade_imbalance, normal_loose_blade;
    'High bearing friction', high_bearing_friction, normal_blade_imbalance, normal_loose_blade;
    'High blade imbalance', normal_bearing_friction, high_blade_imbalance, normal_loose_blade;
    'Highly loose blade', normal_bearing_friction, normal_blade_imbalance, high_loose_blade;
};

% Initialize a cell array to store data for each scenario
scenario_data = cell(length(voltage_levels) * size(scenarios, 1), 1);

%% Run simulations for each scenario and voltage level
scenario_index = 1;
for v = 1:length(voltage_levels)
    for s = 1:size(scenarios, 1)
        [time, voltage, current, speed, vibration] = run_simulation(model, voltage_levels(v), ...
            scenarios{s,2}, scenarios{s,3}, scenarios{s,4});
        
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

%% Save Data
% Save the collected data
save('data/fan_simulation_data.mat', 'scenario_data');

%% Plot results for each scenario
figure;
hold on;
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
    ylabel('Vibration');
end
legend(cellfun(@(x) sprintf('%s (%dV)', x.scenario, x.voltage), scenario_data, 'UniformOutput', false));

%% Save time domain plots
set(gcf, 'Position', get(0, 'Screensize'));  % Maximize figure window
saveas(gcf, 'results/time_domain_plots.fig');
saveas(gcf, 'results/time_domain_plots.png');

%% Close the model
close_system(model, 0);
