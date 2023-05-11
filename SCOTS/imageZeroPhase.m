function imageZeroPhase(aqPar,cam,cameraParams)
    backg = uint8(zeros(aqPar.canvasSize_px,aqPar.canvasSize_px,3));
    c = round(aqPar.canvasSize_px/2);
    backg(c-2:c+2,c-2:c+2,:) = 255;
    backg(c-2:c+2,c-2:c+2,:) = 255;
    hFigure = figure();
    set(hFigure, 'MenuBar', 'none');
	set(hFigure, 'ToolBar', 'none');
    imshow(backg,'Border','tight');
    set(gcf,'Position',aqPar.canvasPosition_px)
    drawnow;
    %truesize
    pause(0.5)
    undistortedImg = uint16(exposeASI(cam,cameraParams,aqPar.imageResizingFactor));
    figure()
    imshow(undistortedImg);
    imwrite(undistortedImg,[aqPar.testName '/images/imageZeroPhase.png']);
end