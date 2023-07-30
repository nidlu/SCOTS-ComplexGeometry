% Define sphere parameters
radius = 2500;  % mm
center = [0, 0, 0];  % mm

% Generate a part of the sphere
[X, Y] = meshgrid(linspace(-50, 50, 200));  % 200x200 grid from -50 to +50 in both X and Y

% Z coordinate calculation (based on equation of sphere)
R_square = radius^2 - (X - center(1)).^2 - (Y - center(2)).^2;
mask = R_square < 0;
R_square(mask) = 0;
Z = sqrt(R_square) + center(3);

Z = -(Z-2500);

% Add some random noise
%Z = Z + 0.01 * radius * randn(size(Z));

% Fit sphere to noisy data
[sphere_params, Z_fit] = fitSphere(X, Y, Z);

% Display the fitted sphere parameters
disp(sphere_params)

% Plot the original and fitted spheres
figure;
subplot(1, 2, 1);
imagesc(Z);colorbar;
%surf(X, Y, Z);
title('Original sphere with noise');

subplot(1, 2, 2);
%surf(X, Y, Z_fit);
imagesc(Z_fit);colorbar;
title('Fitted sphere');

imagesc(Z-Z_fit);colorbar;
