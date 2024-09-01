%% fan_model_setup.m

%% Get the project root directory
projectRoot = fileparts(fileparts(mfilename('fullpath')));

%% Add paths
addpath(fullfile(projectRoot, 'data'));
addpath(fullfile(projectRoot, 'models'));
addpath(fullfile(projectRoot, 'results'));
addpath(fullfile(projectRoot, 'scripts'));

% Change to project root directory
cd(projectRoot);

%% Create new Simulink model
model = 'fan_predictive_maintenance';
open_system(new_system(model));

%% Create a subsystem for the fan components
add_block('simulink/Ports & Subsystems/Subsystem', [model '/Fan System']);
% Remove default input/output ports
delete_line([model '/Fan System'], 'In1/1', 'Out1/1');
delete_block([model '/Fan System/In1']);
delete_block([model '/Fan System/Out1']);

% Add blocks to the Fan System subsystem
add_block('fl_lib/Electrical/Electrical Sources/Controlled Voltage Source', [model '/Fan System/Voltage Source']);
add_block('fl_lib/Electrical/Electrical Elements/Resistor', [model '/Fan System/Motor Windings R']);
add_block('fl_lib/Electrical/Electrical Elements/Inductor', [model '/Fan System/Motor Windings L']);
add_block('ee_lib/Electromechanical/Brushed Motors/DC Motor', [model '/Fan System/DC Motor']);
add_block('fl_lib/Mechanical/Rotational Elements/Inertia', [model '/Fan System/Fan Blades']);
add_block('fl_lib/Mechanical/Rotational Elements/Rotational Damper', [model '/Fan System/Air Resistance']);
add_block('fl_lib/Mechanical/Mechanical Sensors/Ideal Rotational Motion Sensor', [model '/Fan System/Speed Sensor']);
add_block('fl_lib/Electrical/Electrical Sensors/Current Sensor', [model '/Fan System/Current Sensor']);
add_block('fl_lib/Electrical/Electrical Sensors/Voltage Sensor', [model '/Fan System/Voltage Sensor']);
add_block('fl_lib/Electrical/Electrical Elements/Electrical Reference', [model '/Fan System/Electrical Ground']);
add_block('fl_lib/Mechanical/Rotational Elements/Mechanical Rotational Reference', [model '/Fan System/Mechanical Ground']);

% Add fault injection mechanisms to the subsystem
add_block('fl_lib/Mechanical/Rotational Elements/Rotational Friction', [model '/Fan System/Bearing Friction']);
add_block('fl_lib/Mechanical/Mechanical Sources/Ideal Torque Source', [model '/Fan System/Imbalance Torque']);
add_block('fl_lib/Electrical/Electrical Elements/Variable Resistor', [model '/Fan System/Winding Degradation']);

% Add Simulink-PS Converters inside the subsystem
add_block('nesl_utility/Simulink-PS Converter', [model '/Fan System/Voltage Converter']);
add_block('nesl_utility/PS-Simulink Converter', [model '/Fan System/Voltage Sensor Converter']);
add_block('nesl_utility/PS-Simulink Converter', [model '/Fan System/Current Sensor Converter']);
add_block('nesl_utility/PS-Simulink Converter', [model '/Fan System/Speed Sensor Converter']);

% Connect blocks within the Fan System subsystem
add_line([model '/Fan System'], 'Voltage Converter/RConn1', 'Voltage Source/RConn1', 'autorouting', 'on');
add_line([model '/Fan System'], 'Voltage Source/LConn1', 'Current Sensor/LConn1', 'autorouting', 'on');
add_line([model '/Fan System'], 'Current Sensor/RConn2', 'Motor Windings R/LConn1', 'autorouting', 'on');
add_line([model '/Fan System'], 'Motor Windings R/RConn1', 'Motor Windings L/LConn1', 'autorouting', 'on');
add_line([model '/Fan System'], 'Motor Windings L/RConn1', 'Winding Degradation/LConn2', 'autorouting', 'on');
add_line([model '/Fan System'], 'Winding Degradation/RConn1', 'DC Motor/LConn1', 'autorouting', 'on');
add_line([model '/Fan System'], 'DC Motor/RConn1', 'Voltage Source/RConn2', 'autorouting', 'on');
add_line([model '/Fan System'], 'DC Motor/LConn2', 'Fan Blades/LConn1', 'autorouting', 'on');
add_line([model '/Fan System'], 'Fan Blades/LConn1', 'Air Resistance/LConn1', 'autorouting', 'on');
add_line([model '/Fan System'], 'Fan Blades/LConn1', 'Speed Sensor/LConn1', 'autorouting', 'on');
add_line([model '/Fan System'], 'Fan Blades/LConn1', 'Bearing Friction/LConn1', 'autorouting', 'on');
add_line([model '/Fan System'], 'Imbalance Torque/LConn1', 'Fan Blades/LConn1', 'autorouting', 'on');
add_line([model '/Fan System'], 'Voltage Sensor/LConn1', 'DC Motor/LConn1', 'autorouting', 'on');
add_line([model '/Fan System'], 'Voltage Sensor/RConn2', 'DC Motor/RConn1', 'autorouting', 'on');
add_line([model '/Fan System'], 'Voltage Source/RConn2', 'Electrical Ground/LConn1', 'autorouting', 'on');
add_line([model '/Fan System'], 'Air Resistance/RConn1', 'Mechanical Ground/LConn1', 'autorouting', 'on');
add_line([model '/Fan System'], 'Speed Sensor/RConn1', 'Mechanical Ground/LConn1', 'autorouting', 'on');
add_line([model '/Fan System'], 'Bearing Friction/RConn1', 'Mechanical Ground/LConn1', 'autorouting', 'on');
add_line([model '/Fan System'], 'Imbalance Torque/RConn2', 'Mechanical Ground/LConn1', 'autorouting', 'on');
add_line([model '/Fan System'], 'DC Motor/RConn2', 'Mechanical Ground/LConn1', 'autorouting', 'on');

add_line([model '/Fan System'], 'Voltage Sensor/RConn1', 'Voltage Sensor Converter/LConn1', 'autorouting', 'on');
add_line([model '/Fan System'], 'Current Sensor/RConn1', 'Current Sensor Converter/LConn1', 'autorouting', 'on');
add_line([model '/Fan System'], 'Speed Sensor/RConn2', 'Speed Sensor Converter/LConn1', 'autorouting', 'on');

% Add input and output ports to the Fan System subsystem
add_block('simulink/Ports & Subsystems/In1', [model '/Fan System/Voltage Input']);
add_block('simulink/Ports & Subsystems/Out1', [model '/Fan System/Voltage Output']);
add_block('simulink/Ports & Subsystems/Out1', [model '/Fan System/Current Output']);
add_block('simulink/Ports & Subsystems/Out1', [model '/Fan System/Speed Output']);

% Connect subsystem ports to converters
add_line([model '/Fan System'], 'Voltage Input/1', 'Voltage Converter/1', 'autorouting', 'on');
add_line([model '/Fan System'], 'Voltage Sensor Converter/1', 'Voltage Output/1', 'autorouting', 'on');
add_line([model '/Fan System'], 'Current Sensor Converter/1', 'Current Output/1', 'autorouting', 'on');
add_line([model '/Fan System'], 'Speed Sensor Converter/1', 'Speed Output/1', 'autorouting', 'on');

%% Add blocks outside the subsystem
add_block('simulink/Sources/Constant', [model '/Input Voltage']);
add_block('simulink/Sinks/Scope', [model '/Voltage Scope']);
add_block('simulink/Sinks/Scope', [model '/Current Scope']);
add_block('simulink/Sinks/Scope', [model '/Speed Scope']);
add_block('simulink/Sinks/To Workspace', [model '/Voltage Data']);
add_block('simulink/Sinks/To Workspace', [model '/Current Data']);
add_block('simulink/Sinks/To Workspace', [model '/Speed Data']);
add_block('nesl_utility/Solver Configuration', [model '/Fan System/Solver Configuration']);

% Connect blocks outside the subsystem
add_line(model, 'Input Voltage/1', 'Fan System/1', 'autorouting', 'on');
add_line(model, 'Fan System/1', 'Voltage Scope/1', 'autorouting', 'on');
add_line(model, 'Fan System/2', 'Current Scope/1', 'autorouting', 'on');
add_line(model, 'Fan System/3', 'Speed Scope/1', 'autorouting', 'on');
add_line(model, 'Fan System/1', 'Voltage Data/1', 'autorouting', 'on');
add_line(model, 'Fan System/2', 'Current Data/1', 'autorouting', 'on');
add_line(model, 'Fan System/3', 'Speed Data/1', 'autorouting', 'on');
add_line([model '/Fan System'], 'Solver Configuration/RConn1', 'Mechanical Ground/LConn1', 'autorouting', 'on');

%% Set component parameters
% Motor parameters
Kv = 1 / 6;  % Assuming Kt = 6 Nm/A which was got through trial and error
Ra = 1;  % Low resistance for efficiency
% Mechanical parameters
J = 0.001;  % Low inertia for a light fan
D = 50 / (104.7^2);  % D = Power / Speed^2 (approximation)

set_param([model '/Fan System/Motor Windings R'], 'R', '0.5');  % 0.5 ohm
set_param([model '/Fan System/Motor Windings L'], 'L', '0.001');  % 0.001 H
set_param([model '/Fan System/DC Motor'], 'Kv', num2str(Kv));
set_param([model '/Fan System/DC Motor'], 'Ra', num2str(Ra));
set_param([model '/Fan System/DC Motor'], 'La', '0.001');  % Keep armature inductance low
set_param([model '/Fan System/Fan Blades'], 'inertia', num2str(J));
set_param([model '/Fan System/Air Resistance'], 'D', num2str(D));
set_param([model '/Fan System/Bearing Friction'], 'visc_coef', '0.1');  % 0.1 N*m/(rad/s)
set_param([model '/Fan System/Winding Degradation'], 'Rmin', '0.1');  % 0.1 ohm initial degradation
set_param([model '/Input Voltage'], 'Value', '240');

%% Add a subsystem for vibration generation
add_block('simulink/Ports & Subsystems/Subsystem', [model '/Fan System/Vibration Generator']);
% Remove default input/output ports
delete_line([model '/Fan System/Vibration Generator'], 'In1/1', 'Out1/1');
delete_block([model '/Fan System/Vibration Generator/In1']);
delete_block([model '/Fan System/Vibration Generator/Out1']);

% Add input and output ports to the Vibration Generator subsystem
add_block('simulink/Ports & Subsystems/In1', [model '/Fan System/Vibration Generator/Speed Input']);
add_block('simulink/Ports & Subsystems/Out1', [model '/Fan System/Vibration Generator/Vibration Output']);

%% Speed-Vibration Function
add_block('simulink/User-Defined Functions/MATLAB Function', [model '/Fan System/Vibration Generator/Speed Vibration Function']);
add_block('simulink/Sources/Constant', [model '/Fan System/Vibration Generator/Imbalance']);

% Load the MATLAB function script from the external file
scriptText = fileread('speedVibrationFcn.m');
config = get_param([model '/Fan System/Vibration Generator/Speed Vibration Function'], ...
    "MATLABFunctionConfiguration");
config.FunctionScript = scriptText;
config.UpdateMethod = "Discrete";
config.SampleTime = "0.001";

add_line([model '/Fan System/Vibration Generator'], 'Speed Input/1', 'Speed Vibration Function/1', 'autorouting', 'on');
add_line([model '/Fan System/Vibration Generator'], 'Imbalance/1', 'Speed Vibration Function/2', 'autorouting', 'on');
set_param([model '/Fan System/Vibration Generator/Imbalance'], 'Value', '0.1');

% Set the block description
config.Description = 'Generate speed-dependent vibration';

%% Add natural frequency vibration
add_block('simulink/Sources/Sine Wave', [model '/Fan System/Vibration Generator/Natural Frequency']);
set_param([model '/Fan System/Vibration Generator/Natural Frequency'], 'Frequency', '50'); % Adjust as needed
set_param([model '/Fan System/Vibration Generator/Natural Frequency'], 'Amplitude', '0.05'); % Adjust as needed

%% Add random vibration
add_block('simulink/Sources/Band-Limited White Noise', [model '/Fan System/Vibration Generator/Random Vibration']);
set_param([model '/Fan System/Vibration Generator/Random Vibration'], 'Cov', '0.01'); % Adjust as needed

%% Add sum block to combine vibrations
add_block('simulink/Math Operations/Sum', [model '/Fan System/Vibration Generator/Total Vibration']);
set_param([model '/Fan System/Vibration Generator/Total Vibration'], 'Inputs', '+++');

% Connect vibration components to sum block
add_line([model '/Fan System/Vibration Generator'], 'Speed Vibration Function/1', 'Total Vibration/1', 'autorouting', 'on');
add_line([model '/Fan System/Vibration Generator'], 'Natural Frequency/1', 'Total Vibration/2', 'autorouting', 'on');
add_line([model '/Fan System/Vibration Generator'], 'Random Vibration/1', 'Total Vibration/3', 'autorouting', 'on');
add_line([model '/Fan System/Vibration Generator'], 'Total Vibration/1', 'Vibration Output/1', 'autorouting', 'on');

%% Add output port for vibration in Fan System subsystem
add_block('simulink/Ports & Subsystems/Out1', [model '/Fan System/Vibration Output']);

% Connect Speed Sensor to Vibration Generator
add_line([model '/Fan System'], 'Speed Sensor Converter/1', 'Vibration Generator/1', 'autorouting', 'on');
add_line([model '/Fan System'], 'Vibration Generator/1', 'Vibration Output/1', 'autorouting', 'on');

% Add scope and workspace output for vibration data
add_block('simulink/Sinks/Scope', [model '/Vibration Scope']);
add_block('simulink/Sinks/To Workspace', [model '/Vibration Data']);

% Connect vibration output to scope and workspace
add_line(model, 'Fan System/4', 'Vibration Scope/1', 'autorouting', 'on');
add_line(model, 'Fan System/4', 'Vibration Data/1', 'autorouting', 'on');

% Configure vibration data workspace output
set_param([model '/Vibration Data'], 'VariableName', 'vibration');

%% RPM Display
add_block('simulink/Math Operations/Gain', [model '/RPM Conversion']);
set_param([model '/RPM Conversion'], 'Gain', '60/(2*pi)');
add_block('simulink/Sinks/Display', [model '/RPM Display']);
add_line(model, 'Fan System/3', 'RPM Conversion/1', 'autorouting', 'on');
add_line(model, 'RPM Conversion/1', 'RPM Display/1', 'autorouting', 'on');
add_block('simulink/Sinks/Scope', [model '/RPM Scope']);
add_line(model, 'RPM Conversion/1', 'RPM Scope/1', 'autorouting', 'on');

%% TinyML Integration
add_block('simulink/User-Defined Functions/MATLAB Function', [model '/TinyML']);
add_line(model, 'Fan System/4', 'TinyML/1', 'autorouting', 'on');

% Load the MATLAB function script from the external file
config = get_param([model '/TinyML'], "MATLABFunctionConfiguration");
tinyMLFcn = fileread('tinyMLFcn.m');
config.FunctionScript = tinyMLFcn;
config.UpdateMethod = "Discrete";
config.SampleTime = "0.001";

% Set the block description
config.Description = 'TinyML Inference Block';

%% Set simulation parameters
set_param(model, 'StopTime', '30');  % Extend simulation time to 30 seconds
set_param(model, 'Solver', 'ode23t');  % Choose an efficient continuous solver
set_param(model, 'MaxStep', '0.001');  % Increase MaxStep to reduce computational load
set_param(model, 'RelTol', '1e-4');  % Adjust relative tolerance for performance
set_param(model, 'AbsTol', '1e-4');  % Adjust absolute tolerance

% Configure To Workspace blocks
set_param([model '/Voltage Data'], 'SampleTime', '0.001');
set_param([model '/Current Data'], 'SampleTime', '0.001');
set_param([model '/Speed Data'], 'SampleTime', '0.001');
set_param([model '/Vibration Data'], 'SampleTime', '0.001');

% Use Parallel Computing Toolbox
% delete(gcp('nocreate'))
% parpool('local', 4);  % Adjust the number of workers based on your system

% Set the simulation target language to C++
set_param(model, 'SimTargetLang', 'C++');

% Configure To Workspace blocks
set_param([model '/Voltage Data'], 'VariableName', 'voltage');
set_param([model '/Current Data'], 'VariableName', 'current');
set_param([model '/Speed Data'], 'VariableName', 'speed');

% Arrange blocks
Simulink.BlockDiagram.arrangeSystem([model '/Fan System/Vibration Generator']);
Simulink.BlockDiagram.arrangeSystem([model '/Fan System']);
Simulink.BlockDiagram.arrangeSystem(model);

%% Save the model
modelsDir = fullfile(fileparts(fileparts(mfilename('fullpath'))), 'models');

save_system(model, fullfile(modelsDir, [model, '.slx']));