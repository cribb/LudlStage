function ST_answer = stage_send_com_Ludl (h, CommandStr)
% STAGE_SEND_COM_LUDL sends command to Ludl stage
%
% This function sends commands to the stage. The opened serial port S
% is passed as the first argument. The second argument is the string of
% the command

% Check and see if h is a struct with a handle member
if isstruct(h) && isfield(h, 'handle')
    h = h.handle;
end

if ~isa(h, 'serial')
    error('First input needs to be a handle to the serial device.');
end

try
        
    % Write the command to the stage controller
    for k = 1:size(CommandStr, 2)
        fwrite(h, CommandStr(k));
    end
    
    % Send the termination character (13) to the stage controller
    fwrite(h,13);
    
    % Read the response from the stage controller
    % The response of the stage to 'STATUS' doesn't have the terminator.
    if strcmp(CommandStr,'STATUS')
        ST_answer = fscanf(h,'%s',1);
    else
        ST_answer = fgetl(h);
    end
    
    % These are the error messages that can come from the stage
    if strcmp(':N -1',ST_answer) 
        stage_log('Unknown command');
        ST_answer = -1;
    end
    if strcmp(':N -2',ST_answer) 
        stage_log('Illegal point type or axis, or module not installed');
%         errordlg('Illegal point type or axis, or module not installed!','Stage Error');
        ST_answer = -1;
    end
    if strcmp(':N -3',ST_answer) 
        stage_log('Not enough parameters (e.g. move r=)');
%         errordlg('Not enough parameters (e.g. move r=)!','Stage Error');
        ST_answer = -1;
    end
    if strcmp(':N -4',ST_answer) 
        stage_log('Parameter out of range');
%         errordlg('Parameter out of range!','Stage Error');
        ST_answer = -1;
    end
    if strcmp(':N -21',ST_answer) 
        stage_log('Process aborted by HALT command');
%         errordlg('Process aborted by HALT command!','Stage Error');
        ST_answer = -1;
    end
    
catch
    stage_log('Error in Ludl: stage_send_com (S, CommandStr)');
%         errordlg('Unable to send a command to the stage!','Stage Error');
    ST_answer = -1;
end
end