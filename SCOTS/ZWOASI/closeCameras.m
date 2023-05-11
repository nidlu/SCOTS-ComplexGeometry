function closeCameras(CamNum)
%{
Created by Sergio Bonaque-Gonzalez. Optical Engineer. August 2019
sergiob@wooptix.com
This program closes all connected ZWO cameras 
%}
for i=0:CamNum-1
    calllib('ASICamera2', 'ASICloseCamera',i);
    fprintf('Camera %i closed!\n',i);
end