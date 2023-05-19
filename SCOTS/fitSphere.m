function [sphere_params, Z_sphere] = fitSphere(X, Y, Z)
    % Flatten arrays for use with least squares, and remove NaNs
    notNaNs = ~isnan(Z);  % logical index of not-NaN values
    Xf = X(notNaNs); Yf = Y(notNaNs); Zf = Z(notNaNs);

    % Define function for sphere
    sphere = @(p, x, y, z) abs(sqrt((x - p(1)).^2 + (y - p(2)).^2 + (z - p(3)).^2) - p(4));

    % Initial guess for sphere parameters [x0, y0, z0, r]
    p0 = [mean(Xf), mean(Yf), mean(Zf), 2500];  % Use your known radius of curvature as the initial guess for r

    % Perform least squares fitting for sphere
    options = optimset('Display','iter');
    sphere_params = lsqnonlin(@(p) sphere(p, Xf, Yf, Zf), p0, [], [], options);

    % Calculate the fitted spherical shape
    X_c = X - sphere_params(1);
    Y_c = Y - sphere_params(2);
    R_square = sphere_params(4)^2 - X_c.^2 - Y_c.^2;
    mask = R_square < 0;
    R_square(mask) = 0;
    Z_sphere = sqrt(R_square) + sphere_params(3);

    % Adjust for "downward" or "upward" dome
    if mean(Z(:)) < sphere_params(3)
        Z_sphere = 2*sphere_params(3) - Z_sphere;
    end
end
