function ncycles(ludl,plate,number)

i = 1;
x_drift_array = zeros(15,10);
y_drift_array = zeros(15,10);
centers = plate.calib.centers;

while i <= number
   [x_offset,y_offset] = well_location_test(ludl,centers);
   for row = 1:3
       for column = 1:5
           well = (row - 1)*5 + column;
           x_drift_array(well,i) = x_offset{row,column} * 0.05;
           y_drift_array(well,i) = y_offset{row,column} * 0.05;
       end
   end
   i = i+1;
end 


h = figure(557); clf;
figure(h);
hold on;
for k = 1:number
    scatter(linspace(1,15,15),x_drift_array(1:15,k))
    ax = gca;
    set(gca, 'XTick',linspace(1,15,15))
    ax.XGrid = 'on';
    ax.GridLineStyle = '-';
end
hold off;

z = figure(558); clf;
figure(z);
hold on;
for k = 1:number
    scatter(linspace(1,15,15),y_drift_array(1:15,k))
    ax = gca;
    set(gca, 'XTick',linspace(1,15,15))
    ax.XGrid = 'on';
    ax.GridLineStyle = '-';
end
hold off;
