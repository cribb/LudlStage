function status = stage_close(S)
% STAGE_CLOSE closes the connection to the Ludl stage

% This function closes the serial port of the stage. Reference to the serial 
% port is passed to it as the object/structure 'S' with field 'handle.'
    
    fclose(S.handle);
    delete(S.handle);
    clear S;
    status=0;
end