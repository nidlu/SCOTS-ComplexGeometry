function set_Output(CameraNumber,Sizes,OutputValue)
%{
Created by Sergio Bonaque-Gonzalez. Optical Engineer.
sergiob@wooptix.com

This program set and check the type of image a ZWO camera provides
%0=RAW8
%1=RGB24
%2=RAW16
%3=Y8

%}
%set the value
Properties=CreateProperties(); %Creates structs for used functions
info=libstruct('s_ASI_CAMERA_INFO',Properties);
calllib('ASICamera2', 'ASIGetCameraProperty', info,CameraNumber);
formats=info.SupportedVideoFormat;

if ismember(OutputValue,formats)==0
    error('The camera does not support the requested image format')
end

calllib('ASICamera2', 'ASISetROIFormat', CameraNumber,Sizes{CameraNumber+1}(2),Sizes{CameraNumber+1}(1),int32(1),int32(OutputValue));

%check the value
value = libpointer ( 'int32Ptr' , int32(0));
calllib('ASICamera2', 'ASIGetROIFormat', CameraNumber,Sizes{CameraNumber+1}(2),Sizes{CameraNumber+1}(1),int32(1),value);
a=value.Value;

if a==0
    fprintf('Changed to RAW8\n')
elseif a==1
    fprintf('Changed to RGB24\n')
elseif a==2
    fprintf('Changed to RAW16\n')
elseif a==3
    fprintf('Changed to Y8\n')
end



