%% shapeAnalysis
%read w0.txt and plot with tip, tilt, defocus removed
function shapeAnalysis(aqPar)
    z = readmatrix([aqPar.testName '/postprocessing/w0.txt']);

    Z_corrected = z; % Initialize a corrected matrix Z
    rho_Z=((aqPar.mirrorX_mm_.^2+aqPar.mirrorY_mm_.^2).^0.5)/(aqPar.measurementRadius_mm);
    theta_Z=atan2(aqPar.mirrorY_mm_,aqPar.mirrorX_mm_);

    coef_Zernike = decomposition_Zernike(rho_Z, theta_Z, z, 15);
    % Calculate and subtract piston, tip, and tilt
    for i = [1,2,3] % For the first four Zernike modes (start from 0 as per Malacara's convention)
        Z_mode(:,:,i) = calcul_mode_zernike_Malacara2(i-1, rho_Z, theta_Z);
        Z_corrected = Z_corrected - coef_Zernike(i) * Z_mode(:,:,i);
    end   
    
    Z_mode(:,:,5) = calcul_mode_zernike_Malacara2(5-1, rho_Z, theta_Z);
    Z_corrected = Z_corrected - coef_Zernike(5) * Z_mode(:,:,5);
    
    %Z_mode(:,:,13) = calcul_mode_zernike_Malacara2(13-1, rho_Z, theta_Z);
    %Z_corrected = Z_corrected - coef_Zernike(13) * Z_mode(:,:,13);

    figure()
    surf(aqPar.mirrorX_mm_, aqPar.mirrorY_mm_, Z_corrected); shading interp; view(2); 
    PV = max(Z_corrected,[],'all')-min(Z_corrected,[],'all');
    title(sprintf("Error from Spherical, PV: %.2f mm\n Test: %s",PV,aqPar.testName(end-30:end)),'Interpreter', 'none')
    hc=colorbar;
    title(hc,'mm');
    axis square;
    xlabel("x_m - mm");
    ylabel("y_m - mm");
    set(gcf,'Position',[400 200 450 350])
    z_defocus = coef_Zernike(5)*Z_mode(:,:,5);
    z_defocus(rho_Z>1)=NaN; %defocus 1 since the pupil is defined 0 to 1 above.
    PV_defocus = max(z_defocus,[],'all')-min(z_defocus,[],'all');
    RoC = aqPar.measurementRadius_mm^2 / (2*PV_defocus);
    annotation('textbox', [0.17, 0.13, 0.1, 0.1], 'String', ['RoC:' num2str(RoC/1000,3) 'm'],'BackgroundColor','white')
    
    saveas(gcf,[aqPar.testName '/postprocessing/measuredHeightMapNoDefocus.png'])

%     wrappedMapV = readmatrix([aqPar.testName '/postprocessing/wrappedMapV.txt']);
%     wrappedMapH = readmatrix([aqPar.testName '/postprocessing/wrappedMapH.txt']);
%     figure()
%     v = [0,0];
%     offset = 0.1;
%     surf(aqPar.mirrorX_mm_, aqPar.mirrorY_mm_, surface-offset); shading interp; view(2); 
%     hold on;
%     contour(aqPar.mirrorX_mm_, aqPar.mirrorY_mm_,...
%         wrappedMapH(aqPar.imageMirrorCenterY_px-aqPar.measurementRadius_px:aqPar.imageMirrorCenterY_px+aqPar.measurementRadius_px,...
%         aqPar.imageMirrorCenterX_px-aqPar.measurementRadius_px:aqPar.imageMirrorCenterX_px+aqPar.measurementRadius_px),v,'w')
%     contour(aqPar.mirrorX_mm_, aqPar.mirrorY_mm_,...
%         wrappedMapV(aqPar.imageMirrorCenterY_px-aqPar.measurementRadius_px:aqPar.imageMirrorCenterY_px+aqPar.measurementRadius_px,...
%         aqPar.imageMirrorCenterX_px-aqPar.measurementRadius_px:aqPar.imageMirrorCenterX_px+aqPar.measurementRadius_px),v,'w')
%     title(sprintf("Residual error, grid, PV: %.2f mm\nPiston, Tilt and Defocus removed",PV))
%     xlabel("x_m - mm");
%     ylabel("y_m - mm");
%     axis square;
%     c = colorbar;
%     c.TickLabels = c.Ticks+offset;
%     set(gcf,'Position',[400 200 450 350])
%     view(2)
%     saveas(gcf,[aqPar.testName '/postprocessing/residualDeformationAndGrid.png'])
%     figure();
%     surface = z-z_piston-z_tiltx-z_tilty-z_defocus-z_astigmatism;
%     surf(surface); shading interp; view(2); 
%     PV = max(surface,[],'all')-min(surface,[],'all');
%     title(sprintf("Piston, Tilt, Defocus and Astig removed, PV: %.2f mm",PV))
%     hc=colorbar;
%     title(hc,'mm');
end