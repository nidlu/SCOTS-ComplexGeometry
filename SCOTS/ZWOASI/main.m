close all
clear all
warning('off', 'Images:initSize:adjustingMag');
% unloadlibrary ASICamera2
%{
Created by Sergio Bonaque-Gonzalez. Optical Engineer. August 2019
sergiob@wooptix.com

This program is matlab's wrapper for some functions of the ZWO cameras library.
Files ASICamera2.dll & ASICamera2.h & ASICamera2.h must be in the same
folder

functions:
initDrivers.m = inits the drivers 
    initDrivers()
searchFunctions.m = shows the available options in the library
    searchFunctions()
initCameras.m = Searchs, inits and opens available cameras
    [CamNum,Sizes]=initCameras();
getCameraMode.m = gets the camera mode of ZWO cameras and says if they are in normal mode of working
    getCameraMode(number of cameras)
listControls.m = gets the available controls of ZWO cameras and displays it in the command window.
    [controls,ControlType]=listControls(number of cameras)
modifyControl.m = modifies the value of a Control to a desired value. It displays the value before and after the change
    modifyControl(CameraNumber,ControlNumber,ControlValue,controls,ControlType);
set_Value.m = directly modifies the value of a Control to a desired value
    set_Value(CameraNumber,ControlNumber,ControlValue,controls,ControlType);
set_Output.m = allows to control the type of obtained image
    set_Output(CameraNumber,Sizes,OutputValue)
    Value for OutputValue
        0=RAW8
        1=RGB24
        2=RAW16
        3=Y8
makeExposure.m = takes image with the defined exposure time;
    image=makeExposure(CameraNumber,OutputValue,Sizes);

closeCameras.m = closes all connected ZWO cameras 
    closeCameras(number of cameras)
%}

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
ControlValue=0.05*10^6;
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

%make the exposure
image=makeExposure(CameraNumber,OutputValue,Sizes);

%Display results
figure
imshow(image,[])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Make video
%First, the output type must be set. And the factor multiplying the buffer
%is calculated
%0=RAW8
%1=RGB24
%2=RAW16
%3=Y8
%OutputValue=0;

%showVideo(CameraNumber,OutputValue,Sizes)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Close cameras
closeCameras(CamNum)


