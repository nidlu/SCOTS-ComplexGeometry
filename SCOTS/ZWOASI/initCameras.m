function [CamNum,Sizes]=initCameras()
%{
Created by Sergio Bonaque-Gonzalez. Optical Engineer. August 2019
sergiob@wooptix.com
This program search for the number of ZWO cameras connected, opens and
inits them.
Outputs:
CamNum = number of connected cameras
Sizes = cell containing the pixel number in the sensor of each camera
%}


%Search number of cameras
CamNum = calllib('ASICamera2', 'ASIGetNumOfConnectedCameras');

if CamNum<1
    unloadlibrary('ASICamera2');
    error('There are not cameras connected\n')
else
    fprintf('Found %i cameras!:\n',CamNum);
end

Sizes=cell(1,CamNum);
%Get names of the cameras
for i=0:CamNum-1
    Properties=CreateProperties(); %Creates structs for used functions
    info=libstruct('s_ASI_CAMERA_INFO',Properties);
    n=calllib('ASICamera2', 'ASIGetCameraProperty', info,i);
    if n~=0
        error('no camera connected or index value out of boundary')
    end
    name=char(info.Name);
    fprintf('Camera %i: %s\n',i,name);
    get(info);
    Sizes{i+1}=[info.MaxHeight,info.MaxWidth];
end

%open and init cameras
for i=0:CamNum-1
    a=calllib('ASICamera2', 'ASIOpenCamera',i);
    b=calllib('ASICamera2', 'ASIInitCamera',i);
    if a==0 && b==0
        fprintf('Camera %i opened!\n',i);
    else
        error('Camera %i cant be opened!\n',i);
    end
end



