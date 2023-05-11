function showVideo(CameraNumber,OutputValue,Sizes)
%{
Created by Sergio Bonaque-Gonzalez. Optical Engineer. August 2019
sergiob@wooptix.com

This script show a video taken by a ZWO camera. It finish when the window
of the figure is closed (alternatively, Control+C can be used to exit)
%}

%Starts the capture
set_Output(CameraNumber,Sizes,OutputValue);
calllib('ASICamera2','ASIStartVideoCapture',CameraNumber);

%%Calculating the factor to set the buffer size
if OutputValue==0
    factor=1;
elseif OutputValue==1
    factor=3;
elseif OutputValue==2
    factor=2;
elseif OutputValue==3
    factor=1;
end

%We obtain the current exposure time, needed to adjust the video rate.
value = libpointer ( 'int32Ptr' , int32(0));
asiBool = libpointer ( 'int32Ptr' , int32(0));
calllib('ASICamera2','ASIGetControlValue',CameraNumber,int32(1), value, asiBool);
ExposureTime=value.Value;

%set buffers and pointers
lBuffSize=factor*Sizes{CameraNumber+1}(2)*Sizes{CameraNumber+1}(1); %Set the buffer
images = libpointer ( 'uint8Ptr' , uint8(zeros(1,lBuffSize)));

%Stars the loop
a=figure(100);
i=0;
while i==0
    %Get the data
    calllib('ASICamera2','ASIGetVideoData',CameraNumber, images, int32(lBuffSize), int32(ExposureTime*2+500));
    image=images.Value;
    if OutputValue==1 || OutputValue==2
        image = typecast(image(:), 'uint16');
    end
    image=reshape(image,[Sizes{CameraNumber+1}(2),Sizes{CameraNumber+1}(1)]);
    
    
    
    imshow(image,[])
    if ~ishghandle(a)
        break
    end
end
calllib('ASICamera2','ASIStopVideoCapture',CameraNumber);


