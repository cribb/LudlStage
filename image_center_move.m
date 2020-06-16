function ludl_pos = image_center_move(x, y)
% For a given current view, the stage centers the fiducial mark for the
% camera

% Pixel to tick conversion
factor = 45;

% Find pixel displacement from center and convert to ticks
x_disp = (635/2 - x) * - factor;
y_disp = (470/2 - y) * factor;

% Define ludl stage and get current position
ludl = stage_open_Ludl();
x_old = stage_get_pos_Ludl(ludl).Pos(1);
y_old = stage_get_pos_Ludl(ludl).Pos(2);

% Move to new position at camera center
stage_move_Ludl(ludl,[x_old + x_disp y_old + y_disp])
ludl_pos = stage_get_pos_Ludl(ludl).Pos;