%% shapeAnalysis
%read w0.txt and plot with tip, tilt, defocus removed
function shapeAnalysis(aqPar)
    z = readmatrix([aqPar.testName '/postprocessing/w0.txt']);

    Z_corrected = z; % Initialize a corrected matrix Z
    
    rho_Z=((aqPar.mirrorX_mm_.^2+aqPar.mirrorY_mm_.^2).^0.5)/(aqPar.measurementRadius_mm);
    theta_Z=atan2(aqPar.mirrorY_mm_,aqPar.mirrorX_mm_);

    coef_Zernike = decomposition_Zernike(rho_Z, theta_Z, z, 15);
    % Calculate and subtract piston, tip, and tilt
    disp("warning not subtracting tilt, manual piston offset")

%     for i = [1] % For the first four Zernike modes (start from 0 as per Malacara's convention)
%         Z_mode(:,:,i) = calcul_mode_zernike_Malacara2(i-1, rho_Z, theta_Z);
%         Z_corrected = Z_corrected - coef_Zernike(i) * Z_mode(:,:,i);
%     end   
%     
    disp("warning lots of changes, divide by 5 and piston");
    Z_mode(:,:,5) = calcul_mode_zernike_Malacara2(5-1, rho_Z, theta_Z);
    Z_corrected = Z_corrected - coef_Zernike(5) * Z_mode(:,:,5);
    Z_corrected = Z_corrected-min(min(Z_corrected));
    %Z_corrected = Z_corrected/5;
    %Z_mode(:,:,13) = calcul_mode_zernike_Malacara2(13-1, rho_Z, theta_Z);
    %Z_corrected = Z_corrected - coef_Zernike(13) * Z_mode(:,:,13);
    
    figure()
    surf(aqPar.mirrorX_mm_, aqPar.mirrorY_mm_, Z_corrected*1000); shading interp; view(2); 
    PV = max(Z_corrected,[],'all')-min(Z_corrected,[],'all');
    name = '50mm offset, sagitta included';
    if(length(name)>30); name = aqPar.testName(end-30:end); end
    title(sprintf("Error from Parabolic, PV: %.2f um\n Test: %s",PV*1000,'10um tip displacement'),'Interpreter', 'none')
    %title(sprintf("Error from Parabolic, PV: %.2f um\n Test: %s",PV*1000,name),'Interpreter', 'none')
    hc=colorbar;
    title(hc,'\mum');
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
    
    %% Plot difference vs STL
    measPoints = readmatrix('SCOTS\STL\samPoints');
    measEdges = readmatrix('SCOTS\STL\samEdges');
    measTriangles = readmatrix('SCOTS\STL\samTriangles');
    measDeflection = readmatrix('SCOTS\STL\samDeflection');
    Z_mirrorRef = 10*1000*griddata(measPoints(1,:)*1000, measPoints(2,:)*1000, measDeflection, aqPar.mirrorX_mm_, aqPar.mirrorY_mm_, 'linear');
    
    error = (Z_mirrorRef-z)*1000;
    figure;imagesc(error);colorbar;
    
    
    coef_Zernike = decomposition_Zernike(rho_Z, theta_Z, error, 15);
    for i = [1,2,3] % For the first four Zernike modes (start from 0 as per Malacara's convention)
        Z_mode(:,:,i) = calcul_mode_zernike_Malacara2(i-1, rho_Z, theta_Z);
        error = error - coef_Zernike(i) * Z_mode(:,:,i);
    end   
    figure()
    surf(aqPar.mirrorX_mm_, aqPar.mirrorY_mm_, error);
    shading interp; view(2); 
    title("");
    RMS = rms(error(~isnan(error)));
    titleStr = sprintf('Error from Tip Displacement, RMS: %.2f \\mum', RMS);
    title(titleStr);

    hc=colorbar;
    title(hc,'\mum');
    axis square;
    xlabel("x_m - mm");
    ylabel("y_m - mm");
    set(gcf,'Position',[400 200 450 350])
    
end