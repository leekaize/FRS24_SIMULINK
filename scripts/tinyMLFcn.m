function [fault_prediction, extracted_features] = tinyMLFcn(vibration_sample)
    persistent tfliteModel buffer window_size step_size sample_count Fs last_prediction last_features
    
    if isempty(tfliteModel)
        tfliteModel = loadTFLiteModel('fan_fault_detection.tflite');
        % Define a fixed size for last_prediction based on the model output
        last_prediction = zeros(15, 1, 'single'); % Adjust based on your model's output size
        last_features = zeros(1, 6, 'single'); % Ensure 6 features
        tfliteModel.Mean = 0;
        tfliteModel.StandardDeviation = 1;
    end
    
    if isempty(buffer)
        buffer = zeros(128, 1, 'single');
        window_size = 128;
        step_size = 64;
        sample_count = 0;
        Fs = 1000; % Sampling rate of 1000Hz
    end
    
    % Update buffer
    buffer = [buffer(2:end); single(vibration_sample)];
    sample_count = sample_count + 1;
    
    if mod(sample_count, step_size) == 0
        % Frequency domain features
        freq_data = abs(fft(buffer));
        freq_data = freq_data(1:window_size/2+1); % Only positive frequencies
        
        % Frequency array
        freq_resolution = Fs / window_size;
        freq_array = (0:window_size/2) * freq_resolution;
        
        % Find top five peak frequencies, excluding 0 Hz
        [~, peak_indices] = sort(freq_data(2:end), 'descend');
        top_five_indices = peak_indices(1:5) + 1; % +1 because we excluded 0 Hz
        
        % Ensure we have at least 4 peaks for Freq1-Freq4
        if length(top_five_indices) < 4
            top_five_indices = [top_five_indices; zeros(4 - length(top_five_indices), 1)];
        end
        
        top_five_freqs = freq_array(top_five_indices);
        
        % Compute peak-to-peak amplitude
        peak_to_peak_amplitude = max(buffer) - min(buffer);
        
        % Calculate the central frequency using spectral moments
        P1 = freq_data(1:window_size/2+1); % FFT magnitudes (already in P1 format)
        m0 = sum(P1.^2);
        m1 = sum(freq_array .* (P1.^2)) / m0; % First spectral moment
        m2 = sum((freq_array.^2) .* (P1.^2)) / m0; % Second spectral moment
        central_freq = sqrt(m2); % Central frequency
        central_freq = mean(central_freq);
        
        % Combine features in the desired order
        features = [peak_to_peak_amplitude, top_five_freqs(1), top_five_freqs(2), top_five_freqs(4), top_five_freqs(3), central_freq];
        
        % Ensure features are in the correct shape (6x1 column vector)
        features = single(features(:));
        
        % Model Inference
        last_prediction = predict(tfliteModel, features);
        % Ensure last_prediction has fixed size (if necessary)
        if size(last_prediction, 1) ~= 15
            error('Model output size mismatch');
        end
        last_features = features';
    end
    
    % Always output the last valid prediction and features
    fault_prediction = last_prediction; % Ensure fixed size or specify variable size if necessary
    extracted_features = last_features;
end
