cont_text = 'Press any key to continue.';

ludl = stage_open_Ludl();
disp('Connection to stage has been opened.')
disp(cont_text);
pause;

currentpos = stage_get_pos_Ludl(ludl);
disp('The stage is currently at position ', currentpos,'.')
pause(0.5)

disp('Now moving very close to the origin...')
stage_move_Ludl(ludl,[0 0]);
currentpos = stage_get_pos_Ludl(ludl);
disp('The stage is currently at position ', currentpos,'.')
disp(cont_text)
pause;

stage_close(ludl);
disp('Connection to the stage has been closed.')
disp('Test script routine is complete.')