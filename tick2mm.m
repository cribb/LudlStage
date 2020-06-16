function dist_mm = tick2mm(dist_tick)
% TICK2MM2 converts Ludl tick distances into millimeters
%
% One tick in Ludl space is equivalent to 50 nm. This corresponds to a
% conversion factor of 50 [nm/tick] * 1 [mm] / 1e6 [nm] = 5e-5 [mm/tick].
% Inverting this gives a conversion factor of 20000 [ticks/mm].
%

dist_mm = dist_tick / 20000;

