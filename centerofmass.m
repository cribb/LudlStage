function [cx,cy,sx,sy] = centerofmass(m)
% CENTEROFMASS calculates the "center of mass" of each image based on the
% value of each pixel

% PURPOSE: find c of m of distribution

[sizey sizex] = size(m);

vx = sum(m);
vy = sum(m');

vx = vx.*(vx>0);
vy = vy.*(vy>0);

x = [1:sizex];
y = [1:sizey];

cx = sum(vx.*x)/sum(vx);
cy = sum(vy.*y)/sum(vy);
sx = sqrt(sum(vx.*(abs(x-cx).^2))/sum(vx));
sy = sqrt(sum(vy.*(abs(y-cy).^2))/sum(vy));
