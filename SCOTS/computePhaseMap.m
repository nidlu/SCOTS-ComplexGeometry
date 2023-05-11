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
    [rowsInImage, columnsInImage] = meshgrid(1:imageSizeX, 1:imageSizeY);
    circlePixels = (rowsInImage - aqPar.imageMirrorCenterX_px).^2 ...
        + (columnsInImage - aqPar.imageMirrorCenterY_px).^2 <= aqPar.measurementRadius_px.^2;
    circlePixels2 = (rowsInImage - aqPar.imageMirrorCenterX_px).^2 ...
        + (columnsInImage - aqPar.imageMirrorCenterY_px).^2 >= aqPar.innerRadius_px.^2;

    wrappedMapH = zeros(imageSizeY, imageSizeX);
    wrappedMapV = zeros(imageSizeY, imageSizeX);
    %Compute phase by sine fitting ever pixel within mask
    for i = 1:imageSizeY
        for j = 1:imageSizeX
            if(circlePixels(i,j) && circlePixels2(i,j))
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