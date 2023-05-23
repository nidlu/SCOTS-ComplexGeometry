function [deltaX, deltaY, centX0, centY0] = computeZeroPhaseLoc(aqPar, imgPath)
    zeroPhaseImg = im2gray(imread(imgPath));
    maximum = max(max(zeroPhaseImg));
    [centY0,centX0]=find(zeroPhaseImg==maximum);
    centY0 = centY0(1); centX0 = centX0(1);
    
    zeroPhaseImgCrop = zeroPhaseImg(centY0-10:centY0+10,centX0-10:centX0+10);
    
    X_hist=sum(zeroPhaseImgCrop,1);
    Y_hist=sum(zeroPhaseImgCrop,2);
    X=1:21; Y=1:21;
    centX1=(sum(X.*X_hist)/sum(X_hist));
    centY1=(sum(Y'.*Y_hist)/sum(Y_hist));
    
    centX = centX0+centX1-11;
    centY = centY0+centY1-11;
    
    deltaX = centX-aqPar.imageMirrorCenterX_px; %px, ok, manually read from zero phase image, difference..
    deltaY = centY-aqPar.imageMirrorCenterY_px; %px, ok   .. between zero phase in image and assumed center
end