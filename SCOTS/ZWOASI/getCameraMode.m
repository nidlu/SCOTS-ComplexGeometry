function getCameraMode(CamNum)
%{
Created by Sergio Bonaque-Gonzalez. Optical Engineer.August 2019
sergiob@wooptix.com

This program get the camera mode of ZWO cameras and says if they are in
normal mode of working.
%}

%Camera mode
% [CameraMode]=CreateCameraMode();
info=libpointer ( 'voidPtr' , int32(ones(1,8))); 
mode=calllib('ASICamera2', 'ASIGetCameraMode',0, info);
for j=0:CamNum-1
    mode=calllib('ASICamera2', 'ASIGetCameraMode',j, mode);
    if info.Value(1)==0
        fprintf('Camera %i is set in normal mode\n',j)
    else
        fprintf('Camera %i is NOT set in normal mode\n',j)
    end
end