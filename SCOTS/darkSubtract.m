%% darkSubtract
function darkSubtract(aqPar)
    darkImage = imread([aqPar.testName '/images/imageDark.png']);
    imagePhaseStruct = dir([aqPar.testName '/images/imagePhase*']);
    imagePhaseNames = {imagePhaseStruct(:).name, 'imageZeroPhase.png'};
    for i=1:length(imagePhaseNames)
       image = imread([aqPar.testName '/images/' imagePhaseNames{i}]);
       darkSubtractedImage = image-darkImage;
       imwrite(darkSubtractedImage, [aqPar.testName '/darkSubtracted/ds_' imagePhaseNames{i}]);
    end
end