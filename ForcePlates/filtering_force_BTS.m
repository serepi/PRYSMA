function fiteredData = filtering_force_BTS(weight, height, platParams, platData)

    % FOR TESTING
    if nargin < 3
       filePath = "C:\Users\serep\OneDrive - Università di Pavia\Documents\MATLAB\PRYSMA\Data\day4_Plates";
       fileName = "t21.tdf";
       target_time = 180; % in seconds, duration of the acquisition
       [platParams, platData] = force_BTS(filePath, fileName, target_time);
    end

    %%-----------------------------------------------------------%%
    Fs = platParams.Fs;
    n_plat = platParams.n_plat;
    time   = platParams.time;
    F_plat = platData(:,3:5,:);
    T_plat = platData(:,6,:);

    %% Filtering
    % (Khalid et al., 2015)
    fl = 12;        % [Hz] low pass  cut-freq
    % Butterworth filter
    [b,a] = butter(2,fl/(Fs/2),"low");
    F_plat_filt = filter(b,a,F_plat);
    T_plat_filt = filter(b,a,T_plat);

    %% Normalisation
    force_norm = F_plat./(weight*9.81);
    torque_norm = T_plat./(weight*9.81*height);

    figure('Name',"t Fz CoP platforms");
    for i = 1:2%n_plat 
        subplot(1,2,i)
        title(['Platform',int2str(i)]),hold on
        plot(time,F_plat_filt(:,end,i))
        plot(time,F_plat(:,end,i))
        xlabel('time'), ylabel('Force filtered')
    end
    figure('Name',"t Fz CoP platforms");
    for i = 1:2%n_plat 
        subplot(1,2,i)
        title(['Platform',int2str(i)]),hold on
        plot(time,force_norm(:,end,i))
        xlabel('time'), ylabel('Force norm')
    end
    fiteredData = [];
end