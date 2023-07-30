function plotPhaseMap(aqPar)
    wrappedMapV = readmatrix([aqPar.testName '/postprocessing/wrappedMapV.txt']);
    wrappedMapH = readmatrix([aqPar.testName '/postprocessing/wrappedMapH.txt']);

    bbox = boundingBox(aqPar.mask);

    figure()
    surf(aqPar.mirrorX_mm_, aqPar.mirrorY_mm_, wrappedMapV(bbox.rows, bbox.cols))
    set(gca, 'XDir','reverse')
    title("Measured horizontal phase map")
    xlabel("x_m - mm");
    ylabel("y_m - mm");
    axis square;
    set(gcf,'Position',[400 200 450 350])
    colorbar
    view(2)
    shading interp
    saveas(gcf,[aqPar.testName '/postprocessing/wrappedMapH.png'])

    figure()
    surf(aqPar.mirrorX_mm_, aqPar.mirrorY_mm_, wrappedMapH(bbox.rows, bbox.cols))
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
