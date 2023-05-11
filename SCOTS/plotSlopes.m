function plotSlopes(aqPar)
    % Read slope data from files
    w_x = readmatrix([aqPar.testName '/postprocessing/w_x_0.txt']);
    w_y = readmatrix([aqPar.testName '/postprocessing/w_y_0.txt']);

    % Plot x slopes
    figure();
    surf(aqPar.mirrorX_mm_, aqPar.mirrorY_mm_, w_x);
    view(2)
    shading interp
    set(gca, 'XDir', 'reverse');
    title("X Slopes");
    xlabel("x_m - mm");
    ylabel("y_m - mm");
    axis square;
    set(gcf, 'Position', [400 200 450 350]);
    colorbar;
    saveas(gcf, [aqPar.testName '/postprocessing/xSlopes.png']);

    % Plot y slopes
    figure();
    surf(aqPar.mirrorX_mm_, aqPar.mirrorY_mm_, w_y);
    view(2)
    shading interp
    set(gca, 'XDir', 'reverse');
    title("Y Slopes");
    xlabel("x_m - mm");
    ylabel("y_m - mm");
    axis square;
    set(gcf, 'Position', [400 200 450 350]);
    colorbar;
    saveas(gcf, [aqPar.testName '/postprocessing/ySlopes.png']);
end
