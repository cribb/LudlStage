function stage=stage_move_Ludl(stage, target_pos)
% STAGE_MOVE_LUDL moves the stage to target Ludl coordinate


% instrfind returns the instrument object array
% objects = instrfind
% each entry includes the type, status, and name as follows
% Index:    Type:     Status:   Name:
% 1         serial    closed    Serial-COM4
%
% objects can be cleared from memory with
% delete(objects)
% try

    % Target position needs to be a 64 bit integer
    target_pos = int64(target_pos);
    
    % Get current poistion
    stage = stage_get_pos_Ludl(stage);
    Initial_Pos = stage.Pos;
    % Start moving to the desired position  
    command_str_speed = ['SPEED', ...
                         ' x=', num2str(stage.speed), ...
                         ' y=', num2str(stage.speed)];
    stage_send_com_Ludl (stage.handle, command_str_speed);
    command_str_accel = ['ACCEL',...
                         ' x=', num2str(stage.accel),...
                         ' y=', num2str(stage.accel)];
    stage_send_com_Ludl (stage.handle, command_str_accel);           
    stage_send_com_Ludl (stage.handle, 'SPEED X Y');   
    stage_send_com_Ludl (stage.handle, 'ACCEL X Y');
    command_str = ['move',...
                   ' x=', num2str(target_pos(1)),...
                   ' y=', num2str(target_pos(2))];
    stage_send_com_Ludl(stage.handle, command_str);
    
    while stage_check_busy_Ludl(stage.handle)
        stage = stage_get_pos_Ludl(stage);
        current_pos = stage.Pos;
        
        pause(0.5);
        
        distance_traveled = pdist2( double(Initial_Pos), double(current_pos), 'euclidean');
        distance_total    = pdist2( double(Initial_Pos), double(target_pos), 'euclidean');
        
%         distance_traveled = sqrt( (double(Initial_Pos(1)) - double(current_pos(1)))^2 + ...
%                                   (double(Initial_Pos(2)) - double(current_pos(2)))^2);
%         distance_total =    sqrt( (double(Initial_Pos(1)) - double(target_pos(1)))^2 + ...
%                                   (double(Initial_Pos(2)) - double(target_pos(2)))^2);
                              
%         waitbar(distance_traveled / distance_total);
%         drawnow;
    end    

%     
%     % If communications to stage was not open to start, then close.
%     if h_stage_close == 1
%         stage.status = stage_close(stage.handle);
%     end
    
% catch ME
%     error_show(ME);
% end

end