function computePhaseMap(aqPar,inputDir,outputDir)
    % read files
    imageHPhaseNames = dir([inputDir '/ds_imagePhaseH*']);
    imageVPhaseNames = dir([inputDir '/ds_imagePhaseV*']);
    imageHPhaseNames = natsortfiles(imageHPhaseNames);
    imageVPhaseNames = natsortfiles(imageVPhaseNames);

    % load images
    for i=1:length(imageHPhaseNames)
        imagesH(:,:,i) = im2gray(imread([inputDir '/' imageHPhaseNames(i).name]));
        imagesV(:,:,i) = im2gray(imread([inputDir '/' imageVPhaseNames(i).name]));
    end

    % Determine global minimum and maximum intensity within the mask
    mask3D = logical(repmat(aqPar.mask, 1, 1, size(imagesH, 3)));
    globalMinH = min(imagesH(mask3D));
    globalMaxH = max(imagesH(mask3D));
    globalMinV = min(imagesV(mask3D));
    globalMaxV = max(imagesV(mask3D));

    % rescale images using global min and max
    imagesH = rescale(imagesH,-1,1,'InputMin',globalMinH,'InputMax',globalMaxH);
    imagesV = rescale(imagesV,-1,1,'InputMin',globalMinV,'InputMax',globalMaxV);

    wrappedMapH = zeros(aqPar.imageSizeY, aqPar.imageSizeX);
    wrappedMapV = zeros(aqPar.imageSizeY, aqPar.imageSizeX);
    
    % Compute phase by sine fitting ever pixel within mask
    for i = 1:aqPar.imageSizeY
        for j = 1:aqPar.imageSizeX
            if(aqPar.mask(i,j))
                imageValuesH = double(reshape(imagesH(i,j,:),1,[]));
                imageValuesV = double(reshape(imagesV(i,j,:),1,[]));
                wrappedMapH(i,j) = sineFitRestricted(aqPar.phases,imageValuesH,false);
                wrappedMapV(i,j) = sineFitRestricted(aqPar.phases,imageValuesV,false);
            else
                wrappedMapH(i,j) = NaN;
                wrappedMapV(i,j) = NaN;
            end
        end
    end
    writematrix(wrappedMapH,[outputDir '/wrappedMapH.txt']);
    writematrix(wrappedMapV,[outputDir '/wrappedMapV.txt']);
end
