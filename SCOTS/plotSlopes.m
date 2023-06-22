function plotSlopes(aqPar)
    % Read slope data from files
    w_x = readmatrix([aqPar.testName '/postprocessing/w_x_0.txt']);
    w_y = readmatrix([aqPar.testName '/postprocessing/w_y_0.txt']);

    % Create meshgrid for linear gradient computation
    [X, Y] = meshgrid(1:size(w_x, 2), 1:size(w_x, 1));

    % Compute and subtract gradients for both x and y slopes
    w_x_subtracted = subtractLinearGradients(X, Y, w_x);
    w_y_subtracted = subtractLinearGradients(X, Y, w_y);

    % Plot original slopes
    figure();
    subplot(1, 2, 1);
    plotSlope(aqPar, w_x, 'X Slopes');
    subplot(1, 2, 2);
    plotSlope(aqPar, w_y, 'Y Slopes');
    saveas(gcf, [aqPar.testName '/postprocessing/originalSlopes.png']);

    % Plot subtracted slopes
    figure();
    subplot(1, 2, 1);
    imagesc(w_x_subtracted);
    colorbar;
        axis square;
    title('X Slopes, Linear gradient subtracted');
    xlabel('x');
    ylabel('y');
    subplot(1, 2, 2);
    imagesc(w_y_subtracted);
    colorbar;
        axis square;
    title('Y Slopes, Linear gradient subtracted');
    xlabel('x');
    ylabel('y');
    saveas(gcf,[aqPar.testName '/postprocessing/subtractedSlopes.png']);
end

function plotSlope(aqPar, w, titleStr)
    surf(aqPar.mirrorX_mm_, aqPar.mirrorY_mm_, w);
    view(2);
    shading interp;
    set(gca, 'XDir', 'reverse');
    title(titleStr);
    xlabel("x_m - mm");
    ylabel("y_m - mm");
    axis square;
    colorbar;
end

function w_subtracted = subtractLinearGradients(X, Y, w)
    % Flatten w and meshgrid values, remove NaN entries
    w_flat = w(:);
    X_flat = X(:);
    Y_flat = Y(:);
    non_nan_indices = ~isnan(w_flat);
    w_flat_non_nan = w_flat(non_nan_indices);
    X_flat_non_nan = X_flat(non_nan_indices);
    Y_flat_non_nan = Y_flat(non_nan_indices);

    % Compute linear gradients using polyfit (1st degree polynomial fit)
    p_x = polyfit(X_flat_non_nan, w_flat_non_nan, 1);
    p_y = polyfit(Y_flat_non_nan, w_flat_non_nan, 1);
    lin_grad_x = polyval(p_x, X);
    lin_grad_y = polyval(p_y, Y);

    % Subtract linear gradients from w
    w_subtracted = w - lin_grad_x - lin_grad_y;
end
