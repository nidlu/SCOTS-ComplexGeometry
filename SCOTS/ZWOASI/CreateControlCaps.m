function [ControlCaps]=CreateControlCaps()
%{
Created by Sergio Bonaque-Gonzalez. Optical Engineer. August 2019
sergiob@wooptix.com

This program creates a struct as expected by C# for the function ASIGetControlCaps
%}

ControlCaps.Name = int8(zeros(1,64));           %C=char Name[64];           Matlab=int8(zeros(1,64))
ControlCaps.Description = int8(zeros(1,128));   %C=char Description[128];   Matlab=int8(zeros(1,128))
ControlCaps.MaxValue = int32(0);                %C=long;                    Matlab=int32
ControlCaps.MinValue = int32(0);                %C=long;                    Matlab=int32
ControlCaps.DefaultValue = int32(0);            %C=long;                    Matlab=int32
ControlCaps.IsAutoSupported = int32(0);         %C=int;                     Matlab=int32
ControlCaps.IsWritable = int32(0);              %C=int;                     Matlab=int32
ControlCaps.ControlType = int32(0);             %C=int;                     Matlab=int32
ControlCaps.Unused = int8(zeros(1,32));         %C=char Unused[32];         Matlab=int8(zeros(1,32))
