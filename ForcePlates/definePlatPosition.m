% 07/01/2014
function platPosition_ordered = definePlatPosition(n_plat,M,N,plat_order)
    % N = biggest size = 60 cm
    % M = smallest siz = 40 cm
    % plat_order = is a vector containing the order of the platform on the ground, from left to right, from top to bottom
    % example, if we have 4 plat and the vector is [1 2 3 4], this means
    %  top left plat = number 1; top right plat = number 2
    %  bottom left   = number 3; bottom right   = number 4

    % Output: cellarray of matrices. Lenght of the vector is = n_plat. 
    % The matrice contains the coordinates of each of the four vertex. 
    % The size of the matrix is 3x4. One row for each coordinate x,y,z; 
    % one column for each vertex v1, v2, v3, v4 
    %%=======================================================%%
    % INITIALISING
    platPosition = cell(1, n_plat);
    platPosition_ordered = cell(1, n_plat);
    for i = 1:n_plat
        platPosition{i} = zeros(3,4);
        platPosition_ordered{i} = zeros(3,4);
    end
    %%=======================================================%%
    % First platform: define position of the four vertices
    V_1X = 0;
    V_1Y = 0;
    V_3X = N/100; % N = biggest size = 60 cm
    V_3Y = M/100; % M = smallest siz = 40 cm
  
    % Knowing the position of the first plat we can know the position
    % of every plat and their vertices
    i=1;
    for row = 1:5
        k = row - 1;
        v_1y = V_3Y*k;
        v_3y = v_1y + V_3Y;

        for group = 1:2
            if i > n_plat % check if already checked all platforms
                break;
            end

            % Define v_1x and v_3x depending on LEFT or RIGHT group
            if group == 1 %LEFT
                v_1x = V_1X;
                v_3x = V_3X;
            else         % RIGHT
                v_1x = V_3X;
                v_3x = V_3X*2;
            end

            % define all remining vertices accordingly
            v_2x = v_1x;
            v_4y = v_1y;
            v_4x = v_3x;
            v_2y = v_3y;

            pp = [v_1x, v_2x, v_3x, v_4x; ...
                  v_1y, v_2y, v_3y, v_4y; ...
                  0   ,    0,    0,    0];
            platPosition{i} = pp;
            i = i + 1;
        end
    end

    %%================================================%%
    % Respect platform order on the ground
    for i = 1:n_plat
        j = plat_order(i);
        platPosition_ordered{i} = platPosition{j};
    end  

    %%%% ---------------- check Vertex Position in a plot -----------------%%%%
    colorList = {[0 1 1],[0.4940 0.1840 0.5560],[1 0 1],[0 0.4470 0.7410],[0.8500 0.3250 0.0980],[0.9290 0.6940 0.1250],[1 0 0],[0.6350 0.0780 0.1840],[0.4660 0.6740 0.1880],[0 1 0]};
    figure()
    for i = 1:n_plat
        % x and y of the four verteces
        v_x = zeros(5,1);
        v_y = zeros(5,1);
        for j = 1:4
            v_x(j) = platPosition{i}(1,j);
            v_y(j) = platPosition{i}(2,j);
        end
        v_x(5) = v_x(1);
        v_y(5) = v_y(1);
        % put it on the same plot
        plot(v_x,v_y,'*-','Color',colorList{i}),hold on
    end
    title('Platform map'),hold on
    ax = gca;
    ax.XAxisLocation = 'top';
    ax.YDir = "reverse";
%     d = 0.5;
%     ax.YLim = [-N/2-d,  N/2+d]; % N = biggest size = 60 cm
%     ax.XLim = [-M/2-d,  M/2+d]; % M = smallest siz = 40 cm
    xlabel('y CoP [cm]'), ylabel('x CoP [cm]')
    axis equal
end