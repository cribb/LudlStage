function [x_offsets,y_offsets,imout,x_centers,y_centers] = well_location_test(ludl,centers)

xwells =  5;
ywells = 3;
vid = videoinput('pointgrey', 1, 'F7_Mono8_648x488_Mode0');


%Assigns numbers to individual wells; convention is that across first row
%are wells 1,2,3,4,5 respectively, then row 2 starts with well 6, and so on
well_matrix = [1 2 3 4 5; 6 7 8 9 10; 11 12 13 14 15];


for row = 1:3
    for column = 1:5
%             column = k;
%             row = j;
        disp(['row=' num2str(row), ', column=' num2str(column)]);
        plate_space_move(ludl, plate, [row column])
        pause(2);
        frame = getsnapshot(vid);
%         imwrite(frame,strcat('imC',num2str(i),'.tif'));
        imout{row,column} = frame;
        x = stage_get_pos_Ludl(ludl).Pos(1);
        y = stage_get_pos_Ludl(ludl).Pos(2);
        [x_center y_center x_offset y_offset] = image_center_find(frame, x, y);
        x_centers{row,column} = x_center;
        y_centers{row,column} = y_center;
        x_offsets{row,column} = x_offset;
        y_offsets{row,column} = y_offset;
    end
end

% h = figure(555); clf;
% imtmp = imout';
% for k = 1:numel(imtmp)
%     figure(h); 
%     subplot(3,5,k);
%     imagesc(imtmp{k}); 
%     colormap(gray(256));
%     title(num2str(k));
% end



