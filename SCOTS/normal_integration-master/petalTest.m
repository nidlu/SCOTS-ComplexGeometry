% Constants
clear all; close all; clc;
radius = 250;
innerRadius = 50;
gapWidth = 5; % width of the gap in pixels
petalStartRadius = 70; % radius at which the petals start
tiltStartRadius = petalStartRadius+10;
center = [300, 300];
nrows = 600;
ncols = 600;
n_petals = 6;
theta = linspace(0, 2*pi, n_petals+1); % angles for the petals
tilt = 0.2; % tilt for one of the petals

% Create a grid
[x, y] = meshgrid(1:ncols, 1:nrows);
y = flip(y);

% Create the mask and depth map
mask = zeros(nrows, ncols);
u = zeros(nrows, ncols);
for i = 1:n_petals
    % Calculate the angle for each point in the grid
    angle = atan2(y-center(2), x-center(1));
    angle(angle<0) = angle(angle<0) + 2*pi;  % Convert negative angles to positive
    
    % Calculate the radius for each point in the grid
    rad = sqrt((x-center(1)).^2 + (y-center(2)).^2);
    
    % Calculate the gap in angle based on the radius
    angleGap = gapWidth ./ rad;
    angleGap(rad < petalStartRadius) = 0;  % no gap inside petalStartRadius
    
    % Find the pixels inside the current petal
    in_petal = (rad <= radius) & ... % inside the outer circle
        (rad > innerRadius) & ... % outside the inner circle
        (angle >= theta(i) + angleGap) & ... % left of the right boundary
        (angle < theta(i+1) - angleGap); % right of the left boundary
    
    % Update the mask
    mask(in_petal) = 1;
    
    % Update the depth map
    u(in_petal) = rad(in_petal);
    
    % Apply the tilt to one of the petals
    if i == 3
        in_petal_tilt = in_petal & (rad > tiltStartRadius); % apply tilt only after tiltStartRadius
        u(in_petal_tilt) = u(in_petal_tilt) + 100 + tilt*(y(in_petal_tilt)-center(2));
    end
end

% Add Gaussian noise to the depth map
std_noise = 0.02*max(u(:));
u = u + std_noise*randn(size(u));

% Compute the gradients in the u- and v-directions
[p, q] = gradient(u);
