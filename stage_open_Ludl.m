function stage = stage_open_Ludl(ComPort, label)
% STAGE_OPEN_LUDL creates a new ludl stage object

% Setting a default stage model. XXX Should probably be like 'nolabel'
if nargin < 2 || isempty(label)
    label = 'BioPrecision2-LE2_Ludl6000';
end

% If the ComPort is empty, we look for the existence of the PortNames.mat
% file that would contain an earlier configuation of the stage connection
% information. If there is no PortNames.mat file, throw an error.
if nargin < 1 || isempty(ComPort)
    if ~isempty(dir('PortNames.mat'))
        % Test to see if the COM port is set in the file PortNames.mat
        % PortNames.mat contains SerialPortStage, the last connected port.
        % XXX TODO Move PortNames to the user's matlab home dir.
        tmp = load('PortNames.mat', 'SerialPortStage');
        ComPort = tmp.SerialPortStage;
        clear tmp;
    else 
        error('No ComPort provided and PortNames.mat is not found.');
    end    
end

if isempty(regexpi(ComPort, 'COM\d*'))
     error('ComPort must be a string representation, e.g. ''COM2''');
end
     
% instrfind returns the instrument object array, where
% each entry includes the type, status, and name as follows
% Index:    Type:     Status:   Name:
% 1         serial    closed    Serial-COM4
% 
% objects can be cleared from memory with delete(objects)
% 
% Check to see if there's an open connection to ComPort and delete it
% if one is found.
objects = instrfind('Port', ComPort);
delete(objects);

try

    stage.handle = serial(ComPort, 'RequestToSend','off', ...
                                   'Timeout', 3, ...
                                   'Baudrate', 115200, ...
                                   'Parity', 'none', ...
                                   'Stopbits', 2);

    % Try opening the COM port 
    try
        
        fopen(stage.handle);
    
    % Fail gracefully if the COM port doesn't exist or isn't correct.
    catch ME

        delete(stage.handle);
        stage.handle = '';
        desc = textscan(ME.message,'%s','delimiter','\n');
        desc = desc{1};
        desc = desc(1,:);
%         h_errordlg = errordlg(desc,'Application error','modal');
%         uiwait(h_errordlg);
        disp('Application Error: COM port does not exit or is not connected to any device.');
                
        % XXX TODO 
        stage.status = SerialPortSetUp();
        
        if stage.status == 1 
        	error('COM port incorrect or device not found.');
        end
        
        return
    end

    % Test to see if the COM port is attached to the stage
    desc_status = stage_send_com_Ludl(stage.handle, 'STATUS');
    if ~strcmp(desc_status, 'N') && ~strcmp(desc_status, 'B')
        
        delete(stage.handle);
        stage.handle = '';
        desc = 'The selected COM port is not connected to the stage.';
        h_errordlg = errordlg(desc,'Application error','modal');
        uiwait(h_errordlg);

        stage.status = SerialPortSetUp();
        
        if stage.status == 1 
            stage = stage_open_Ludl();
        end
        
        return
    end

    stage.status = 1;
    disp('yEeT');
    
catch ME
    
    error_show(ME)
    
end

% If we're connected, tack on the remaining settings for the stage object
switch label
    case 'SCAN8Praparate_Ludl5000'            
        stage.speed=50000;
        stage.accel=100;
        stage.scale=0.1;
    case 'SCAN8Praparate_Ludl6000'         
        stage.speed=200000;
        stage.accel=1;
        stage.scale=0.025;
    case 'BioPrecision2-LE2_Ludl5000'            
        stage.speed=40000;
        stage.accel=100; 
        stage.scale=0.2;
    case 'BioPrecision2-LE2_Ludl6000'           
        stage.speed=150000;
        stage.accel=1;   
        stage.scale=0.05;
   otherwise
        stage.speed=50000;
        stage.accel=100;      
        stage.scale=0.1;
end  


return



