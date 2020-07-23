cont_text = 'Press any key to continue.';

ludl = stage_open_Ludl();
assert(ludl.status == 1,'Could not open conenction to stage.')
disp('Connection to stage has been opened.')
disp(cont_text);
pause;

pos = stage_get_pos_Ludl(ludl);
disp('Current position:')
disp(pos.Pos)
pause(0.5)

disp('Now moving very close to the location:')
randnum = randi([-1000,1000]);
disp([pos.Pos(1)+randnum pos.Pos(2)+randnum])
stage_move_Ludl(ludl,[pos.Pos(1)+randnum pos.Pos(2)+randnum]);
pos = stage_get_pos_Ludl(ludl);
disp('Current position:')
disp(pos.Pos)
disp(cont_text)
pause;

status = stage_close(ludl);
assert(status == 1,'Could not close stage.')
disp('Connection to the stage has been closed.')
disp('Test script routine is complete.')