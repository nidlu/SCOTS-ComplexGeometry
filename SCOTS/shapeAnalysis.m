%% shapeAnalysis
%read w0.txt and plot with tip, tilt, defocus removed
function f = shapeAnalysis(aqPar,geom)
    z = readmatrix([aqPar.testName '/postprocessing/w0.txt']);

    X=linspace(-1,1,length(z));
    Y=linspace(1,-1,length(z));
    [x,y] = meshgrid(X,Y);
    
    indices = [];
    for n = 0:5 %decompose to the 5th degree
        for m = -n:2:n
            indices = [indices; n m];
        end
    end

    % Display the coefficients associated with each Zernike polynomial used in
    % the fit and their corresponding (n,m) indices.
    disp(['    Coeff     ', 'n        ', 'm']);
    moments = zernike_moments(z,indices);
    disp([moments indices]);
    
    %%create maps of tip tilt power and astigmatism
    [t,r] = cart2pol(x,y);
    n = 0; m=0;
    z_piston = moments(indices(:,1) == n & indices(:,2) == m)*zernike(r,t,n,m);
    n = 1; m=-1;
    z_tilty = moments(indices(:,1) == n & indices(:,2) == m)*zernike(r,t,n,m);
    n = 1; m=1;
    z_tiltx = moments(indices(:,1) == n & indices(:,2) == m)*zernike(r,t,n,m);
    n = 2; m=0;
    z_defocus = moments(indices(:,1) == n & indices(:,2) == m)*zernike(r,t,n,m);
    n = 2; m=2;
    z_astigmatism = moments(indices(:,1) == n & indices(:,2) == m)*zernike(r,t,n,m);
    
    figure();
    surface = z-z_piston-z_tiltx-z_tilty-z_defocus;
    surf(aqPar.mirrorX_mm_, aqPar.mirrorY_mm_, surface); shading interp; view(2); 
    PV = max(surface,[],'all')-min(surface,[],'all');
    title(sprintf("Error from Spherical, PV: %.2f mm\n Test: %s",PV,aqPar.testName),'Interpreter', 'none')
    hc=colorbar;
    title(hc,'mm');
    axis square;
    xlabel("x_m - mm");
    ylabel("y_m - mm");
    set(gcf,'Position',[400 200 450 350])
    z_defocus(r>1)=NaN; %defocus 1 since the pupil is defined 0 to 1 above.
    PV_defocus = max(z_defocus,[],'all')-min(z_defocus,[],'all');
    RoC = aqPar.measurementRadius_mm^2 / (2*PV_defocus);
    annotation('textbox', [0.17, 0.13, 0.1, 0.1], 'String', ['RoC:' num2str(RoC/1000,3) 'm'],'BackgroundColor','white')
    
    saveas(gcf,[aqPar.testName '/postprocessing/measuredHeightMapNoDefocus.png'])

    wrappedMapV = readmatrix([aqPar.testName '/postprocessing/wrappedMapV.txt']);
    wrappedMapH = readmatrix([aqPar.testName '/postprocessing/wrappedMapH.txt']);
    figure()
    v = [0,0];
    offset = 0.1;
    surf(aqPar.mirrorX_mm_, aqPar.mirrorY_mm_, surface-offset); shading interp; view(2); 
    hold on;
    contour(aqPar.mirrorX_mm_, aqPar.mirrorY_mm_,...
        wrappedMapH(aqPar.imageMirrorCenterY_px-aqPar.measurementRadius_px:aqPar.imageMirrorCenterY_px+aqPar.measurementRadius_px,...
        aqPar.imageMirrorCenterX_px-aqPar.measurementRadius_px:aqPar.imageMirrorCenterX_px+aqPar.measurementRadius_px),v,'w')
    contour(aqPar.mirrorX_mm_, aqPar.mirrorY_mm_,...
        wrappedMapV(aqPar.imageMirrorCenterY_px-aqPar.measurementRadius_px:aqPar.imageMirrorCenterY_px+aqPar.measurementRadius_px,...
        aqPar.imageMirrorCenterX_px-aqPar.measurementRadius_px:aqPar.imageMirrorCenterX_px+aqPar.measurementRadius_px),v,'w')
    title(sprintf("Residual error, grid, PV: %.2f mm\nPiston, Tilt and Defocus removed",PV))
    xlabel("x_m - mm");
    ylabel("y_m - mm");
    axis square;
    c = colorbar;
    c.TickLabels = c.Ticks+offset;
    set(gcf,'Position',[400 200 450 350])
    view(2)
    saveas(gcf,[aqPar.testName '/postprocessing/residualDeformationAndGrid.png'])
%     figure();
%     surface = z-z_piston-z_tiltx-z_tilty-z_defocus-z_astigmatism;
%     surf(surface); shading interp; view(2); 
%     PV = max(surface,[],'all')-min(surface,[],'all');
%     title(sprintf("Piston, Tilt, Defocus and Astig removed, PV: %.2f mm",PV))
%     hc=colorbar;
%     title(hc,'mm');
end