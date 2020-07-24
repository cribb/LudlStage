function stage = stage_get_pos_Ludl(stage)
% STAGE_GET_POS_LUDL returns the position of the stage in Ludl coordinates


try
    
    stage.Pos = 0;

    % Get the x,y position
    % command_str = 'where x y';
    command_str = sprintf('where x y');
    str_current = stage_send_com_Ludl(stage.handle, command_str);
    
    k = 1;
    while numel(str_current) == 0 && (k < 100)
        pause(0.1);
        str_current = stage_send_com_Ludl(stage.handle, command_str);
        k = k + 1;
    end
    
    if k == 100 
        k/0; %#ok<VUNUS>
    end
    
    if str_current(2) ~= 'A'
        'A'/0; %#ok<VUNUS>
    end
    
    temp = textscan(str_current, '%s %d %d');
    stage.Pos = int64([temp{2}, temp{3}]);
    

catch ME
    error_show(ME)
end
end