function outs = stage_center(stage)
% STAGE_CENTER returns the center and edges of Ludl stage coordinates
%

% The offset here refers to the number of ticks the stage will back off
% from the edge triggered by the limit switch, and N is the number of times 
% the stage backs off. 
offset = 10000; % equivalent to 1 [mm].
N = 3;

stage = stage_get_pos_Ludl(stage);

startxy = stage.Pos;

s = stage_send_com_Ludl(stage.handle, 'SPEED X=150000 Y=150000'); 
s = stage_send_com_Ludl(stage.handle, 'ACCEL X=1 Y=1');

% Find the limits in X
LoX = test_the_boundary(stage, 'x', 'lo', +offset, N);
HiX = test_the_boundary(stage, 'x', 'hi', -offset, N);

% The middle of stage in X is the mean of the average edge measurements
CenterX = mean([LoX.mean(1) HiX.mean(1)]);

stage_log(['StdDev in Xlo is ' num2str(tick2mm(stage, LoX.std(1))*1000) ' [um].']);
stage_log(['StdDev in Xhi is ' num2str(tick2mm(stage, HiX.std(1))*1000) ' [um].']);
stage_log(['Stage center in X is ' num2str(CenterX) ' [ticks].']);

% Move to the stage center in X
s = stage_move_Ludl(stage, [CenterX startxy(2)]);

% Now, find the limits in Y
LoY = test_the_boundary(stage, 'y', 'lo', +offset, N);
HiY = test_the_boundary(stage, 'y', 'hi', -offset, N);

% Calculate the middle of the stage in Y.
CenterY = mean([LoY.mean(2) HiY.mean(2)]);

stage_log(['StdDev in Ylo is ' num2str(tick2mm(stage, LoY.std(1))*1000) ' [um].']);
stage_log(['StdDev in Yhi is ' num2str(tick2mm(stage, HiY.std(1))*1000) ' [um].']);
stage_log(['Stage center in Y is ' num2str(CenterY) ' [ticks].']);

% Move to Stage Center
center = [CenterX, CenterY];
stage = stage_move_Ludl(stage, center);
wait_on_stage(stage);

% Output the calibration results.
outs.center = round(center);
outs.edges.X = round([LoX.mean(1), HiX.mean(1)]);
outs.edges.Y = round([LoY.mean(2), HiY.mean(2)]);
outs.edges.Xstd = round([LoX.std(1), HiX.std(1)]);
outs.edges.Ystd = round([LoY.std(2), HiY.std(2)]);
outs.edges.units = 'ticks';

return

    
function outs = test_the_boundary(stage, myaxis, lohi, offset, N)
    stage = stage_get_pos_Ludl(stage);
    xy = stage.Pos;

    % Is this a low boundary or a high one? (e.g. left vs. right, top vs.
    % bottom)
    if contains(lohi, 'lo')
        % This is just a distance much larger than the stage size. 10^8
        % ticks is equivalent to 5 meters.
        absLimit = -1e8;
    elseif contains(lohi, 'hi')
        absLimit =  1e8;
    else
        error('No limit type specified.');
    end

    % Are we testing x or y and replace the appropriate value with the
    % absLimit.
    if contains(myaxis, 'x') 
        xy(1) = absLimit;
    elseif contains(myaxis, 'y')
        xy(2) = absLimit;
    else
        error('Need to specify x or y axis');
    end
    
    % move to the NEW location (xy is overwritten in the above if block
    s = stage_move_Ludl(stage, xy);
    wait_on_stage(stage);

    % For better precision, slow it down, move it away, and go back home
    success = stage_send_com_Ludl(stage.handle, 'SPEED X=8000 Y=8000');
%    success = stage_send_com_Ludl(stage.handle, 'ACCEL X=32 Y=32');
    success = stage_send_com_Ludl(stage.handle, 'ACCEL X=1 Y=1');
    
    for k = 1:N
        stage_log(['Collecting ' num2str(k) ' of ' num2str(N) '.']);
        
        % Move away from the edge by the offset in ticks
        success = stage_send_com_Ludl(stage.handle, ['MOVREL ' myaxis '=' num2str(offset)]);
        wait_on_stage(stage);
        
        % And then return to the edge, doubling the intended return
        % distance to ensure we hit the limit switch
        success = stage_send_com_Ludl(stage.handle, ['MOVREL ' myaxis '=' num2str(-offset*2)]);
        wait_on_stage(stage);

        stage = stage_get_pos_Ludl(stage);
        pos(k,:) = stage.Pos;
    end
    
    % Output the position and the stats on the measurement
    outs.raw = pos;
    outs.mean = mean(pos);
    outs.std  = std(double(pos));
        
    return

    
function wait_on_stage(stage)

    while stage_check_busy_Ludl(stage.handle)
        pause(0.5);
%         disp('Not there yet 1.');
    end
    
    pause(0.5);
    return
