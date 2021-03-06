function stage = stage_set_origin_Ludl(stage)
% STAGE_SET_ORIGIN_LUDL sets the stage origin to  current stage coordinates
%
%  ##########################################################################
%% ###################### MOVE STAGE SEQUENCE ###############################
%  ##########################################################################

try
    
    % If communications to stage is not open to start, then open.
    % Also prepare to close
    arriveHome = 0;
    
    % Speed to the top-left corner
    success = stage_send_com_Ludl(stage.handle, 'SPEED X=100000 Y=100000'); %#ok<*NASGU>
    success = stage_send_com_Ludl(stage.handle, 'ACCEL X=1 Y=1');
    success = stage_send_com_Ludl(stage.handle, 'HOME X Y');
    
    % Wait til the stage gets to the top-left corner
    while stage_check_busy_Ludl(stage.handle)
        pause(.5)
        disp('Not there yet 1.');
    end
    % double check stage arrive home
    while arriveHome == 0
        success = stage_send_com_Ludl(stage.handle, 'HERE X=0 Y=0');
        success = stage_send_com_Ludl(stage.handle, 'MOVE X=-5000000 Y=-1000000');
        while stage_check_busy_Ludl(stage.handle)
            pause(.5)
            disp('Not there yet 2.');
        end
        success = stage_send_com_Ludl(stage.handle, 'where x y');
        temp = textscan(success, '%s %d %d');
        Pos = int64([temp{2}, temp{3}]);
        if (Pos(1) >-100 && Pos(2)>-100)
            arriveHome = 1;
        end
    end
    

    % Set the top-left corner to be the origin
    success = stage_send_com_Ludl(stage.handle, 'HERE X=0 Y=0');

    % For better precision, slow it down, move it away, and go back home
    success = stage_send_com_Ludl(stage.handle, 'SPEED X=100 Y=100');
    success = stage_send_com_Ludl(stage.handle, 'ACCEL X=255 Y=255');
    success = stage_send_com_Ludl(stage.handle, 'MOVE X=100 Y=100');
    success = stage_send_com_Ludl(stage.handle, 'MOVE X=-25 Y=-25');
    while stage_check_busy_Ludl(stage.handle)
        pause(.5)
        disp('Not there yet 3.');
    end

    % Reset the top-left corner to be the origin
    success = stage_send_com_Ludl(stage.handle, 'HERE X=0 Y=0');

%     % If communications to stage was not open to start, then close.
%     if h_stage_close == 1
%         stage.status=stage_close(stage.handle);
%     end
%     stage=stage_move_Ludl(stage,[50000,50000]);    
% %  ##########################################################################
%% ###################### MOVE STAGE SEQUENCE ###############################
%  ##########################################################################
%     success=send_com (S, 'SPEED X=50000 Y=50000');
%     success=send_com (S, 'SPEED X Y');
%     success=send_com (S, 'ACCEL X=100 Y=100');
%     success=send_com (S, 'ACCEL X Y');
%     command_str=char(strcat('move',' x=',num2str(Pos(1)),...
%         ' y=',num2str(Pos(2))));
%     success=send_com (S, command_str);

catch ME
    error_show(ME);
end

end

