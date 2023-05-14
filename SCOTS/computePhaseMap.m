%% computePhasemap
function computePhaseMap(aqPar,inputDir,outputDir)
    %read filess
    imageHPhaseNames = dir([inputDir '/ds_imagePhaseH*']);
    imageVPhaseNames = dir([inputDir '/ds_imagePhaseV*']);
    imageHPhaseNames = natsortfiles(imageHPhaseNames);
    imageVPhaseNames = natsortfiles(imageVPhaseNames);
    for i=1:length(imageHPhaseNames)
       imagesH(:,:,i) = im2gray(imread([inputDir '/' imageHPhaseNames(i).name]));
       imagesV(:,:,i) = im2gray(imread([inputDir '/' imageVPhaseNames(i).name]));
    end

    wrappedMapH = zeros(aqPar.imageSizeY, aqPar.imageSizeX);
    wrappedMapV = zeros(aqPar.imageSizeY, aqPar.imageSizeX);
    %Compute phase by sine fitting ever pixel within mask
    for i = 1:aqPar.imageSizeY
        for j = 1:aqPar.imageSizeX
            if(aqPar.mask(i,j))
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