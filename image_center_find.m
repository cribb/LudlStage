function [x_center, y_center, x_disp, y_disp] = image_center_find(im, x_start, y_start)
% IMAGE_CENTER_FIND locates the center of each fiducial mark and determines 
% the ludl coordinates that the stage would need to be in such that the 
% center of each fiducial mark would be at the center of the image

cameraname = 'Grasshopper3';
switch lower(cameraname)
    case 'grasshopper3'
        image_width_pixels = 1024;
        image_height_pixels = 768;
        SE_radius = 22;
    case 'dragonfly2'
        image_width_pixels = 648;
        image_height_pixels = 488;
        SE_radius = 14;        
end

% Define structuring element
SE = strel('disk', SE_radius);
factor = 45;

% Binarize and erode/dilate image
test = im;
test = imbinarize(test);
test = imcomplement(test); 
test = imdilate(test,SE); 
test = imerode(test,SE); 

% (10:end-10,10:end-10)
% Find/plot center of mass
[x, y] = centerofmass(test);

% Find pixel displacement from center and convert to ticks
% x_disp = (635/2 - x) * -factor;
% y_disp = (470/2 - y) * factor;

x_disp = (image_width_pixels/2 - x) * -factor;
y_disp = (image_height_pixels/2 - y) * factor;

% Find coordinates for the center of the fiducial markings in ludl
% coordinates
x_center = x_start + x_disp;
y_center = y_start + y_disp;

% Debug plot (comment out later)
figure; 
imshow(test)
hold on
    plot(x, y, 'or');
    plot(x_center, y_center, 'xg');   
hold off
legend('center of mass', 'center of field');

