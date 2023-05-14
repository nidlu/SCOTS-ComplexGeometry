function mask = petalMask(radius, innerRadius, petalStartRadius, center,...
                            gapWidth, n_petals, imageSizeX, imageSizeY)
    %imagesc(petalMask(100, 20,30, [100,100], 5,6,400,400))
    %imagesc(petalMask(100, 0,0, [100,100], 0,1,400,400))
    theta = linspace(0, 2*pi, n_petals+1);
    
    %center(2) = imageSizeY-center(2) %flip to image coordinates.

    [x, y] = meshgrid(1:imageSizeX, 1:imageSizeY);
    %y = flip(y);

    mask = zeros(imageSizeY, imageSizeX);

    for i = 1:n_petals
        angle = atan2(y-center(2), x-center(1));
        angle(angle<0) = angle(angle<0) + 2*pi;
        rad = sqrt((x-center(1)).^2 + (y-center(2)).^2);
        angleGap = gapWidth ./ rad;
        angleGap(rad < petalStartRadius) = 0;

        in_petal = (rad <= radius) & ...
            (rad > innerRadius | (innerRadius == 0 & rad == 0)) & ...
            (angle >= theta(i) + angleGap) & ...
            (angle < theta(i+1) - angleGap);

        mask(in_petal) = 1;
    end
    
    if innerRadius == 0 %fixes centerPoint issue
        mask(center(2), center(1)) = 1;
    end
end
