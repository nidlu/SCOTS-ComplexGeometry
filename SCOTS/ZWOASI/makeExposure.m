function image=makeExposure(CameraNumber,OutputValue,Sizes)
%{
Created by Sergio Bonaque-Gonzalez. Optical Engineer. August 2019
sergiob@wooptix.com

This script takes a single snapshot of a ZWO camera
%}

%Check if the camera is ready
status = libpointer ('voidPtr',int32(0));
calllib('ASICamera2', 'ASIGetExpStatus', CameraNumber,status);
if status.Value==0 %if ready, exposure starts
    a=calllib('ASICamera2', 'ASIStartExposure', CameraNumber,int32(0));
end
if a~=0
    error('Exposure failed!')
end

status = libpointer ('voidPtr',int32(0));
calllib('ASICamera2', 'ASIGetExpStatus', CameraNumber,status);

%check if the exposure is finished
while status.Value~=2
    calllib('ASICamera2', 'ASIGetExpStatus', CameraNumber,status);
    continue
end

if OutputValue==0
    factor=1;
elseif OutputValue==1
    factor=3;
elseif OutputValue==2
    factor=2;
elseif OutputValue==3
    factor=1;
end

lBuffSize=factor*Sizes{CameraNumber+1}(2)*Sizes{CameraNumber+1}(1); %Set the buffer
images = libpointer ( 'uint8Ptr' , uint8(zeros(1,lBuffSize)));
%Get the data
calllib('ASICamera2','ASIGetDataAfterExp',CameraNumber, images, int32(lBuffSize));

image=images.Value;
image = typecast(image(:), 'uint16');
image=reshape(image,[Sizes{CameraNumber+1}(2),Sizes{CameraNumber+1}(1)]);

calllib('ASICamera2', 'ASIStopExposure', CameraNumber);