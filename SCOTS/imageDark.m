%% imageDark
function f = imageDark(aqPar,cam,cameraParams)
    backg = uint8(zeros(aqPar.canvasSize_px,aqPar.canvasSize_px,3));
    hFigure = figure();
    set(hFigure, 'MenuBar', 'none');
	set(hFigure, 'ToolBar', 'none');
    imshow(backg,'Border','tight');
    set(gcf,'Position',aqPar.canvasPosition_px)
    %truesize
    pause(0.01)
    rawImg = uint16(exposeASI(cam,cameraParams,aqPar.imageResizingFactor));
    figure(2)
    imshow(rawImg);
    imwrite(rawImg,[aqPar.testName '/images/imageDark.png']);
end