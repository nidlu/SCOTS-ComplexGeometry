%% calibrateImages
function f = calibrateImages(aqPar,cameraParams)
    imageNames = dir([aqPar.testName '/images/image*']);
    for i=1:length(imageNames)
       image = imread([aqPar.testName '/images/' imageNames(i).name]);
       calibratedImage = undistortImage(image, cameraParams);
       imwrite(calibratedImage, [aqPar.testName '/calibrated/c_' imageNames(i).name]);
    end
end