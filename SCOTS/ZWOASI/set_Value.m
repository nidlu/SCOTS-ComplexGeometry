function set_Value(Camera,controlNumber,value,controls,ControlType)
%{
Created by Sergio Bonaque-Gonzalez. Optical Engineer. August 2019
sergiob@wooptix.com

This program change the current value of a control of a ZWO camera and
display it in the command window
%}

[ControlCaps]=CreateControlCaps();
info=libstruct('s_ASI_CONTROL_CAPS',ControlCaps);
a=calllib('ASICamera2','ASIGetControlCaps',int32(Camera),controlNumber, info);

if a~=0
    printerrors(a)
end

ControlTranslation=translateControls(ControlType(controlNumber+1));
a=calllib('ASICamera2','ASISetControlValue',int32(Camera),ControlTranslation, int32(value), int32(0));
if a==0
    fprintf('The value for %s has been changed to %.1f.\n',controls{Camera+1,controlNumber+1},value)
else
    printerrors(a)
end
