%% imagePhases
function imagePhases = imagePhases(aqPar,cam,cameraParams);
    hFig = figure();
    set(gcf, 'MenuBar', 'none');
    set(gcf, 'ToolBar', 'none');
    set(gcf,'Position',aqPar.canvasPosition_px)
    for phase = aqPar.phases
        %Draw and image vertical
        x = ones(aqPar.canvasSize_px,aqPar.canvasSize_px).*(1:aqPar.canvasSize_px);
        x = x-max(max(x))/2; %zero phase in center
        
        fringePattern = 255*(sin(x/aqPar.canvasSize_px*2*pi*aqPar.fringesOnCanvas+phase)+1)/2;
        fPtoImg = uint8(repmat(fringePattern,1,1,3));
        imshow(fPtoImg, 'InitialMagnification', 'fit','Border','tight')
        drawnow;
        pause(0.2);
        undistortedImage = uint16(exposeASI(cam,cameraParams,aqPar.imageResizingFactor));
        imwrite(undistortedImage,[aqPar.testName '/images/imagePhaseV' num2str(phase,'%.4f') '.png']);
        %fid = fopen([aqPar.testName '/bin/imagePhaseV' num2str(phase,'%.4f') '.bin'], 'w');
        %fwrite(fid,rawImage,'uint16');
        %fclose(fid);
        
        fringePattern = 255*(sin(x/aqPar.canvasSize_px*2*pi*aqPar.fringesOnCanvas-phase)+1)/2;
        fringePattern = fringePattern';
       
        fPtoImg = uint8(repmat(fringePattern,1,1,3));
        imshow(fPtoImg, 'InitialMagnification', 'fit','Border','tight')
        drawnow;
        pause(0.2);
        undistortedImage = uint16(exposeASI(cam,cameraParams,aqPar.imageResizingFactor));
        imwrite(undistortedImage,[aqPar.testName '/images/imagePhaseH' num2str(phase, '%.4f') '.png']);
        %fid = fopen([aqPar.testName '/bin/imagePhaseH' num2str(phase,'%.4f') '.bin'], 'w');
        %fwrite(fid,rawImage,'uint16');
        %fclose(fid);
    end
%     fid = fopen('p2.bin');
%     p3 = uint16(reshape(fread(fid,'uint16'),1280,960));
%     fclose(fid);
end