function f = showZeroPhase(aqPar)
    backg = uint8(zeros(aqPar.canvasSize_px,aqPar.canvasSize_px,3));
    loc = round(aqPar.canvasSize_px/2)-1:round(aqPar.canvasSize_px/4)+1;
    backg(:,loc,:) = 255;
    loc = round(aqPar.canvasSize_px/4)-1:round(aqPar.canvasSize_px/4)+1;
    backg(:,loc,:) = 255;
    loc = round(aqPar.canvasSize_px*3/4)-1:round(aqPar.canvasSize_px/4)+1;
    backg(:,loc,:) = 255;
    loc = round(aqPar.canvasSize_px/2)-1:round(aqPar.canvasSize_px/4)+1;
    backg(loc,:,:) = 255;
    loc = round(aqPar.canvasSize_px/4)-1:round(aqPar.canvasSize_px/4)+1;
    backg(loc,:,:) = 255;
    loc = round(aqPar.canvasSize_px*3/4)-1:round(aqPar.canvasSize_px/4)+1;
    backg(loc,:,:) = 255;
    backg(:,round(aqPar.canvasSize_px/2),:) = 255;
    backg(round(aqPar.canvasSize_px/2),:,:) = 255;
    backg(:,round(aqPar.canvasSize_px*3/4),:) = 255;
    backg(round(aqPar.canvasSize_px/4),:,:) = 255;
    backg(round(aqPar.canvasSize_px*3/4),:,:) = 255;
    
    hFigure = figure();
    set(hFigure, 'MenuBar', 'none');
	set(hFigure, 'ToolBar', 'none');
    imshow(backg,'Border','tight');
    set(gcf,'Position',aqPar.canvasPosition_px)
end