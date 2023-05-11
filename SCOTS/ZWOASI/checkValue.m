function checkValue(Camera,controlNumber,controls,ControlType)
%{
Created by Sergio Bonaque-Gonzalez. Optical Engineer.
sergiob@wooptix.com

This program check the current value of a control of a ZWO camera and
display it in the command window
%}

ControlTranslation=translateControls(ControlType(controlNumber+1));

value = libpointer ( 'int32Ptr' , int32(0)); 
asiBool = libpointer ( 'int32Ptr' , int32(0)); 

a=calllib('ASICamera2','ASIGetControlValue',Camera,ControlTranslation, value, asiBool);
if a==0
    if asiBool.Value==0
        fprintf('The value for %s is %.1f. Manual Mode.\n',controls{Camera+1,controlNumber+1},value.Value)
    else
        fprintf('The value for %s is %.1f. Automatic Mode.\n',controls{Camera+1,controlNumber+1},value.Value)
    end
else
    printerrors(a)
end