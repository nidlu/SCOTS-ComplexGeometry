%% computePhasemap
function computePhaseMap(aqPar,inputDir,outputDir)
    %read files
    imageHPhaseNames = dir([inputDir '/ds_imagePhaseH*']);
    imageVPhaseNames = dir([inputDir '/ds_imagePhaseV*']);
    imageHPhaseNames = natsortfiles(imageHPhaseNames);
    imageVPhaseNames = natsortfiles(imageVPhaseNames);
    for i=1:length(imageHPhaseNames)
       imagesH(:,:,i) = im2gray(imread([inputDir '/' imageHPhaseNames(i).name]));
       imagesV(:,:,i) = im2gray(imread([inputDir '/' imageVPhaseNames(i).name]));
    end
    %create cicrular mask
    imageSizeX = aqPar.rawImageSizeX*aqPar.imageResizingFactor;
    imageSizeY = aqPar.rawImageSizeY*aqPar.imageResizingFactor;

    % Conversion of measurement parameters from mm to pixels
    measurementRadius_px = round(aqPar.measurementRadius_mm / aqPar.image_mm_per_px);
    innerRadius_px = round(aqPar.innerRadius_mm / aqPar.image_mm_per_px);
    petalStartRadius_px = round(aqPar.petalStartRadius_mm / aqPar.image_mm_per_px);
    gapWidth_px = round(aqPar.gapWidth_mm / aqPar.image_mm_per_px);
    
    center = [aqPar.imageMirrorCenterX_px, aqPar.imageMirrorCenterY_px];
    
    % Petal mask
    if(aqPar.isPetal)
        mask = petalMask(measurementRadius_px, innerRadius_px, petalStartRadius_px,...
            center, gapWidth_px, aqPar.nb_petals,imageSizeX, imageSizeY);
    else
        mask = petalMask(measurementRadius_px, 0, 0, center, 0, aqPar.nb_petals,imageSizeX, imageSizeY);
    end

    wrappedMapH = zeros(imageSizeY, imageSizeX);
    wrappedMapV = zeros(imageSizeY, imageSizeX);
    %Compute phase by sine fitting ever pixel within mask
    for i = 1:imageSizeY
        for j = 1:imageSizeX
            if(mask(i,j))
                imageValuesH = double(reshape(imagesH(i,j,:),1,[]));
                imageValuesV = double(reshape(imagesV(i,j,:),1,[]));
                imageValuesHScaled = rescale(imageValuesH,-1,1);
                imageValuesVScaled = rescale(imageValuesV,-1,1);
                wrappedMapH(i,j) = sineFitRestricted(aqPar.phases,imageValuesHScaled,false);
                wrappedMapV(i,j) = sineFitRestricted(aqPar.phases,imageValuesVScaled,false);
            else
                wrappedMapH(i,j) = NaN;
                wrappedMapV(i,j) = NaN;
            end
        end
    end
    writematrix(wrappedMapH,[outputDir '/wrappedMapH.txt']);
    writematrix(wrappedMapV,[outputDir '/wrappedMapV.txt']);
end