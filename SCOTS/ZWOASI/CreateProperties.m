function Properties=CreateProperties()
%{
Created by Sergio Bonaque-Gonzalez. Optical Engineer. August 2019
sergiob@wooptix.com

This program creates a struct as expected by C# for the function ASIGetCameraProperty
%}

Properties.Name = int8(zeros(1,64)); %C=char Name[64]; Matlab=
Properties.CameraID = int32(0);         %C=int;     Matlab=int32
Properties.MaxHeight = int32(0);        %C=long;    Matlab=int32
Properties.MaxWidth = int32(0);         %C=long;    Matlab=int32
Properties.IsColorCam = int32(0);       %C=int;     Matlab=int32
Properties.BayerPattern = int32(0);     %C=int;     Matlab=int32
Properties.SupportedBins = int32(zeros(1,16));    %C=int;     Matlab=int32
Properties.SupportedVideoFormat = int32(zeros(1,8)); %C=int; Matlab=int32
Properties.PixelSize = double(0);       %C=double;  Matlab=double
Properties.MechanicalShutter = int32(0);%C=int;     Matlab=int32
Properties.ST4Port = int32(0);          %C=int;     Matlab=int32
Properties.IsCoolerCam = int32(0);      %C=int;     Matlab=int32
Properties.IsUSB3Host = int32(0);       %C=int;     Matlab=int32
Properties.IsUSB3Camera = int32(0);     %C=int;     Matlab=int32
Properties.ElecPerADU = single(0);      %C=float;   Matlab=single
Properties.BitDepth = int32(0);         %C=int;     Matlab=int32
Properties.IsTriggerCam = int32(0);     %C=int;     Matlab=int32
Properties.Unused = int8(zeros(1,16));  %C=int;     Matlab=         
 
