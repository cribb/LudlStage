function success = SerialPortSetUp()
% SERIALPORTSETUP prompts the user to select what COM port the stage is
% connected to and saves the appropriate data in 'PortNames.mat' inside the
% same folder that SerialPortSetUp is located in
try
    
    success = 0;
    
    for i=1:1:20
        Ports{i}=strcat('COM',num2str(i));
    end
    
    [s1,v1] = listdlg('PromptString','Set the COM port for the stage?',...
        'SelectionMode','single','ListSize',[250 50],...
        'ListString',Ports)
    
    if (v1==1)
        SerialPortStage=strcat('COM',num2str(s1));
        save('PortNames.mat','SerialPortStage');
        success = 1;
    else
        hObject_ModeSelectionPopUpMenu =...
            findobj('Tag','ModeSelectionPopUpMenu');
        set(hObject_ModeSelectionPopUpMenu, 'Value', 1);
    end
    
catch ME
    error_show(ME)
end

end

