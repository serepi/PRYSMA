function force_T = force_BTS_plot(filePath, fileName, target_time)

% FOR TESTING
if nargin < 1
    %filePath = "C:\Users\serep\OneDrive - Università di Pavia\Documents\MATLAB\PRYSMA\Data";
    filePath = "C:\Users\serep\OneDrive - Università di Pavia\Documents\MATLAB\PRYSMA\Data\day4_Plates";
    fileName = "t21.tdf";
    target_time = 180; % in seconds, duration of the acquisition
end
%%============================================================================
% BTS P6000
[startTime, Fs, PlatMap, labels, platData] = tdfReadDataPlat(fileName);
[~, platParams] = tdfReadPlatCalParams(fileName); 
% [FREQUENCY,D,R,T,LABELS,TRACKS] = tdfReadForce3D (fileName);
% [FREQUENCYY,CAMMAP,PLATMAP,PLATINFO,PLATFEATURES] = tdfReadData2D4PlatCal(fileName);

target_time  = size(platData, 2)/Fs;
timestamps = linspace(0,target_time,Fs*target_time);
samples = length(timestamps);

if ~isempty(platData)

    %Platforms dimensions
    M = platParams(1).Size(1);            % m, platform height (smallest side)
    N = platParams(1).Size(2);            % m, platform width  (biggest side)
    n_plat = size(platforms_data,3);      
    
    %% Permute the matrix dimentions
    %   New matrix format:
    %     rows = samples
    %     columns = variables (Px Py Fx Fy Fz Tz) [m,m,N,N,N,N.m]
    %     depth = platforms (2 in total) [0 -> ground; 1 -> box]
    platforms_data = permute(platData, [2,3,1]);
    
    %%  Plot CoP and Forces

    %%%%%% plot versione 1
    % for i = 1:n_plat
    %     f(i)=figure('Name',string(['CoP platform',i]));
    %     subplot(1,2,1)
    %     title('Platform'),hold on
    %     plot(platforms_data(:,1,i),platforms_data(:,2,i))
    % end

    % %%%%%%% plot versione 2
    figure('Name',string(['x y CoP platforms']));
    for i = 1:n_plat 
        subplot(1,n_plat,i)
        title(['Platform',int2str(i)]),hold on
        plot(platforms_data(:,1,i),platforms_data(:,2,i))
        xlabel('x CoP'), ylabel('y CoP')
    end
    figure('Name',string(['t x CoP platforms']));
    for i = 1:n_plat 
        subplot(1,n_plat,i)
        title(['Platform',int2str(i)]),hold on
        plot(timestamps,platforms_data(:,1,i))
        xlabel('time'), ylabel('x CoP')
    end
    figure('Name',string(['t y CoP platforms']));
    for i = 1:n_plat 
        subplot(1,n_plat,i)
        title(['Platform',int2str(i)]),hold on
        plot(timestamps,platforms_data(:,2,i))
        xlabel('time'), ylabel('y CoP')
    end
    figure('Name',string(['t Fz CoP platforms']));
    for i = 1:n_plat 
        subplot(1,n_plat,i)
        title(['Platform',int2str(i)]),hold on
        plot(timestamps,platforms_data(:,5,i))
        xlabel('time'), ylabel('Force')
    end
    

%%%% ---------------- check Vertex Position -----------------%%%%
    colorList = {[0 1 1],[0.4940 0.1840 0.5560],[1 0 1],[0 0.4470 0.7410],[0.8500 0.3250 0.0980],[0.9290 0.6940 0.1250],[1 0 0],[0.6350 0.0780 0.1840],[0.4660 0.6740 0.1880],[0 1 0]};
    figure()
    for i = 1:n_plat
        if i == 2
            continue
        end
        % x and y of the four verteces
        v_x = zeros(4,1);
        v_y = zeros(4,1);
        for j = 1:4
            v_x(j) = platParams(i).Position(1,j);
            v_y(j) = platParams(i).Position(3,j);
        end
        % put it on the same plot
        scatter(100*v_x,100*v_y,'*','Color',colorList{i}),hold on
    end
    title('Platform map'),hold on
    ax = gca;
    ax.XAxisLocation = 'top';
    d = 5;
    ax.YLim = [-N/2-d,  N/2+d]; % N = biggest size = 60 cm
    ax.XLim = [-M/2-d,  M/2+d]; % M = smallest siz = 40 cm
    xlabel('y CoP [cm]'), ylabel('x CoP [cm]')
    axis equal

    % check the size of the file of interest
    % % % s_current = size(platforms, 1);
    % % % if s_current < samples
    % % %     final_matrix = interp1(linspace(0,1,s_current),platforms,...
    % % %                            linspace(0,1,samples));          
    % % % else
    % % %     final_matrix = platforms(1:samples,:);
    % % % end
    
    % Create final output
    % % % forceplat_names = {'time', 'CoPx_feet', 'CoPy_feet', 'Fx_feet', 'Fy_feet', ...
    % % %      'Fz_feet', 'Tz_feet', 'CoPx_seat', 'CoPy_seat', 'Fx_seat', 'Fy_seat', ...
    % % %      'Fz_seat', 'Tz_seat'};
    % % % 
    % % % % data from the platforms
    % % % forceplat_matrix = zeros(samples,size(forceplat_names,2));
    % % % forceplat_matrix(:,1) = timestamps';
    % % % forceplat_matrix(:,2:end) = final_matrix;
    % % % % config table to have variable names
    % % % force_T = array2table(forceplat_matrix, 'VariableNames', forceplat_names);
else
    force_T = [];
end
end