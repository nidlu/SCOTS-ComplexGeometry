# ZWO_ASI178MM_Matlab_Wrapper
Created by Sergio Bonaque-Gonzalez. Optical Engineer. August 2019

sergio.bonaque.gonzalez@gmail.com


This program is matlab's wrapper for some functions of the ZWO cameras library.
Files ASICamera2.dll & ASICamera2.h & ASICamera2.h & ASICamera2_proto.m must be in the same
folder.


The reference script with examples is 'main.m'


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
