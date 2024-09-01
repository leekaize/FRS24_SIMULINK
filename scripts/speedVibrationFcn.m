function vibration = speedVibrationFcn(speed, imbalance, loose_blade)
    persistent t
    if isempty(t)
        t = 0;
    else
        t = t + 0.001; % Assuming a fixed step size of 0.001s
    end

    % Base frequency based on rotational speed
    freq = speed / (2 * pi);
    
    % Vibration due to imbalance
    imbalance_vibration = imbalance * sin(2 * pi * freq * t);
    
    % Vibration due to loose blade
    if loose_blade > 0
        % Loose blade typically introduces harmonics and random noise
        loose_blade_vibration = loose_blade * (0.5 * sin(2 * pi * 2 * freq * t) + ...
                                               0.3 * sin(2 * pi * 3 * freq * t) + ...
                                               0.2 * sin(2 * pi * 4 * freq * t) + ...
                                               0.1 * randn());
    else
        loose_blade_vibration = 0;
    end
    
    % Combine vibrations
    vibration = imbalance_vibration + loose_blade_vibration;
end
