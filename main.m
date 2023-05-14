%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SCOTS for Deployable Telescopes (University of Arizona)
% Author: Carl Johan G Nielsen
% Université Libre de Bruxelles 2023
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Paths and Imports
%still in petalSandbox
%new change
clc;clearvars;close all;
import matlab.net.*
import matlab.net.http.*
addpath("SCOTS");
addpath('SCOTS/natsortfiles');  %%% Externally developed dependencies
addpath("SCOTS/normal_integration-master/Toolbox");
addpath("SCOTS/phase_unwrap");  %       
addpath('SCOTS/zernike');       %      
addpath('SCOTS/ZWOASI');        %%%      
addpath('SCOTS/Inpaint_nans');
%% Load parameters
[geom, aqPar] = loadParamsFromJSON('parameters.json');
load('cameraParams_ASI120_T1.mat'); %%load camera calibration data
%% Flags
aqPar.applyCameraCompensation = 0;
testNames{1} = 'data/08_05_2023_phaseAccTest/test8_lsq_lownoise';
zerophase = 0;
acquire = 1;
integrate = 1;
aqPar.isPetal = 1;
%% Compute global variables
aqPar.phases = 0:2*pi/8:2*pi*2; %0:2*pi/16:2*pi*2
aqPar.canvasPosition_px = [2800 -170 aqPar.canvasSize_px aqPar.canvasSize_px]; %screen phase window position
aqPar.imageMirrorCenterX_px = 350; %px, Location of the mirror in CAM image
aqPar.imageMirrorCenterY_px = 198; %top left, down right positive.
aqPar.measurementRadius_px = round(aqPar.measurementRadius_mm/aqPar.image_mm_per_px); %px, Masking radius of the mirror in CAM image, max 
aqPar.innerRadius_px =  round(aqPar.innerRadius_mm/aqPar.image_mm_per_px);
aqPar.petalStartRadius_px = round(aqPar.petalStartRadius_mm / aqPar.image_mm_per_px);
aqPar.gapWidth_px = round(aqPar.gapWidth_mm / aqPar.image_mm_per_px);
aqPar.center = [aqPar.imageMirrorCenterX_px, aqPar.imageMirrorCenterY_px];
aqPar.imageSizeX = aqPar.rawImageSizeX*aqPar.imageResizingFactor;
aqPar.imageSizeY = aqPar.rawImageSizeY*aqPar.imageResizingFactor;


% Petal mask
if(aqPar.isPetal)
    aqPar.mask = petalMask(aqPar.measurementRadius_px, aqPar.innerRadius_px, aqPar.petalStartRadius_px,...
        aqPar.center, aqPar.gapWidth_px, aqPar.nb_petals, aqPar.imageSizeX, aqPar.imageSizeY);
else
    aqPar.mask = petalMask(aqPar.measurementRadius_px, 0, 0, aqPar.center, 0, 1,...
        aqPar.imageSizeX, aqPar.imageSizeY);
end

% Create mirror coordinate system from px to mm
aqPar.boundingBox = boundingBox(aqPar.mask);
onesMatrix = ones(length(aqPar.boundingBox.rows), length(aqPar.boundingBox.cols));
aqPar.mirrorX_px_ = -aqPar.measurementRadius_px+onesMatrix.*(1:size(onesMatrix,2));
aqPar.mirrorY_px_ =  aqPar.measurementRadius_px-onesMatrix.*(1:size(onesMatrix,1))';
aqPar.mirrorX_mm_ = aqPar.mirrorX_px_.*aqPar.image_mm_per_px;
aqPar.mirrorY_mm_ = aqPar.mirrorY_px_.*aqPar.image_mm_per_px;

if(zerophase); showZeroPhase(aqPar); pause; end

for i = 1:length(testNames)
    aqPar.testName=testNames{i}; 
    mkdir(aqPar.testName);
    mkdir([aqPar.testName '/images']);mkdir([aqPar.testName '/imagesVirtual']);
    mkdir([aqPar.testName '/darkSubtracted']); mkdir([aqPar.testName '/postprocessing']);
    
    if(acquire)
        %[cam.CameraNumber,cam.OutputValue,cam.Sizes] = cameraSetup();
        %imageZeroPhase(aqPar,cam,cameraParams);
        %imageDark(aqPar,cam,cameraParams);
        %showImagedArea(aqPar);
        %imagePhases(aqPar,cam,cameraParams);
        %closeCameras(cam.CameraNumber)
        %makeSTLSphereWithAstigmatism(geom, aqPar, 0, [aqPar.testName '/postprocessing/w0.stl']); %
        %imageVirtualPhases(aqPar);
    end
    if(integrate)
        %darkSubtract(aqPar);
        %aqPar = computeZeroPhaseLoc(aqPar);
        aqPar.deltaZeroPhaseLocationX = 0;
        aqPar.deltaZeroPhaseLocationY = 0;
        %computePhaseMap(aqPar,[aqPar.testName '/darkSubtracted'],[aqPar.testName '/postprocessing']);
        %computePhaseMap(aqPar,[aqPar.testName '/imagesVirtual'],[aqPar.testName '/postprocessing']);
        %plotPhaseMap(aqPar);
        %unwrapPhaseMap(aqPar);%ok
        %computeSlope(aqPar,geom);
        %plotSlopes(aqPar);
        %integrateShape(aqPar);
        shapeAnalysis(aqPar,geom);
        %exportSTL(aqPar);
        %phaseOffset = pi;
        %rayTrace([aqPar.testName '/postprocessing/w0.stl'],[aqPar.testName '/postprocessing/rayTrace.png'],...
        %    phaseOffset,'horizontal'); %only call if you have WSL and raySect installed
        %plotOverlayImages([aqPar.testName '/postprocessing/rayTrace.png'],...
        %                  [aqPar.testName '/images/imagePhaseH0.0000.png']);
    end
end


%       disp('Acquisition complete, press to continue');
%       beep;
        %pause;
