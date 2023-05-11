function aqPar = computeZeroPhaseLoc(aqPar)
    zeroPhaseImg = imread([aqPar.testName '/darkSubtracted/ds_imageZeroPhase.png']);
    
    maximum = max(max(zeroPhaseImg));
    [centY0,centX0]=find(zeroPhaseImg==maximum);
    
    zeroPhaseImgCrop = zeroPhaseImg(centY0-10:centY0+10,centX0-10:centX0+10);
    
    X_hist=sum(zeroPhaseImgCrop,1);
    Y_hist=sum(zeroPhaseImgCrop,2);
    X=1:21; Y=1:21;
    centX1=(sum(X.*X_hist)/sum(X_hist));
    centY1=(sum(Y'.*Y_hist)/sum(Y_hist));
    
    centX = centX0+centX1-11;
    centY = centY0+centY1-11;
    
    aqPar.deltaZeroPhaseLocationX = centX-aqPar.imageMirrorCenterX_px; %px, ok, manually read from zero phase image, difference..
    aqPar.deltaZeroPhaseLocationY = centY-aqPar.imageMirrorCenterY_px; %px, ok   .. between zero phase in image and assumed center
end