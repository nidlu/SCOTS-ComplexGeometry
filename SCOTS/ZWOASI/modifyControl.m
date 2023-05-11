function modifyControl(Camera,controlNumber,value,controls,ControlType)
%{
Created by Sergio Bonaque-Gonzalez. Optical Engineer. August 2019
sergiob@wooptix.com

This program modify the value of a control of a ZWO camera.
INPUTS
Camera=camera ID (the first detected camera is 0)
controlNumber = the number of the control as showed in the output of
listControls.m function
value = the desired value
%}

%check previous value
checkValue(Camera,controlNumber,controls,ControlType);

%Change the value
set_Value(Camera,controlNumber,value,controls,ControlType);

%Check again
checkValue(Camera,controlNumber,controls,ControlType);