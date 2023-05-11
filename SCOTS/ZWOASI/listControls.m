function [name,ControlType]=listControls(CamNum)
%{
Created by Sergio Bonaque-Gonzalez. Optical Engineer. August 2019
sergiob@wooptix.com

This program gets the available controls of ZWO cameras and displays it in the command window.
%}
control = libpointer ( 'int32Ptr' , int32(0)); 
calllib('ASICamera2','ASIGetNumOfControls',0,control);
controls_n=control.value;
name=cell(CamNum,controls_n);
ControlType=cell(CamNum,controls_n);
for j=0:CamNum-1
    fprintf('List of controls for camera %i\n',j);
    for i=0:controls_n-1
        ControlCaps=CreateControlCaps(); %Creates structs for used functions
        info=libstruct('s_ASI_CONTROL_CAPS',ControlCaps);
        calllib('ASICamera2', 'ASIGetControlCaps', j,i,info);
        name{j+1,i+1}=char(info.Name);
        ControlType{j+1,i+1}=info.ControlType;
        if i<10
            fprintf('%i = %s:%s\n',i,name{j+1,i+1},char(info.Description));
        else
            fprintf('%i =%s:%s\n',i,name{j+1,i+1},char(info.Description));
        end
    end
end
