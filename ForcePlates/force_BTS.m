function [platParams, platData] = force_BTS(filePath, fileName, target_time)

% FOR TESTING
if nargin < 1
    %filePath = "C:\Users\serep\OneDrive - Università di Pavia\Documents\MATLAB\PRYSMA\Data";
    filePath = "C:\Users\serep\OneDrive - Università di Pavia\Documents\MATLAB\PRYSMA\Data\day4_Plates";
    fileName = "t21.tdf";
    target_time = 180; % in seconds, duration of the acquisition
end
%%============================================================================
% BTS P6000
[startTime, Fs, PlatMap, labels, BTS_platData] = tdfReadDataPlat(fileName);
[~, BTS_platParams] = tdfReadPlatCalParams(fileName); 
% [FREQUENCY,D,R,T,LABELS,TRACKS] = tdfReadForce3D (fileName);
% [FREQUENCYY,CAMMAP,PLATMAP,PLATINFO,PLATFEATURES] = tdfReadData2D4PlatCal(fileName);

target_time  = size(BTS_platData, 2)/Fs;
timestamps = linspace(0,target_time,Fs*target_time);
samples = length(timestamps);

if ~isempty(BTS_platData)

    %Platforms dimensions
    M = BTS_platParams(1).Size(1);            % m, platform height (smallest side)
    N = BTS_platParams(1).Size(2);            % m, platform width  (biggest side)
    n_plat = size(BTS_platData,3);      
    
    %% Permute the matrix dimentions
    %   New matrix format:
    %     rows = samples
    %     columns = variables (Px Py Fx Fy Fz Tz) [m,m,N,N,N,N.m]
    %     depth = platforms (2 in total) [0 -> ground; 1 -> box]
    platforms_data = permute(BTS_platData, [2,3,1]);
    
    %%  Plot CoP and Forces

    %%%%%% plot versione 1
    % for i = 1:n_plat
    %     f(i)=figure('Name',string(['CoP platform',i]));
    %     subplot(1,2,1)
    %     title('Platform'),hold on
    %     plot(platforms_data(:,1,i),platforms_data(:,2,i))
    % end

    % %%%%%%% plot versione 2
%     figure('Name',"x y CoP platforms");
%     for i = 1:n_plat 
%         subplot(1,n_plat,i)
%         title(['Platform',int2str(i)]),hold on
%         plot(platforms_data(:,1,i),platforms_data(:,2,i))
%         xlabel('x CoP'), ylabel('y CoP')
%     end
%     figure('Name',"t x CoP platforms");
%     for i = 1:n_plat 
%         subplot(1,n_plat,i)
%         title(['Platform',int2str(i)]),hold on
%         plot(timestamps,platforms_data(:,1,i))
%         xlabel('time'), ylabel('x CoP')
%     end
%     figure('Name',"t y CoP platforms");
%     for i = 1:n_plat 
%         subplot(1,n_plat,i)
%         title(['Platform',int2str(i)]),hold on
%         plot(timestamps,platforms_data(:,2,i))
%         xlabel('time'), ylabel('y CoP')
%     end
    figure('Name',"t Fz CoP platforms");
    for i = 1:n_plat 
        subplot(1,n_plat,i)
        title(['Platform',int2str(i)]),hold on
        plot(timestamps,platforms_data(:,5,i))
        xlabel('time'), ylabel('Force')
    end
    %%=====================================================================%%
    %% Fix the system of reference 
    % Origin = upper left corner of first platform 
    % We want to have all the data in the same system 

    %%-------- Import platform map------------------------------------%%

    %Vertices position in saved in platPosition


    % looking for the upper left vertex -> first column
% %     for i = 1:n_plat
% %         x_origin_vert(i) = platPosition_ordered{i}(1,1);
% %         y_origin_vert(i) = platPosition_ordered{i}(2,1);
% %         % change ref. system
% %         tmp_x = platforms_data(:,1,i) + x_origin_vert(i);
% %         tmp_y = platforms_data(:,2,i) + y_origin_vert(i);
% % 
% %         platforms_data(:,1:2,i) = [tmp_x, tmp_y];
% %     end
  

    %Plot to check the result
    % for i = 1:n_plat
    %     figure(f(i))
    %     subplot(1,2,2)
    %     title('Platform new syst'),hold on
    %     plot(platforms_data(:,1,i),platforms_data(:,2,i))
    % end
    



    % check the size of the file of interest
    % % % s_current = size(platforms, 1);
    % % % if s_current < samples
    % % %     final_matrix = interp1(linspace(0,1,s_current),platforms,...
    % % %                            linspace(0,1,samples));          
    % % % else
    % % %     final_matrix = platforms(1:samples,:);
    % % % end
    
    %% Create final output
    platData = platforms_data;
    platParams.names = { 'CoPx', 'CoPy', 'Fx', 'Fy', 'Fz', 'Tz'};
    platParams.time  = timestamps';
    platParams.Fs    = Fs;
    platParams.M     = M;
    platParams.N     = N;
    platParams.n_plat= n_plat;    
   
else
    platData = [];
    platParams = [];
end
end