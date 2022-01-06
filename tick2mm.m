function dist_mm = tick2mm(ludl, dist_tick)
% TICK2MM2 converts Ludl tick distances into millimeters
%
% One tick in Ludl space is equivalent to some value in microns that is stored
% inside the ludl object. This corresponds to a conversion factor of  
% XX [mm] * [um/tick] * 1 [mm] / 1e3 [um].
%

dist_mm = dist_tick * ludl.scale / 1e3;

