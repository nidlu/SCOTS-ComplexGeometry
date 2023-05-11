function img = showImagedArea(aqPar)
    img = imread([aqPar.testName '/images/imageZeroPhase.png']);
    imagesc(img);
    hold on;
    th = 0:pi/50:2*pi;
    r = aqPar.measurementRadius_px;
    xunit = r * cos(th) + aqPar.imageMirrorCenterX_px;
    yunit = r * sin(th) + aqPar.imageMirrorCenterY_px;
    h = plot(xunit, yunit);
    saveas(gcf, [aqPar.testName '/postprocessing/imageLocation'],'png');
end