%% plot phaseMap
function plotPhaseMap(aqPar)
    wrappedMapV = readmatrix([aqPar.testName '/postprocessing/wrappedMapV.txt']);
    wrappedMapH = readmatrix([aqPar.testName '/postprocessing/wrappedMapH.txt']);
    figure()
    surf(aqPar.mirrorX_mm_, aqPar.mirrorY_mm_, wrappedMapH(aqPar.imageMirrorCenterY_px-aqPar.measurementRadius_px:aqPar.imageMirrorCenterY_px+aqPar.measurementRadius_px,...
                                             aqPar.imageMirrorCenterX_px-aqPar.measurementRadius_px:aqPar.imageMirrorCenterX_px+aqPar.measurementRadius_px))
    set(gca, 'XDir','reverse')
    title("Measured horizontal phase map")
    xlabel("x_m - mm");
    ylabel("y_m - mm");
    axis square;
    set(gcf,'Position',[400 200 450 350])
    colorbar
    view(2)
    shading interp
    colorbar
    view(2)
    saveas(gcf,[aqPar.testName '/postprocessing/wrappedMapH.png'])

    figure()
    surf(aqPar.mirrorX_mm_, aqPar.mirrorY_mm_, wrappedMapV(aqPar.imageMirrorCenterY_px-aqPar.measurementRadius_px:aqPar.imageMirrorCenterY_px+aqPar.measurementRadius_px,...
                                             aqPar.imageMirrorCenterX_px-aqPar.measurementRadius_px:aqPar.imageMirrorCenterX_px+aqPar.measurementRadius_px))
    set(gca, 'XDir','reverse')
    title("Measured vertical phase map")
    shading interp
    xlabel("x_m - mm");
    ylabel("y_m - mm");
    axis square;
    set(gcf,'Position',[400 200 450 350])
    colorbar
    view(2)
    saveas(gcf,[aqPar.testName '/postprocessing/wrappedMapV.png'])
end