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

% try
        
    % Write the command to the stage controller
    for k = 1:size(CommandStr, 2)
        fwrite(h, CommandStr(k));
    end
    
    % Send the termination character (13) to the stage controller
    fwrite(h, 13);
    
    % Read the response from the stage controller
    % The response of the stage to 'STATUS' doesn't have the terminator.
    if strcmp(CommandStr,'STATUS')
        ST_answer = fscanf(h,'%s',1);
    else
        ST_answer = fgetl(h);
    end
    
    if contains(ST_answer, ':N')
        ST_answer = process_error_code(ST_answer);
    end
    
% catch
%     stage_log('Error in Ludl: stage_send_com (S, CommandStr)');
%     ST_answer = -1;
% end
return


function ST_answer = process_error_code(ST_answer)
% These are the error messages that can come from the stage. They come
% from the stage as a negative number after the string ":N", e.g. ":N -3".
% This extracts the code and drops the minus sign.
ErrCode = regexpi(ST_answer, '\:N\s*\-(\d*)', 'tokens');
ErrCode = (ErrCode{1}{1});
    
    switch ErrCode
        case '1'
            stage_log('Unknown command');
            ST_answer = -1;
        case '2'
            stage_log('Illegal point type or axis, or module not installed');
            ST_answer = -1;
        case '3'
            stage_log('Not enough parameters (e.g. move r=)');
            ST_answer = -1;
        case '4'    
            stage_log('Parameter out of range');
            ST_answer = -1;
        case '21'
            stage_log('Process aborted by HALT command');
            ST_answer = -1;
    end
    
    return