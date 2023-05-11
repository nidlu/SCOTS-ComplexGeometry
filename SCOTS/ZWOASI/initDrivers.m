function initDrivers()
%{
Created by Sergio Bonaque-Gonzalez. Optical Engineer. August 2019
sergiob@wooptix.com
This program initializes the libraries for the control of a ZWO camera. 
Files ASICamera2.dll & ASICamera2.h & ASICamera2.h must be in the same
folder
%}

%Load the library with the proto-header
if ~libisloaded('ASICamera2')
   loadlibrary('ASICamera2', @ASICamera2_proto)
   fprintf('Library loaded\n')
else
    fprintf('Library already loaded\n')
end