%% computeShape
function f = computeShape(aqPar, geom)
    %read unwrapped phase
    rectUnwrappedMapV = readmatrix([aqPar.testName '/postprocessing/rectUnwrappedMapV.txt']);
    rectUnwrappedMapH = readmatrix([aqPar.testName '/postprocessing/rectUnwrappedMapH.txt']);
    %set image phase to 0 at screen zero-phase location
    phaseOffsetV = rectUnwrappedMapV(aqPar.imageMaskRadius_px+aqPar.deltaZeroPhaseLocationY, aqPar.imageMaskRadius_px+aqPar.deltaZeroPhaseLocationX);%check xy&sign
    phaseOffsetH = rectUnwrappedMapH(aqPar.imageMaskRadius_px+aqPar.deltaZeroPhaseLocationY, aqPar.imageMaskRadius_px+aqPar.deltaZeroPhaseLocationX);%check xy&sign
    adjRectUnwrappedMapV = rectUnwrappedMapV-phaseOffsetV;
    adjRectUnwrappedMapH = rectUnwrappedMapH-phaseOffsetH;
    
    
    x_m = aqPar.x_m_+geom.mirrorCenterX;
    y_m = aqPar.y_m_+geom.mirrorCenterY;

    %for screen, go to pixel by N*2 pi, then convert to mm and add zero phase
    x_screen_ = adjRectUnwrappedMapV*aqPar.canvasSize_px/(aqPar.N*2*pi)*aqPar.screenPxScale;
    y_screen_ = flip(adjRectUnwrappedMapH)*aqPar.canvasSize_px/(aqPar.N*2*pi)*aqPar.screenPxScale;
    x_screen = x_screen_ + geom.zeroPhaseScreenX;
    y_screen = y_screen_ + geom.zeroPhaseScreenY;
    
    [theta,rho] = cart2pol(aqPar.x,aqPar.y);
    d = 2*rho*aqPar.screen_px_to_mm;
    diameter = 2*aqPar.imageMaskRadius_px*aqPar.screen_px_to_mm;
    
    %calculate distance to screen & camera from mirror
    s = aqPar.RoC - sqrt(aqPar.RoC^2 - ((diameter-d)/2).^2);
    
    %%mirror to camera
    m2c(:,:,1) = geom.cameraX-x_m;
    m2c(:,:,2) = geom.cameraY-y_m;
    m2c(:,:,3) = geom.cameraZ-(geom.mirrorCenterZ+s);
    m2cNorm = vecnorm(m2c, 2, 3); %calculate 2-norm of vector field along the third dimension
    m2cNormalized = m2c./m2cNorm;
    %mirror to screen
    m2s(:,:,1) = x_screen-x_m;
    m2s(:,:,2) = y_screen-y_m;
    m2s(:,:,3) = geom.zeroPhaseScreenZ-(geom.mirrorCenterZ+s);
    m2sNorm = vecnorm(m2s, 2, 3);
    m2sNormalized = m2s./m2sNorm;
       
    avg = (m2cNormalized+m2sNormalized)/2;
    
    avgNorm = vecnorm(avg, 2, 3); %calculate norm of vector field along the third dimension
    avgNormalized = avg./avgNorm;
    
    w_x = avgNormalized(:,:,1);
    w_y = avgNormalized(:,:,2);

    %remove tilt from the image by setting gradient 0 at center
    tiltOffsetX = w_x(aqPar.imageMaskRadius_px, aqPar.imageMaskRadius_px);%check xy&sign
    tiltOffsetY = w_y(aqPar.imageMaskRadius_px, aqPar.imageMaskRadius_px);%check xy&sign
    w_x_0 = w_x-tiltOffsetX;
    w_y_0 = w_y-tiltOffsetY;

    %mask and integrate slopes to create surface
    mask = isnan(w_y_0);
    w_y_0(mask) = 0;
    w_x_0(mask) = 0;
    w = intgrad2(w_x_0,w_y_0, aqPar.screen_px_to_mm, aqPar.screen_px_to_mm);
    
    w(mask)=NaN;
    surf(aqPar.x_m_, aqPar.y_m_, w); shading interp; view(2); 
    set(gca, 'XDir','reverse')
    PV = max(w,[],'all')-min(w,[],'all');
    title(sprintf("Measured height map, PV: %.2f mm",PV))
    hc=colorbar;
    title(hc,'mm');
    xlabel("x_m - mm");
    ylabel("y_m - mm");
    axis square;
    set(gcf,'Position',[400 200 450 350])
    saveas(gcf,[aqPar.testName '/postprocessing/measuredHeightMap.png'])
    
    writematrix(w,[aqPar.testName '/postprocessing/w0.txt']);
end
