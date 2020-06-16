function status=stage_close(S)

% STAGE_CLOSE closes the connection to the stage

    %--------------------------------------------------------------------------
    % This function closes the serial port of the stage. Reference to the serial 
    % port is passed to it as the argument S.
    %--------------------------------------------------------------------------
    fclose(S);
    delete(S);
    clear S;
    status=0;
end