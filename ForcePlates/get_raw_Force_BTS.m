function force_T = get_raw_Force_BTS(current_filename, target_time)

% BTS P6000

[startTime, Fs, PlatMap, labels, platData] = tdfReadDataPlat(current_filename);

% target_time = 180; % in seconds, duration of the acquisition
timestamps = linspace(0,target_time,Fs*target_time);
samples = length(timestamps);

if ~isempty(platData)
    % permute the matrix 
    % New matrix format:
    %   rows = samples
    %   columns = variables (Px Py Fx Fy Fz Tz) [m,m,N,N,N,N.m]
    %   depth = platforms (2 in total) [0 -> ground; 1 -> box]
    platforms_data = permute(platData, [2,3,1]);
    
    % Separate them
    plat_feet = platforms_data(:,:,1);
    plat_seat = platforms_data(:,:,2);
    % Merge them in a unique big matrix, six column for each platform
    platforms = [plat_feet, plat_seat];
    
    % check the size of the file of interest
    s_current = size(platforms, 1);
    if s_current < samples
        final_matrix = interp1(linspace(0,1,s_current),platforms,...
                               linspace(0,1,samples));          
    else
        final_matrix = platforms(1:samples,:);
    end
    
    % Create final output
    forceplat_names = {'time', 'CoPx_feet', 'CoPy_feet', 'Fx_feet', 'Fy_feet', ...
         'Fz_feet', 'Tz_feet', 'CoPx_seat', 'CoPy_seat', 'Fx_seat', 'Fy_seat', ...
         'Fz_seat', 'Tz_seat'};
    
    % data from the platforms
    forceplat_matrix = zeros(samples,size(forceplat_names,2));
    forceplat_matrix(:,1) = timestamps';
    forceplat_matrix(:,2:end) = final_matrix;
    % config table to have variable names
    force_T = array2table(forceplat_matrix, 'VariableNames', forceplat_names);
else
    force_T = [];
end
end