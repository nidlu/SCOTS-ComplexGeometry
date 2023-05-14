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
    
    %% gradient removal plot
    % Create meshgrid for linear gradient computation
    [X, Y] = meshgrid(1:size(w_x, 2), 1:size(w_x, 1));

    % Flatten w_x and meshgrid values, remove NaN entries
    w_x_0_flat = w_x(:);
    X_flat = X(:);
    Y_flat = Y(:);
    non_nan_indices = ~isnan(w_x_0_flat);
    w_x_0_flat_non_nan = w_x_0_flat(non_nan_indices);
    X_flat_non_nan = X_flat(non_nan_indices);
    Y_flat_non_nan = Y_flat(non_nan_indices);

    % Compute linear gradients using polyfit (1st degree polynomial fit)
    p_x = polyfit(X_flat_non_nan, w_x_0_flat_non_nan, 1);
    p_y = polyfit(Y_flat_non_nan, w_x_0_flat_non_nan, 1);
    lin_grad_x = polyval(p_x, X);
    lin_grad_y = polyval(p_y, Y);

    % Subtract linear gradients from w_x
    w_x_0_subtracted = w_x - lin_grad_x - lin_grad_y;

    % Plot the subtracted w_x
    figure;
    imagesc(w_x_0_subtracted);
    colorbar;
    title('w_x after subtracting linear gradients');
    xlabel('x');
    ylabel('y');
    saveas(gcf,[aqPar.testName '/postprocessing/w_x_0_subtracted.png']);
end
