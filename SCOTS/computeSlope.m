%% computeSlope REMOVED PHASE OFFSET
function computeSlope(aqPar, geom,centX0,centY0)
    %read unwrapped phase, and flip because screen is flipped.
    unwrappedMapV = readmatrix([aqPar.testName '/postprocessing/unwrappedMapV.txt']);
    unwrappedMapH = readmatrix([aqPar.testName '/postprocessing/unwrappedMapH.txt']);

    disp("computeSlope: warning, phaseoffset set manually");
    phaseOffsetV = unwrappedMapV(centY0,centX0)-0.025; %2.7;%1.419;%01.42;%1.42;
    phaseOffsetH = unwrappedMapH(centY0,centX0)+aqPar.zeroPhaseOffset - 0.12; 

    adjUnwrappedMapV = unwrappedMapV-phaseOffsetV;
    adjUnwrappedMapH = unwrappedMapH-phaseOffsetH;
    
    mirrorX_mm = aqPar.mirrorX_mm_+geom.mirrorCenterX;
    mirrorY_mm = aqPar.mirrorY_mm_+geom.mirrorCenterY;

    %for screen, go to pixel by N*2 pi, then convert to mm and add zero phase
    x_screen_ = adjUnwrappedMapV*aqPar.canvasSize_px/(aqPar.fringesOnCanvas*2*pi)*aqPar.screen_mm_per_px;
    y_screen_ = adjUnwrappedMapH*aqPar.canvasSize_px/(aqPar.fringesOnCanvas*2*pi)*aqPar.screen_mm_per_px;
    x_screen = x_screen_ + geom.zeroPhaseScreenX;
    y_screen = y_screen_ + geom.zeroPhaseScreenY;
    
    %sphere
    %s = -sqrt(geom.RoC^2 - aqPar.mirrorX_mm_.^2 - aqPar.mirrorY_mm_.^2)+geom.RoC;
    %paraboloid
    %s = (aqPar.mirrorX_mm_.^2 + aqPar.mirrorY_mm_.^2) / (2*geom.RoC);
    %s(aqPar.mirrorX_mm_.^2 + aqPar.mirrorY_mm_.^2 > 95^2) = NaN;
    disp("computeSlope: not including sphericity")
    s=0;
    
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
    
    tiltDiff_x_percent = ( max(w_x(:))+min(w_x(:)) )/( (max(w_x(:))-min(w_x(:))) ) * 100
    tiltDiff_y_percent = ( max(w_y(:))+min(w_y(:)) )/( (max(w_y(:))-min(w_y(:))) ) * 100
    %imagesc(curl(w_x_0,w_y_0));

    writematrix(w_x,[aqPar.testName '/postprocessing/w_x_0.txt']);
    writematrix(w_y,[aqPar.testName '/postprocessing/w_y_0.txt']);
end