%% expose
function image = exposeASI(cam,cameraParams,scaleFactor)
    rawImage = makeExposure(cam.CameraNumber,cam.OutputValue,cam.Sizes);
    rawImage = rawImage';%reorient
    %undistortedImage = rawImage; %if not using calibration
    undistortedImage = undistortImage(rawImage, cameraParams);
    image = imresize(undistortedImage,2/5);
end