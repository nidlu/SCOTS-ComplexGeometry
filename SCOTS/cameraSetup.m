function [CameraNumber,OutputValue,Sizes] = cameraSetup();
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %init the drivers and the proto-header (if needed)
    initDrivers() 

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %shows the available options in the library
    % searchFunctions();

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Search, init and open available cameras
    [CamNum,Sizes]=initCameras();

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Turn on the fan
    calllib('ASICamera2','ASISetControlValue',0,19, int32(1), int32(1))

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Get camera modes and set it to normal. To be sure that cameras are in normal mode
    getCameraMode(CamNum);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %number and name of controls
    [controls,ControlType]=listControls(CamNum);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Modify a control value
    %Example: modify the exposure (number 1 as stated in the output of
    %'listControls' function
    CameraNumber=0;

    %%GAIN
    ControlNumber=0;
    ControlValue=0;
    %%Check if writable and max/min values
    [ControlCaps]=CreateControlCaps();
    info=libstruct('s_ASI_CONTROL_CAPS',ControlCaps);
    ControlTranslation=translateControls(ControlType(ControlNumber+1));
    calllib('ASICamera2','ASIGetControlCaps',CameraNumber,ControlTranslation, info)
    get(info)

    modifyControl(CameraNumber,ControlNumber,ControlValue,controls,ControlType);

    %%EXPOSURE
    ControlNumber=1;
    ControlValue=0.20*10^6;
    %%Check if writable and max/min values
    [ControlCaps]=CreateControlCaps();
    info=libstruct('s_ASI_CONTROL_CAPS',ControlCaps);
    ControlTranslation=translateControls(ControlType(ControlNumber+1));
    calllib('ASICamera2','ASIGetControlCaps',CameraNumber,ControlTranslation, info)
    get(info)
    %char(info.Name)

    modifyControl(CameraNumber,ControlNumber,ControlValue,controls,ControlType);

    %%Alternatively, if you dont want to check the value before and after the
    %%change, it can be replaced by
    %set_Value(CameraNumber,ControlNumber,ControlValue,controls,ControlType);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Make snapshot
    %First, the output type must be set
    %0=RAW8
    %1=RGB24
    %2=RAW16
    %3=Y8
    OutputValue=2;
    set_Output(CameraNumber,Sizes,OutputValue);
    warning('off', 'Images:initSize:adjustingMag');
end


