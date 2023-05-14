%% computeSlope REMOVED PHASE OFFSET
function computeSlope(aqPar, geom)
    %read unwrapped phase, and flip because screen is flipped.
    rectUnwrappedMapV = -readmatrix([aqPar.testName '/postprocessing/rectUnwrappedMapV.txt']);
    rectUnwrappedMapH = readmatrix([aqPar.testName '/postprocessing/rectUnwrappedMapH.txt']);
    
    adjRectUnwrappedMapV = rectUnwrappedMapV;%-phaseOffsetV;
    adjRectUnwrappedMapH = rectUnwrappedMapH;%-phaseOffsetH;
    
    mirrorX_mm = aqPar.mirrorX_mm_+geom.mirrorCenterX;
    mirrorY_mm = aqPar.mirrorY_mm_+geom.mirrorCenterY;

    %for screen, go to pixel by N*2 pi, then convert to mm and add zero phase
    x_screen_ = adjRectUnwrappedMapV*aqPar.canvasSize_px/(aqPar.fringesOnCanvas*2*pi)*aqPar.screen_mm_per_px;
    y_screen_ = adjRectUnwrappedMapH*aqPar.canvasSize_px/(aqPar.fringesOnCanvas*2*pi)*aqPar.screen_mm_per_px;
    x_screen = x_screen_ + geom.zeroPhaseScreenX;
    y_screen = y_screen_ + geom.zeroPhaseScreenY;
    
    [theta,rho] = cart2pol(aqPar.mirrorX_px_,aqPar.mirrorY_px_);
    d = 2*rho*aqPar.image_mm_per_px;
    diameter = 2*aqPar.measurementRadius_px*aqPar.image_mm_per_px;
    
    %calculate distance to screen & camera from mirror
    s = -(geom.RoC - sqrt(geom.RoC^2 - ((diameter-d)/2).^2));
    s = s+max(abs(s),[],'All');
    s = -s*10;
    
    %s=0;
    %%mirror to camera
    m2c(:,:,1) = geom.cameraX-mirrorX_mm;
    m2c(:,:,2) = geom.cameraY-mirrorY_mm;
    m2c(:,:,3) = geom.cameraZ-(geom.mirrorCenterZ+s);
    m2cNorm = vecnorm(m2c, 2, 3); %calculate 2-norm of vector field along the third dimension
    m2cNormalized = m2c./m2cNorm;
    %mirror to screen
    m2s(:,:,1) = x_screen-mirrorX_mm;
    m2s(:,:,2) = y_screen-mirrorY_mm;
    m2s(:,:,3) = geom.zeroPhaseScreenZ-(geom.mirrorCenterZ+s);
    m2sNorm = vecnorm(m2s, 2, 3);
    m2sNormalized = m2s./m2sNorm;
       
    avg = m2cNormalized + m2sNormalized;
    avgNorm = vecnorm(avg, 2, 3); % Calculate norm of vector field along the third dimension
    avgNormalized = avg ./ avgNorm;
    
    w_x = -avgNormalized(:,:,1)./avgNormalized(:,:,3);
    w_y = -avgNormalized(:,:,2)./avgNormalized(:,:,3);

    %imagesc(curl(w_x_0,w_y_0));

    writematrix(w_x,[aqPar.testName '/postprocessing/w_x_0.txt']);
    writematrix(w_y,[aqPar.testName '/postprocessing/w_y_0.txt']);
end

%     avg = (m2cNormalized+m2sNormalized)/2;
%     avgNorm = vecnorm(avg, 2, 3); %calculate norm of vector field along the third dimension
%     avgNormalized = avg./avgNorm;

%     w_x_0 = w_x;%-tiltOffsetX;
%     w_y_0 = w_y;%-tiltOffsetY;
    %remove tilt from the image by setting gradient 0 at center
    %tiltOffsetX = w_x(aqPar.measurementRadius_px, aqPar.measurementRadius_px);%check xy&sign
    %tiltOffsetY = w_y(aqPar.measurementRadius_px, aqPar.measurementRadius_px);%check xy&sign
