function dist_tick = mm2tick(dist_mm)
% MM2TICK converts millimeters to ludl tick marks
%
% One tick in Ludl space is equivalent to 50 nm. This corresponds to a
% conversion factor of 50 [nm/tick] * 1 [mm] / 1e6 [nm] = 5e-5 [mm/tick].
% Inverting this gives a conversion factor of 20000 [ticks/mm].
%

dist_tick = dist_mm * 20000;



