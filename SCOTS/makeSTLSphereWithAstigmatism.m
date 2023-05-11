function makeSTLSphereWithAstigmatism(geom, aqPar, astigmatism, filename)
    % Extract relevant parameters
    RoC = geom.RoC; % Radius of curvature (mm)
    mirrorRadius = geom.mirrorRadius; % Mirror radius (mm)

    % Define a finer grid resolution
    gridResolution = 1; % Change this value to control the grid resolution

    % Create a new, finer meshgrid for the mirror
    x = -mirrorRadius:gridResolution:mirrorRadius;
    y = x;
    [mirrorX_mm_, mirrorY_mm_] = meshgrid(x, y);

    % Calculate the corresponding Z coordinates based on the RoC
    mirrorZ_mm_ = RoC - sqrt(RoC^2 - mirrorX_mm_.^2 - mirrorY_mm_.^2);

    % Add astigmatism aberration
    rho = sqrt(mirrorX_mm_.^2 + mirrorY_mm_.^2) / mirrorRadius;
    theta = atan2(mirrorY_mm_, mirrorX_mm_);
    zernike_astigmatism = astigmatism * 1e-3 * (2 * (rho.^2) .* cos(2 * theta));
    mirrorZ_mm_ = mirrorZ_mm_ + zernike_astigmatism;

    % Create a mask to limit the coordinates within the mirror radius
    mask = (mirrorX_mm_.^2 + mirrorY_mm_.^2) <= mirrorRadius^2;
    measuredMask = (mirrorX_mm_.^2 + mirrorY_mm_.^2) <= aqPar.measurementRadius_mm^2;

    % Remove NaN values and invalid coordinates
    validIndices = mask;
    X_valid = mirrorX_mm_(validIndices);
    Y_valid = mirrorY_mm_(validIndices);
    S_valid = mirrorZ_mm_(validIndices);

    % Create a triangulation object
    DT = delaunayTriangulation(X_valid, Y_valid);
    TR = triangulation(DT.ConnectivityList, DT.Points(:, 1), DT.Points(:, 2), S_valid);

    % Save the triangulation object as an STL file
    stlwrite(TR, filename);
    
    % Plot debugging
    zernike_astigmatism(~measuredMask)=nan;
    surf(mirrorX_mm_, mirrorY_mm_,zernike_astigmatism); shading interp; view(2); 
    hc=colorbar;
    title(hc,'mm');
    PV = max(zernike_astigmatism,[],'all')-min(zernike_astigmatism,[],'all');
    title(sprintf("True error from Spherical, PV: %.2f mm\n Test: %s",PV,aqPar.testName),'Interpreter', 'none')
    hc=colorbar;
    title(hc,'mm');
    axis square;
    xlabel("x_m - mm");
    ylabel("y_m - mm");
    set(gcf,'Position',[400 200 450 350])
    %z_defocus(r>1)=NaN; %defocus 1 since the pupil is defined 0 to 1 above.
    %PV_defocus = max(mirrorZ_mm_,[],'all')-min(mirrorZ_mm_,[],'all');
    %RoC = geom.mirrorRadius^2 / (2*PV_defocus);
    annotation('textbox', [0.17, 0.13, 0.1, 0.1], 'String', ['RoC:' num2str(RoC/1000,3) 'm'],'BackgroundColor','white')
    saveas(gcf,[aqPar.testName '/postprocessing/STLHeightMapNoDefocus.png'])
    
    % Calculate the partial derivatives (slopes) in x and y
    [slopeX, slopeY] = gradient(mirrorZ_mm_);

    % Create a new figure for the slopes
    figure;

    % Plot the x slopes using imagesc
    subplot(1, 2, 1);
    imagesc(x, y, slopeX .* mask);
    title('X Slopes');
    xlabel('x_m - mm');
    ylabel('y_m - mm');
    axis square;
    colorbar;

    % Plot the y slopes using imagesc
    subplot(1, 2, 2);
    imagesc(x, y, slopeY .* mask);
    title('Y Slopes');
    xlabel('x_m - mm');
    ylabel('y_m - mm');
    axis square;
    colorbar;

    % Save the slope plots as an image file
    set(gcf, 'Position', [400 200 900 350]);
    saveas(gcf, [aqPar.testName '/postprocessing/SlopePlots.png']);
end
